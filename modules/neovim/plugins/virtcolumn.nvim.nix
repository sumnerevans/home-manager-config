# Enable git blame on the line.
{ pkgs, ... }:
let
  virtcolumn = pkgs.vimUtils.buildVimPlugin {
    pname = "virtcolumn";
    version = "unstable-2024-02-13";
    src = pkgs.fetchFromGitHub {
      owner = "xiyaowong";
      repo = "virtcolumn.nvim";
      rev = "4d385b4aa42aa3af6fa2cb8527462fa4badbd163";
      sha256 = "sha256-4Q7dbgu/YxpHTLrMgGzJ2DaAuaH9VhkVTrtlbFmPYZY=";
    };

    patches = [
      (pkgs.fetchpatch {
        url =
          "https://patch-diff.githubusercontent.com/raw/xiyaowong/virtcolumn.nvim/pull/11.patch";
        hash = "sha256-Dd4UrU/ZPCnvu8LOl+oJ2Te82eUePQYzPG4KL8ovzrU=";
      })
    ];

    meta.homepage = "https://github.com/xiyaowong/virtcolumn.nvim";
  };
in { programs.neovim.plugins = [ virtcolumn ]; }
