with builtins; with (import <nixpkgs> {}).lib;
let master = [
    "coqeal"
    "hierarchy-builder"
    "mathcomp"
    "mathcomp-analysis"
    "mathcomp-bigenough"
    "mathcomp-classical"
    "mathcomp-finmap"
    "mathcomp-real-closed"
    "multinomials"
    "odd-order"
  ];
  common-bundles = listToAttrs (forEach master (p:
    { name = p; value.override.version = "master"; }))
  // {
    mathcomp-single-planB-src.job = false;
    mathcomp-single-planB.job = false;
    mathcomp-single.job = false;

    deriving.job = false;
    reglang.job = false;
}; in
{
  format = "1.0.0";
  attribute = "coq-elpi";
  default-bundle = "coq-8.20";
  bundles = {

    "coq-8.20" = {
      coqPackages = common-bundles // {
        coq.override.version = "8.20";
      };
    };

    "coq-master" = {
      coqPackages = common-bundles // {
        coq.override.version = "master";
        coqeal.job = false;  # broken in master, c.f. https://github.com/coq/coq/pull/19228
      };
      ocamlPackages = {
        elpi.override.version = "v2.0.3";
      };
    };
      
    "coq-master-min-elpi" = {
      coqPackages = common-bundles // {
        coq.override.version = "master";
        coqeal.job = false;  # broken in master, c.f. https://github.com/coq/coq/pull/19228
      };
      ocamlPackages = {
        # when updating this, don't forget to update dune-project
        # then use it to regenerate coq-elpi.opam
        elpi.override.version = "v2.0.3";
      };
    };

  };

  cachix.coq = {};
  cachix.math-comp = {};
  cachix.coq-community = {};
  cachix.coq-elpi.authToken = "CACHIX_AUTH_TOKEN";

}
