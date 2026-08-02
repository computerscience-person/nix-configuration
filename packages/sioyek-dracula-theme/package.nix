{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "plymouth-dracula-theme";
  version = "0-unstable-2023-11-23";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "sioyek";
    rev = "b832ab04d880fbe243c0fe9043612be61226426e";
    hash = "sha256-+HzxZA8Bb+cGogK+w4JES4ZFG+ueXEAuLu+0T18fvbc=";
  };

  dontBuild = true;
  passthru.updateScript = unstableGitUpdater {};
  meta = {
    description = "Dracula theme for Sioyek";
    homepage = "https://github.com/dracula/sioyek";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
