(lang dune 2.8)

(name michelson-parser)

(generate_opam_files true)

(source
 (uri "git+https://github.com/joaosreis/michelson-parser.git"))

(bug_reports "https://github.com/joaosreis/michelson-parser/issues")

(homepage "https://github.com/joaosreis/michelson-parser")

(license MIT)

(authors "Jo\195\163o Santos Reis <joaosreis@outlook.pt>")

(maintainers "Jo\195\163o Santos Reis <joaosreis@outlook.pt>")

(package
 (name michelson-parser)
 (version 0.1)
 (synopsis "An OCaml library to parse Michelson smart contracts")
 (depends
  (dune :build)
  (core
   (and
    (>= v0.14)
    (< v0.15)))
  (core_unix
   (and
    :with-test
    (>= v0.14)
    (< v0.15)))
  michelson-adt
  tezos-micheline
  ppx_deriving
  pp_loc
  (bisect_ppx
   (and
    :with-test
    (>= 2.5.0)))
  (alcotest :with-test)))
