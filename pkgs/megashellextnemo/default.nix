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
  version = "5.14.0.2";

  src = fetchFromGitHub {
    owner = "meganz";
    repo = "MEGAsync";
    rev = "v${version}_Linux";
    sha256 = "sha256-SEr9pP0tMT5ZLCelZAT4Kxf5L3Dj/lIB35587jE8CXg=";
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

  prePatch = ''
    cd src/MEGAShellExtNemo
  '';

  # This fix is needed since the path represented by DESKTOP_DESTDIR is already part of the path represented by EXTENSIONS_PATH
  # We are basically putting it back to how it was before
  # Apparently they added the DESKTOP_DESTDIR to the target path to fix some bug, but in our case this create some issues
  postPatch = ''
    substituteInPlace MEGAShellExtNemo.pro --replace-fail 'target.path = $${DESKTOP_DESTDIR}$${EXTENSIONS_PATH}' 'target.path = $${EXTENSIONS_PATH}'
  '';

  enableParallelBuilding = true;

  PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";
  DESKTOP_DESTDIR="${placeholder "out"}";

  meta = with lib; {
    description =
      "MEGA file manager integration for Nemo";
    homepage = "https://mega.nz/";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ ];
  };
}
