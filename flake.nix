{
  description = "My Neovim flake";

  nixConfig = {
    extra-substituters = "https://myneovim.cachix.org";
    extra-trusted-public-keys = "myneovim.cachix.org-1:RN96eQV1gq1GL4tvIMNdBWztFnPcaO+9T5ah0I4O0Oo=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:neovim/neovim/35a147fa77f28e3e9b5eaa217b5b383b59b6c9d2?dir=contrib";
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
    nvim-fx = {
      url = "github:gametaro/nvim-fx";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.devshell.flakeModule
      ];

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
        plugins = builtins.attrValues (builtins.mapAttrs (pname: src:
          pkgs.vimUtils.buildVimPlugin {
            inherit pname src;
            version = src.lastModifiedDate;
          }) (builtins.removeAttrs inputs [
          "devshell"
          "flake-parts"
          "neovim"
          "nixpkgs"
          "pre-commit-hooks-nix"
          "self"
        ]));

        nvim = pkgs.wrapNeovimUnstable inputs'.neovim.packages.neovim {
          luaRcContent = builtins.readFile ./init.lua;
          packpathDirs.myNeovimPackages = {
            start = with pkgs.vimPlugins;
              [nvim-treesitter.withAllGrammars]
              ++ plugins;
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

        pre-commit = {
          settings = {
            hooks = {
              actionlint.enable = true;
              alejandra.enable = true;
              editorconfig-checker.enable = true;
              lua-ls.enable = false;
              nil.enable = true;
              statix.enable = true;
              stylua.enable = true;
              yamllint.enable = true;
            };
          };
        };

        devshells.default = {
          packages = with pkgs; [
            actionlint
            alejandra
            editorconfig-checker
            lua-language-server
            nil
            statix
            stylua
            yaml-language-server
          ];
          devshell = {
            motd = "";
            startup.pre-commit.text = "${config.pre-commit.installationScript}";
          };
        };
      };
    };
}
