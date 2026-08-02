{
  lib,
  fetchurl,
}:

fetchurl {
  pname = "Catrinity";
  version = "2.23";

  url = "https://catrinity-font.de/downloads/Catrinity.otf";
  hash = "sha256-805TbADj3Bse590eXJPuCIm/k35QL16OmXM18UyzRkE=";

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    runHook preInstall

    install -m 644 -D $downloadedFile $out/share/fonts/opentype/Catrinity.otf

    runHook postInstall    
  '';

  meta = {
    homepage = "https://catrinity-font.de";
    description = "Free sans-serif OpenType font, with wide language support.";
    longDescription = ''
      Catrinity is a free sans-serif OpenType font. The design intends to be
      clean and easy, wit just enough embellishment to make the characters
      well distinguishable, and the font as a whole distinguishable from other
      sans-serif fonts.
    '';
    maintainers = with lib.maintainers; [
    ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
