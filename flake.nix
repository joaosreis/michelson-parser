{
  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "opam-nix/nixpkgs";
  };
  outputs = { self, flake-utils, opam-nix, nixpkgs }@inputs:
    let package = "michelson-parser";
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        on = opam-nix.lib.${system};
        devPackagesQuery = {
          # You can add "development" packages here. They will get added to the devShell automatically.
          ocaml-lsp-server = "*";
          ocamlformat = "*";
        };
        query = devPackagesQuery // {
          ## You can force versions of certain packages here, e.g:
          ## - force the ocaml compiler to be taken from opam-repository:
          ocaml-base-compiler = "*";
          ## - or force the compiler to be taken from nixpkgs and be a certain version:
          # ocaml-system = "4.14.0";
          ## - or force ocamlfind to be a certain version:
          # ocamlfind = "1.9.2";
        };
        scope =
          on.buildOpamProject { resolveArgs.with-test = true; } package ./.
          query;
        overlay = final: prev: {
          # Your overrides go here
          ocaml-lsp-server = prev.ocaml-lsp-server.overrideAttrs {
            nativeBuildInputs = prev.ocaml-lsp-server.nativeBuildInputs
              ++ [ prev.cppo ];
          };
        };
        scope' = scope.overrideScope overlay;
        # The main package containing the executable
        main = scope'.${package};
        # Packages from devPackagesQuery
        devPackages = builtins.attrValues
          (pkgs.lib.getAttrs (builtins.attrNames devPackagesQuery) scope');
      in {
        legacyPackages = scope';

        packages.default = self.legacyPackages.${system}.${package};

        devShells.default = pkgs.mkShell {
          inputsFrom = [ main ];
          buildInputs = devPackages ++ [
            pkgs.nixd
            pkgs.nixfmt
            # You can add packages from nixpkgs here
          ];
        };
      });
}
