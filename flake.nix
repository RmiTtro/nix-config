{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-f89c670.url = "github:nixos/nixpkgs/f89c670a01ba9b5e2c29c2f692fd654dfab686b5";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    
    hardware.url = "github:nixos/nixos-hardware";
    
    geany-themes = {
      url = "github:geany/geany-themes";
      flake = false;
    };
    
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    
    # TODO: Transfert everything relathing to cuda to their own flake
    
    cuda_find_in_files4 = {
      url = "github:CudaText-addons/cuda_find_in_files4";
      flake = false;
    };
    
    cuda_differ = {
      url = "github:CudaText-addons/cuda_differ";
      flake = false;
    };
    
    cuda_fmt = {
      url = "github:CudaText-addons/cuda_fmt";
      flake = false;
    };
    
    cuda_fmt_js = {
      url = "github:CudaText-addons/cuda_fmt_js";
      flake = false;
    };
    
    # Does not work because of https://github.com/NixOS/nix/issues/7083
    #cudaTheme_dracula = {
    # url = "file+https://sourceforge.net/projects/cudatext/files/addons/themes/theme.Dracula.zip";
    # flake = false;
    #};

    cudaTheme_darcula = {
      url = "github:CudaText-addons/cudatext-theme-darcula";
      flake = false;
    };
    
    cudatext-lexers = {
      url = "github:Alexey-T/CudaText-lexers";
      flake = false;
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-f89c670,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "x86_64-linux"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
    
    makeHostnameOption = hostname: {lib, ...}: {
      options = {
        hostname = lib.mkOption {
          type = lib.types.str;
          default = hostname;
        };
      };
    };

    # We create a specific module instead of using specialArgs to avoid having to manually specify the system
    makeSpecificNixPkgsVersionModule = specificNixPkgsVersionName: {pkgs, ...}: 
      let
        specificNixPkgsVersionValue = inputs."${specificNixPkgsVersionName}";
        specificPkgsVersionName = nixpkgs.lib.strings.replaceStrings ["nix"] [""] specificNixPkgsVersionName;
      in
      {
        _module.args."${specificPkgsVersionName}" = import specificNixPkgsVersionValue { system = pkgs.system; };
      };

    makeNixosSystem = {hostname, additionalModules ? []}: {
      "${hostname}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        # > Our main nixos configuration file <
        modules = [
          (makeHostnameOption hostname)
          ./hosts/${hostname}
          (makeSpecificNixPkgsVersionModule "nixpkgs-f89c670")
        ] ++ additionalModules;
      };
    };
    
  in 
  {
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs {pkgs = nixpkgs.legacyPackages.${system};});
    overlays = import ./overlays { inherit inputs outputs; };
    lib = import ./lib { inherit (nixpkgs) lib; };
    
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = nixpkgs.lib.mergeAttrsList [
      (makeNixosSystem { hostname = "asus-laptop-TUF517ZR"; })
    ];
  };
}
