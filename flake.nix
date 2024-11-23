{
  description = "explore-the-blockchain";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ flake-parts, devenv-root, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devenv.shells.default = {
          devenv.root =
            let
              devenvRootFileContent = builtins.readFile devenv-root.outPath;
            in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          name = "explore-the-blockchain";

          imports = [ ];

          # https://devenv.sh/reference/options/
          packages = [
            # pkgs.bitcoin
            (pkgs.writeShellScriptBin "bitcoin-cli" ''
              #!/usr/bin/env bash
              exec ${pkgs.bitcoin}/bin/bitcoin-cli -datadir=./ "$@"
            '')
            pkgs.jq
            pkgs.unixtools.xxd
          ];

          files."bitcoin.conf".text = ''
            rpcconnect=84.247.182.145
            rpcuser=user_087
            rpcpassword=T2bK3yxSXBc9
            datadir=.
          '';

          enterShell = ''
          '';
        };
      };
      flake = { };
    };
}
