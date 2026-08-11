# Changelog

All notable changes to csverify are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and version numbers follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added `Public`, `Private`, `Private/Helpers`, and reserved `Lib` module directories.
- Added strict legacy-manifest parsing with SHA-256, field-count, relative-path, and duplicate-path validation.
- Added path-keyed expected and current record indexes.
- Added Pester coverage for module exports, private helper visibility, duplicate-content files, modified files, missing files, unexpected files, and malformed manifests.

### Changed

- Changed the root module into an explicit loader that imports private files before public commands and exports only the declared public API.
- Changed checksum enumeration to deterministic ordinal relative-path ordering.
- Changed checksum and verification output to raw objects without ANSI escape sequences or PowerShell formatting metadata.
- Changed operational console messages to opt-in verbose messages.
- Changed build packaging configuration to include `Public`, `Private`, and `Lib` instead of the legacy `libs` tree.
- Changed the GitLab Pester job to execute the repository's current unit-test suite.
- Changed module and Chocolatey metadata to describe csverify's checksum-verification behavior and use repository-specific documentation links.

### Fixed

- Fixed false failures when two or more paths contain identical bytes and share the same SHA-256 hash.
- Fixed verification so expected files missing from disk fail as `Missing`.
- Fixed verification so current files absent from the manifest fail as `Unexpected`.
- Fixed the inconsistent verified-result path property previously emitted as `sath`.
- Fixed clean-process execution failures caused by the undeclared `csole` dependency.
- Fixed test isolation failures caused by changing the process working directory without guaranteed restoration.

### Removed

- Removed `$global:_csverify` and its stored formatting scriptblocks.
- Removed the embedded `Get-ColorTune` and `cfbytes` legacy helper modules.
- Removed the nested public command `.psm1` files from `libs`.

## [0.3.8] - 2026-02-27

### Added

- Added the initial `New-CheckSum`, `Read-CheckSum`, `New-VerificationFile`, and `Test-Verification` command set.
- Added recursive SHA-256 checksum generation and legacy `VERIFICATION.txt` parsing.
- Added Chocolatey installation, modification, and uninstall scripts.
- Added Pester tests, GitLab CI jobs, automator-devops build configuration, package metadata, and release assets.
- Added embedded color and byte-formatting helpers used by the original console output.

### Changed

- Updated path handling to use resolved filesystem paths and `System.IO.Path` composition.
- Updated `New-VerificationFile` parameter names to `RootPath` and `OutputPath`.
- Updated `Read-CheckSum` to accept `File` and `FromString` inputs.
- Updated `New-CheckSum` to omit generated `.nuspec` metadata and `VERIFICATION.txt` files.
- Updated verification to throw on detected failures for build-pipeline use.
- Updated module, Chocolatey, GitLab, icon, license, and package metadata.

### Fixed

- Fixed verified and failed record count reporting.
- Fixed module dependency paths for the bundled color and byte-formatting helpers.
- Fixed GitLab CI configuration and build-config object references.

### Notes

- `v0.3.8` is the first repository tag, so this entry summarizes the complete implementation history available at that release.
- At this tag, `Get-ConventionalCommitVersion` resolved the repository to `0.3.8` with no semantic-version bump.

[Unreleased]: https://gitlab.com/phellams/csverify/-/compare/v0.3.8...develop
[0.3.8]: https://gitlab.com/phellams/csverify/-/releases/v0.3.8
