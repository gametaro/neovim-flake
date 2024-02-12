{
  pkgs,
  inputs,
  ...
}: let
  inherit
    (builtins)
    attrValues
    mapAttrs
    readFile
    ;

  plugins = attrValues (mapAttrs (pname: src:
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
    ripgrep
    shellcheck
    shfmt
    statix
    stylua
    vscode-langservers-extracted
    yaml-language-server
  ];

  nvim = pkgs.wrapNeovimUnstable inputs.neovim.packages.${pkgs.system}.neovim {
    luaRcContent = readFile ./init.lua;
    packpathDirs.myNeovimPackages = {
      start = with pkgs.vimPlugins;
        [
          SchemaStore-nvim
          cmp-buffer
          cmp-path
          cmp-nvim-lsp
          diffview-nvim
          efmls-configs-nvim
          flash-nvim
          gitsigns-nvim
          mini-nvim
          nvim-cmp
          nvim-treesitter.withAllGrammars
          telescope-nvim
          vim-repeat
        ]
        ++ plugins;
    };
    withPython3 = false;
    wrapperArgs = ''
      --suffix PATH : "${pkgs.lib.makeBinPath extraPackages}"
    '';
  };
in {
  default = nvim;
  inherit nvim;
}
