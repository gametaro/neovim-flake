{
  description = "My Neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    conform-nvim = {
      url = "github:stevearc/conform.nvim";
      flake = false;
    };
    diffview-nvim = {
      url = "github:sindrets/diffview.nvim";
      flake = false;
    };
    flash-nvim = {
      url = "github:folke/flash.nvim";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    nvim-lint = {
      url = "github:mfussenegger/nvim-lint";
      flake = false;
    };
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    schemastore-nvim = {
      url = "github:b0o/schemastore.nvim";
      flake = false;
    };
    telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    vim-illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    vim-repeat = {
      url = "github:tpope/vim-repeat";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # flake.overlays.default = inputs.neovim-nightly-overlay.overlay;

      perSystem = {
        config,
        lib,
        system,
        inputs',
        pkgs,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.neovim-nightly-overlay.overlay
            (final: prev: {
              neovim = prev.wrapNeovimUnstable prev.neovim-unwrapped {
                luaRcContent = builtins.readFile ./init.lua;
                packpathDirs.myNeovimPackages = {
                  start = with prev.vimPlugins;
                    [nvim-treesitter.withAllGrammars]
                    ++ builtins.attrValues (builtins.mapAttrs (pname: src:
                      prev.vimUtils.buildVimPlugin {
                        inherit pname src;
                        version = src.lastModifiedDate;
                      }) (builtins.removeAttrs inputs ["self" "nixpkgs" "flake-utils"]));
                };
                viAlias = true;
                vimAlias = true;
                withPython3 = false;
              };
            })
          ];
        };

        packages = {
          default = config.packages.nvim;
          nvim = pkgs.neovim;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            lua-language-server
            nil
            alejandra
            stylua
          ];
        };
      };
    });
}
