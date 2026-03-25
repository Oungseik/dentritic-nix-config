#!/usr/bin/env python3
"""Heuristic checker for a dendritic Nix flake layout."""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path


@dataclass
class Finding:
    level: str
    path: Path
    message: str


EXPORT_RE = re.compile(r"flake\.(?P<kind>[a-zA-Z]+)\.(?:\"(?P<quoted>[^\"]+)\"|(?P<bare>[A-Za-z0-9_-]+))\s*=")


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def add(findings: list[Finding], level: str, path: Path, message: str) -> None:
    findings.append(Finding(level=level, path=path, message=message))


def find_repo_root(start: Path) -> Path | None:
    for candidate in [start, *start.parents]:
        if (candidate / "flake.nix").exists():
            return candidate
    return None


def stem_matches_export(text: str, kind: str, stem: str) -> bool:
    patterns = [
        rf"flake\.{re.escape(kind)}\.{re.escape(stem)}\s*=",
        rf'flake\.{re.escape(kind)}\."{re.escape(stem)}"\s*=',
    ]
    return any(re.search(pattern, text) for pattern in patterns)


def export_names(text: str, kind: str) -> list[str]:
    names: list[str] = []
    for match in EXPORT_RE.finditer(text):
        if match.group("kind") != kind:
            continue
        names.append(match.group("quoted") or match.group("bare"))
    return names


def self_reference_exists(text: str, kind: str, name: str) -> bool:
    patterns = [
        rf"self\.{re.escape(kind)}\.{re.escape(name)}\b",
        rf'self\.{re.escape(kind)}\."{re.escape(name)}"',
    ]
    return any(re.search(pattern, text) for pattern in patterns)


def check_root(repo_root: Path, findings: list[Finding]) -> None:
    flake_path = repo_root / "flake.nix"
    if not flake_path.exists():
        add(findings, "ERROR", flake_path, "Missing flake.nix.")
        return

    text = read_text(flake_path)
    modules_dir = repo_root / "modules"

    if not modules_dir.exists():
        add(findings, "WARN", modules_dir, "Repository does not contain a modules/ tree yet.")

    for pattern, message in [
        (r"\bnetworking\.hostName\b", "Move hostnames out of flake.nix and into a concrete host branch."),
        (r"\bsystem\.stateVersion\b", "Move system.stateVersion out of flake.nix and into a concrete host branch."),
        (r"\bhome\.username\b", "Move home.username out of flake.nix and into a concrete home branch."),
        (r"\bhome\.homeDirectory\b", "Move home.homeDirectory out of flake.nix and into a concrete home branch."),
        (r"\bboot\.loader\b", "Move boot loader settings out of flake.nix and into a concrete host branch."),
    ]:
        if re.search(pattern, text):
            add(findings, "ERROR", flake_path, message)


def check_required_directories(repo_root: Path, findings: list[Finding]) -> None:
    modules_dir = repo_root / "modules"
    if not modules_dir.exists():
        return

    for subdir in ["hosts", "nixosModules", "home", "homeModules"]:
        path = modules_dir / subdir
        if not path.exists():
            add(findings, "WARN", path, f"Expected modules/{subdir} to exist for a complete dendritic tree.")


def check_shared_modules(
    repo_root: Path,
    findings: list[Finding],
    subdir: str,
    export_kind: str,
    banned_patterns: list[tuple[str, str]],
) -> list[str]:
    names: list[str] = []
    directory = repo_root / "modules" / subdir
    if not directory.exists():
        return names

    for path in sorted(directory.glob("*.nix")):
        text = read_text(path)
        stem = path.stem
        exports = export_names(text, export_kind)
        names.extend(exports)

        if len(exports) != 1:
            add(findings, "ERROR", path, f"Expected exactly one {export_kind} export, found {len(exports)}.")
        if not stem_matches_export(text, export_kind, stem):
            add(findings, "ERROR", path, f"Expected {export_kind}.{stem} to match the filename.")
        if "self.nixosConfigurations." in text or "self.homeConfigurations." in text:
            add(findings, "ERROR", path, "Shared branch references a concrete configuration branch.")

        for pattern, message in banned_patterns:
            if re.search(pattern, text):
                add(findings, "ERROR", path, message)

    return names


