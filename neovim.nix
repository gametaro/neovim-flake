{
  pkgs,
  inputs,
  ...
}: let
  plugins = builtins.attrValues (builtins.mapAttrs (pname: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    }) {
    inherit (inputs) nvim-fx;
    inherit (inputs) nvim-solo;
    inherit (inputs) nvim-quickview;
  });

  extraPackages = with pkgs; [
    actionlint
    alejandra
    efm-langserver
    fd
    lua-language-server
    markdownlint-cli
    nil
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.typescript-language-server
    prettierd
    pyright
    ripgrep
    ruff
    shellcheck
    shfmt
    statix
    stylua
    vscode-langservers-extracted
    yaml-language-server
  ];

  nvim = pkgs.wrapNeovimUnstable inputs.neovim.packages.${pkgs.system}.neovim {
    neovimRcContent = "";
    luaRcContent = builtins.readFile ./init.lua;
    plugins = with pkgs.vimPlugins;
      [
        SchemaStore-nvim
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        diffview-nvim
        efmls-configs-nvim
        flash-nvim
        gitsigns-nvim
        mini-nvim
        nvim-cmp
        nvim-treesitter.withAllGrammars
        telescope-nvim
        tokyonight-nvim
        vim-repeat
      ]
      ++ plugins;
    withPython3 = false;
    wrapperArgs = ["--suffix" "PATH" ":" "${pkgs.lib.makeBinPath extraPackages}"];
  };

  nvim-clean = pkgs.writeShellScriptBin "nvim-clean" ''
    ${inputs.neovim.packages.${pkgs.system}.neovim}/bin/nvim --clean "$@"
  '';
in {
  default = nvim;
  inherit nvim;
  inherit nvim-clean;
}
