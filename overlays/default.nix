{outputs, inputs}:
let
  addPatches = pkg: patches: pkg.overrideAttrs (oldAttrs: {
  	patches = (oldAttrs.patches or [ ]) ++ patches;
  });
in
{
  # Adds my custom packages
  additions = final: prev: import ../pkgs { pkgs = final; };

  # Modifies existing packages
  modifications = final: prev: {
  	cudatext = addPatches prev.cudatext [ ./patches/cudatext/proc_globdata.patch ];

    # TODO: Remove this overlay once vopono version 1.0.2 is in nixpkgs
    # This overlay is because the vopono version 1.0.1 that is in nixpkgs bug on my machine, while the newer version work well
    vopono = prev.vopono.overrideAttrs (
      finalAttrs: previousAttrs: {
        version = "1.0.2";

        doCheck = false;
                                                                           
        src = final.fetchCrate {
          inherit (finalAttrs) pname version;
          hash = "sha256-/zy5VKZO0dptLqM+4kVD3U9p/udgrxw/myjMSBYyDQU=";
        };

        cargoDeps = final.rustPlatform.importCargoLock {
          lockFile = finalAttrs.src + "/Cargo.lock";
          allowBuiltinFetchGit = true;
        };
        cargoHash = null;
      }
    );

    # TODO: Remove this overlay once I transition to using wayland
    # This overlay is to have asusctl compiled with X11 support
    asusctl = prev.asusctl.overrideAttrs(
      finalAttrs: previousAttrs: {
        cargoBuildFeatures = previousAttrs.cargoBuildFeatures ++ [
          "rog-control-center/x11"
        ];

        buildInputs = previousAttrs.buildInputs ++ [
          final.libX11
          final.libXcursor
          final.libXi
        ];

        postInstall = ''
          make prefix=$out install-data

          patchelf $out/bin/rog-control-center \
            --add-needed ${final.lib.getLib final.libxkbcommon}/lib/libxkbcommon.so.0 \
            --add-needed ${final.lib.getLib final.libxkbcommon}/lib/libxkbcommon-x11.so.0 
        '';
      }
    );
  };
}