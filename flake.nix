{
  description = "My Neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = {
        config,
        inputs',
        pkgs,
        ...
      }: let
        nvim = pkgs.wrapNeovimUnstable inputs'.neovim.packages.neovim {
          luaRcContent = builtins.readFile ./init.lua;
          packpathDirs.myNeovimPackages = {
            start = with pkgs.vimPlugins;
              [nvim-treesitter.withAllGrammars]
              ++ builtins.attrValues (builtins.mapAttrs (pname: src:
                pkgs.vimUtils.buildVimPlugin {
                  inherit pname src;
                  version = src.lastModifiedDate;
                }) (builtins.removeAttrs inputs ["self" "nixpkgs" "flake-utils"]));
          };
          viAlias = true;
          vimAlias = true;
          withPython3 = false;
        };
      in {
        packages = {
          inherit nvim;
          default = config.packages.nvim;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            lua-language-server
            nil
            statix
            stylua
          ];
        };
      };
    };
}