def check_hosts(repo_root: Path, findings: list[Finding]) -> list[str]:
    names: list[str] = []
    directory = repo_root / "modules" / "hosts"
    if not directory.exists():
        return names

    for path in sorted(directory.glob("*.nix")):
        text = read_text(path)
        config_exports = export_names(text, "nixosConfigurations")
        if not config_exports:
            add(findings, "ERROR", path, "Host branch does not export any nixosConfigurations entry.")
        names.extend(config_exports)
        if "self.nixosModules." not in text:
            add(findings, "WARN", path, "Host branch does not compose any shared or host-scoped nixosModules branch through self.nixosModules.")

    return names


def check_home(repo_root: Path, findings: list[Finding]) -> list[str]:
    names: list[str] = []
    directory = repo_root / "modules" / "home"
    if not directory.exists():
        return names

    for path in sorted(directory.glob("*.nix")):
        text = read_text(path)
        config_exports = export_names(text, "homeConfigurations")
        if not config_exports:
            add(findings, "ERROR", path, "Home branch does not export any homeConfigurations entry.")
        names.extend(config_exports)
        if "self.homeModules." not in text:
            add(findings, "WARN", path, "Home branch does not compose any shared or user-scoped homeModules branch through self.homeModules.")

    return names


def check_usage(repo_root: Path, findings: list[Finding], export_kind: str, names: list[str]) -> None:
    modules_root = repo_root / "modules"
    if not modules_root.exists():
        return

    all_text = "\n".join(read_text(path) for path in sorted(modules_root.rglob("*.nix")))
    for name in sorted(set(names)):
        if not self_reference_exists(all_text, export_kind, name):
            add(findings, "WARN", modules_root, f"{export_kind}.{name} is exported but never referenced through self.{export_kind}.{name}.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Check a repository for dendritic Nix layout issues.")
    parser.add_argument("repo_root", nargs="?", help="Path to the repository root; defaults to the nearest ancestor containing flake.nix")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else find_repo_root(Path.cwd())
    if repo_root is None:
        print("ERROR: could not find a flake.nix in the current directory or any parent directory.", file=sys.stderr)
        return 2

    findings: list[Finding] = []

    check_root(repo_root, findings)
    check_required_directories(repo_root, findings)

    nixos_module_names = check_shared_modules(
        repo_root,
        findings,
        "nixosModules",
        "nixosModules",
        [
            (r"\bsystem\.stateVersion\b", "Move system.stateVersion into a concrete host branch."),
            (r"\bboot\.loader\b", "Move boot loader settings into a concrete host branch."),
            (r"\bfileSystems\.", "Move filesystem declarations into a concrete host branch."),
            (r"\bswapDevices\b", "Move swap configuration into a concrete host branch."),
            (r"/dev/disk/by-uuid", "Move disk identifiers into a concrete host branch."),
            (r"\bmodulesPath\b", "Avoid hardware scan imports in shared branches."),
            (r"\bnetworking\.hostName\b", "Move hostnames into a concrete host branch."),
        ],
    )
    home_module_names = check_shared_modules(
        repo_root,
        findings,
        "homeModules",
        "homeModules",
        [
            (r"\bhome\.username\b", "Move home.username into a concrete home branch."),
            (r"\bhome\.homeDirectory\b", "Move home.homeDirectory into a concrete home branch."),
            (r"\bhome\.stateVersion\b", "Move home.stateVersion into a concrete home branch."),
        ],
    )
    check_hosts(repo_root, findings)
    check_home(repo_root, findings)
    check_usage(repo_root, findings, "nixosModules", nixos_module_names)
    check_usage(repo_root, findings, "homeModules", home_module_names)

    if not findings:
        print("OK: no dendritic layout findings")
        return 0

    errors = 0
    warnings = 0
    for finding in findings:
        if finding.level == "ERROR":
            errors += 1
        elif finding.level == "WARN":
            warnings += 1
        rel = finding.path.relative_to(repo_root) if finding.path.is_relative_to(repo_root) else finding.path
        print(f"{finding.level}: {rel}: {finding.message}")

    print(f"\nSummary: {errors} error(s), {warnings} warning(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
