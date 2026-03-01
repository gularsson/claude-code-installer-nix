# claude-code-installer-nix

Auto-updated [Claude Code](https://github.com/anthropics/claude-code) standalone binary packaged for NixOS.

A GitHub Actions workflow checks for new releases daily and updates the flake automatically.

## Usage

Add as a flake input:

```nix
{
  inputs.claude-code = {
    url = "github:gularsson/claude-code-installer-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then use the package:

```nix
environment.systemPackages = [
  claude-code.packages.${system}.claude-code
];
```

## Update

```bash
nix flake update claude-code
```
