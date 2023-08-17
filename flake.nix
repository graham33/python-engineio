{
  description = "python-engineio v3";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (self: super: {
          nur = import nur {
            nurpkgs = self;
            pkgs = self;
          };
        })
      ];
    };
    python3 = pkgs.python311;
    python3Packages = python3.pkgs;

    pkg = python3Packages.callPackage ./default.nix {};
  in {
    packages.${system}.default = pkg;

    devShells.${system}.default = pkgs.mkShell {
      inputsFrom = [
        pkg
      ];
      packages = with pkgs; [
        python3
      ] ++ (with python3Packages; [
        # aiohttp
        # eventlet
        # mock
        # pytest
        # requests
        # six
        # tornado
        # websocket-client
        # websockets
      ]);
    };
  };
}
