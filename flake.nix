{
  description = "Claude Code - auto-updated standalone binary";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    version = "2.1.286"; # auto-updated
    platforms = {
      "x86_64-linux" = {
        platform = "linux-x64";
        hash = "sha256-/lA/ZcYonVnCPlshrkTwNYP5l90zosv8datPlvuPxz8="; # auto-updated
      };
      "aarch64-linux" = {
        platform = "linux-arm64";
        hash = "sha256-ApL6Iqwv1D4Wvp0OUR3dg0coDW4Ousp0TvWyfgXY0Pg="; # auto-updated
      };
    };
    bucket = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
    mkPackage = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      meta = platforms.${system};
    in
      pkgs.stdenv.mkDerivation {
        pname = "claude-code";
        inherit version;

        src = pkgs.fetchurl {
          url = "${bucket}/${version}/${meta.platform}/claude";
          inherit (meta) hash;
        };

        dontUnpack = true;
        dontPatchELF = true;
        dontStrip = true;

        nativeBuildInputs = [pkgs.patchelf];

        installPhase = ''
          mkdir -p $out/bin
          install -m755 $src $out/bin/claude
          patchelf --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} $out/bin/claude
        '';

        meta = {
          description = "Claude Code - Anthropic's official CLI for Claude";
          homepage = "https://github.com/anthropics/claude-code";
          mainProgram = "claude";
          inherit (meta) platform;
        };
      };
  in {
    packages = builtins.mapAttrs (system: _: {
      claude-code = mkPackage system;
      default = mkPackage system;
    }) platforms;
  };
}
