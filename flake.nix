{
  description = "My Neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
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
    in {
      packages = rec {
        default = nvim;
        nvim = pkgs.neovim;
      };
      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            lua-language-server
            nil
            stylua
          ];
        };
      };
    });
}
