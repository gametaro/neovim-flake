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
    inherit (inputs) nvim-quickview;
  });

  extraPackages = with pkgs; [
    actionlint
    alejandra
    biome
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
    vtsls
    yaml-language-server
  ];

  nvim = pkgs.wrapNeovimUnstable inputs.neovim.packages.${pkgs.system}.neovim {
    neovimRcContent = "";
    luaRcContent = builtins.readFile ./init.lua;
    plugins = with pkgs.vimPlugins;
      [
        nvim-treesitter.withAllGrammars
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
