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

    nvim-fx = {
      url = "github:gametaro/nvim-fx";
      flake = false;
    };
    nvim-solo = {
      url = "github:gametaro/nvim-solo";
      flake = false;
    };
    nvim-quickview = {
      url = "github:gametaro/nvim-quickview";
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
          }) {
          inherit (inputs) nvim-fx;
          inherit (inputs) nvim-solo;
        });

        extraPackages = with pkgs; [
          actionlint
          alejandra
          lua-language-server
          nil
          nodePackages.bash-language-server
          nodePackages.dockerfile-language-server-nodejs
          shellcheck
          shfmt
          statix
          stylua
          vscode-langservers-extracted
          yaml-language-server
        ];

        nvim = pkgs.wrapNeovimUnstable inputs'.neovim.packages.neovim {
          luaRcContent = builtins.readFile ./init.lua;
          packpathDirs.myNeovimPackages = {
            start = with pkgs.vimPlugins;
              [
                SchemaStore-nvim
                cmp-buffer
                cmp-nvim-lsp
                conform-nvim
                diffview-nvim
                flash-nvim
                gitsigns-nvim
                mini-nvim
                nvim-cmp
                nvim-lint
                nvim-treesitter.withAllGrammars
                telescope-nvim
                vim-illuminate
                vim-repeat
              ]
              ++ plugins;
          };
          viAlias = true;
          vimAlias = true;
          withPython3 = false;
          wrapperArgs = ''--suffix PATH : "${pkgs.lib.makeBinPath extraPackages}"'';
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
