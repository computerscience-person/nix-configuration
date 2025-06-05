{
  lib,
  fetchFromGitHub,
  vimUtils
}:

vimUtils.buildVimPlugin {
  name = "love2d.nvim";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "S1M0N38";
    repo = "love2d.nvim";
    tag = "v1.0.1";
    hash = "sha256-8sLDGW2hyyfCk4IaN+s5vsHSlRsKKl1XsFE7I/zFRmU=";
  };
}
