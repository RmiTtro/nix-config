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
    
    # This is to have the latest tiddlywiki version
    # To get what to pass to src, I did the following:
    # 1. Create a package.json file with 
    #    [
    #      "tiddlywiki"
    #    ]
    # 2. run `nix run nixpkgs#node2nix` in the same directory where the package.json file is
    # 3. A file named node-packages.nix will be generated containing the information
    nodePackages_latest.tiddlywiki = prev.nodePackages_latest.tiddlywiki.override {
      version = "5.3.8";
      src = final.fetchurl {
        url = "https://registry.npmjs.org/tiddlywiki/-/tiddlywiki-5.3.8.tgz";
        sha512 = "T25acZfdhAX/lUVPY/9SXo7bMJKgSaMs5PDOb83S2WKbTCD7DnOUQ4aC3qDy0j5XqlCn4ih3mzMWct3xnQx+Mw==";
      };
    };
  };
}