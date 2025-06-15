{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "plymouth-dracula-theme";
  version = "0-unstable-2021-01-14";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "plymouth";
    rev = "e6f2020f864946473fc0eff2174d74b085eebc5a";
    hash = "sha256-LGFiAz97GT4dUs0f0EQafANqL8KRstPIZq+iCBTb2FI=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes
    cp -r dracula $out/share/plymouth/themes
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {};

  meta = {
    description = "Dracula theme for Plymouth";
    homepage = "https://github.com/dracula/grub";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
