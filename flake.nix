{
  description = "Korangar Packets - A Rustler NIF for Elixir to handle Ragnarok Online packets";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    rust-overlay,
  }:
    utils.lib.eachDefaultSystem (system: let
      overlays = [(import rust-overlay)];
      pkgs = (import nixpkgs) {inherit system overlays;};
      erlang = pkgs.erlang_28;
      elixir = pkgs.beam.packages.erlang_28.elixir_1_19;
      libraries = with pkgs; [pkg-config];
      rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      packages = with pkgs; [erlang elixir elixir-ls openssl];
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = packages;
        nativeBuildInputs = [rustToolchain] ++ libraries;

        RUST_BACKTRACE = "full";
        RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;

        shellHook = ''
          export MIX_HOME=$PWD/.nix-mix
          export HEX_HOME=$PWD/.nix-hex
          export ERL_AFLAGS="-kernel shell_history enabled"
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
        '';
      };

      formatter = pkgs.alejandra;
    });
}
