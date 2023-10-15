{
  description = "Curly Nix Flake";

  inputs.nix-filter.url = "github:numtide/nix-filter";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        inherit (pkgs.ocamlPackages) buildDunePackage;
      in
      rec {
        packages = rec {
          default = curly;
          curly = buildDunePackage {
            pname = "curly";
            version = "n/a";
            src = ./.;
            duneVersion = "3";
            propagatedBuildInputs = with pkgs.ocamlPackages; [ pkgs.curl ];
            checkInputs = with pkgs.ocamlPackages; [ alcotest cohttp-lwt-unix lwt ];
            doCheck = true;
          };
        };
        devShells.default = pkgs.mkShell {
          inputsFrom = pkgs.lib.attrValues packages;
          buildInputs = with pkgs.ocamlPackages; [ ocaml-lsp pkgs.ocamlformat ];
        };
      });
}
