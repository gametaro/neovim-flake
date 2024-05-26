{
  description = "My Neovim flake";

  nixConfig = {
    extra-substituters = "https://myneovim.cachix.org";
    extra-trusted-public-keys = "myneovim.cachix.org-1:RN96eQV1gq1GL4tvIMNdBWztFnPcaO+9T5ah0I4O0Oo=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks-nix.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:nix-community/neovim-nightly-overlay";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    nvim-fx.url = "github:gametaro/nvim-fx";
    nvim-fx.flake = false;

    nvim-solo.url = "github:gametaro/nvim-solo";
    nvim-solo.flake = false;

    nvim-quickview.url = "github:gametaro/nvim-quickview";
    nvim-quickview.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    systems = ["aarch64-linux" "x86_64-linux"];
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        overlays = [inputs.neovim.overlays.default];
      });
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
  in {
    packages = forEachSystem (pkgs: import ./neovim.nix {inherit pkgs inputs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);
    checks = forEachSystem (pkgs: {
      pre-commit-check = inputs.pre-commit-hooks-nix.lib.${pkgs.system}.run {
        src = ./.;
        hooks = {
          actionlint.enable = true;
          alejandra.enable = true;
          editorconfig-checker.enable = true;
          deadnix.enable = true;
          flake-checker.enable = true;
          nil.enable = true;
          lua-ls.enable = true;
          lua-ls.settings = {
            configuration = lib.importJSON ./.luarc.json;
            checklevel = "Error";
          };
          statix.enable = true;
          stylua.enable = true;
        };
      };
    });
    devShells = forEachSystem (
      pkgs: {
        default = pkgs.mkShellNoCC {
          inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${pkgs.system}.pre-commit-check.enabledPackages;
        };
      }
    );
  };
}
