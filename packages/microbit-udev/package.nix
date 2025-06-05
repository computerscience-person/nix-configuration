{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "microbit-udev";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "SerElliot";
    repo = "microbit-udev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E5kSwdyDo9h9Z9TvBHmTjhzfwZyBqcc5NdsRW2X3360=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r microbit-udev/lib $out

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Udev rules for BBC micro:bit.";
    homepage = "https://github.com/SerElliot/microbit-udev";
    license = with lib.licenses; [
      asl20 mit
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
})
