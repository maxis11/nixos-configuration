{
  allowUnfree = true;
  packageOverrides = pkgs: rec {
    neovim-custom = pkgs.neovim.override {
      configure = {
        customRC = ''
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ youcompleteme fugitive  ];
          opt = [ vim-addon-nix  clang_complete ];
        };
      };
    };
  };
}

