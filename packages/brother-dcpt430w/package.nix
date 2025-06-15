{
  stdenv,
  lib,
  fetchurl,
  perl,
  ghostscript,
  coreutils,
  gnugrep,
  which,
  file,
  gnused,
  dpkg,
  makeWrapper,
  libredirect,
  debugLvl ? "0",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cups-brother-dcpt430w";
  version = "3.6.1-1";
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf106511/dcpt430wpdrv-${finalAttrs.version}.amd64.deb";
    hash = "sha256-LW9z0nA8RV8XdHnBfjVUPLEWaW3kFs9YqL7FQ96odJ4=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];
  buildInputs = [perl];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg-deb -x $src $out

    LPDDIR=$out/opt/brother/Printers/dcpt430w/lpd
    WRAPPER=$out/opt/brother/Printers/dcpt430w/cupswrapper/brother_lpdwrapper_dcpt430w


    ln -s $LPDDIR/${stdenv.hostPlatform.linuxArch}/* $LPDDIR/

    substituteInPlace $WRAPPER \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpt430w\"; #" \
      --replace-fail "basedir =~" "basedir = \"$out/opt/brother/Printers/dcpt430w/\"; #" \
      --replace-fail "lpdconf = " "lpdconf = \$lpddir.'/'.\$LPDCONFIGEXE.\$PRINTER; #" \
      --replace-fail "\$DEBUG=0;" "\$DEBUG=${debugLvl};"

    substituteInPlace $LPDDIR/filter_dcpt430w \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/dcpt430w/\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpt430w\"; #"

    wrapProgram $WRAPPER \
      --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        gnugrep
        gnused
      ]
    }

    wrapProgram $LPDDIR/filter_dcpt430w \
      --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        ghostscript
        gnugrep
        gnused
        which
        file
      ]
    }

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brdcpt430wfilter

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brprintconf_dcpt430w

    wrapProgram $LPDDIR/brprintconf_dcpt430w \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    wrapProgram $LPDDIR/brdcpt430wfilter \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    mkdir -p "$out/lib/cups/filter" "$out/share/cups/model"

    ln -s $out/opt/brother/Printers/dcpt430w/cupswrapper/brother_lpdwrapper_dcpt430w \
      $out/lib/cups/filter/brother_lpdwrapper_dcpt430w

    ln -s "$out/opt/brother/Printers/dcpt430w/cupswrapper/brother_dcpt430w_printer_en.ppd" \
      "$out/share/cups/model/"

    mkdir -p "$out/share/ppd/Brother" "$out/share/cups/model/Brother"
    ln -s "$out/opt/brother/Printers/dcpt430w/cupswrapper/brother_dcpt430w_printer_en.ppd" \
      "$out/share/ppd/Brother/"
    ln -s "$out/opt/brother/Printers/dcpt430w/cupswrapper/brother_dcpt430w_printer_en.ppd" \
      "$out/share/cups/model/Brother/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Brother DCP-T430W printer driver";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    maintainers = with maintainers; [];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    downloadPage = "https://support.brother.com/g/b/downloadtop.aspx?c=us_ot&lang=en&prod=dcpt430w_all";
    homepage = "http://www.brother.com/";
  };
})
