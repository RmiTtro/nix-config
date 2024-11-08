{ lib
, mkDerivation
, fetchFromGitHub
, pkg-config
, qtbase
, qttools
, qmake
, nemo
, gtk3
}:
mkDerivation rec {
  pname = "megashellextnemo";
  version = "4.9.0.0";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAsync";
    rev = "v${version}_Linux";
    sha256 = "sha256-s0E8kJ4PJmhaxVcWPCyCk/KbcX4V3IESdZhSosPlZuM=";
  };

  nativeBuildInputs = [
    pkg-config
    qttools
    qmake
  ];
  buildInputs = [
    qtbase
    nemo
    gtk3
  ];

  enableParallelBuilding = true;

  PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";
  DESKTOP_DESTDIR="${placeholder "out"}";


  preConfigure = ''
    cd src/MEGAShellExtNemo
  '';

  meta = with lib; {
    description =
      "MEGA file manager integration for Nemo";
    homepage = "https://mega.nz/";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ ];
  };
}
