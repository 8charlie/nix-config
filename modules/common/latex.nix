{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # all of TeX Live, so a \usepackage never fails; also provides latexmk
    # (vimtex's compiler), biber, chktex and latexindent (conform's formatter)
    texliveFull

    # LaTeX language server, enabled in dots/nvim/init.lua
    texlab
  ];
}
