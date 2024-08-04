{ stdenv, fetchzip, lib
, makeWrapper
, autoPatchelfHook
, xorg
, libpng12
, gtk3
, adwaita-icon-theme
}:
stdenv.mkDerivation rec {
  name = "ns-atmosphere-programmer-${version}";
  version = "0.1";

  src = fetchzip {
    url = "https://archive.org/download/ns-atmosphere-programmer/ns-atmosphere-programmer-ubuntu-64bit-v01.zip";
    # original source: http://www.ns-atmosphere.com/media/content/ns-atmosphere-programmer-ubuntu-64bit-v01.zip
    sha256 = "1cnyydsmrcpfwpdiry7qybh179499wpbvlzq5rk442hq9ak416ri";
  };

  buildInputs = with xorg; [ libX11 libXxf86vm libSM gtk3 libpng12 ];
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase = ''
    install -D -m755 NS-Atmosphere $out/bin/NS-Atmosphere
    wrapProgram $out/bin/NS-Atmosphere --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
--suffix XDG_DATA_DIRS : '${adwaita-icon-theme}/share'
  '';

  dontStrip = true;

  meta = with lib; {
    description = "Payload programmer for ns-atmosphere injector for nintendo switch";
    homepage = http://www.ns-atmosphere.com;
    maintainers = [ maintainers.makefu ];
    platforms = platforms.linux;
    license = with licenses; [ unfree ];
  };

}
