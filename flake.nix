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
  in {
    devShells.${system}.default = let
      #inherit (pkgs.nur.repos.graham33) python-engineio_3;
      python3 = pkgs.python311;
      python3Packages = python3.pkgs;
    in pkgs.mkShell {
      inputsFrom = [
      ];
      packages = with pkgs; [
        python3
      ] ++ (with python3Packages; [
        aiohttp
        eventlet
        mock
        pytest
        requests
        six
        tornado
        websocket-client
        websockets
      ]);
    };
  };
}
