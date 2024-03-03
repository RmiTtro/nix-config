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
  };
}