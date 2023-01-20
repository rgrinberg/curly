(lang dune 2.7)
(name curly)

(generate_opam_files true)

(authors "Rudi Grinberg")
(maintainers "rudi.grinberg@gmail.com")
(license ISC)
(source (github rgrinberg/curly))

(package
 (name curly)
 (synopsis "Curly is a brain dead wrapper around the curl command line utility")
 (depends
  (ocaml (>= 4.03.0))
  base-unix
  result

  (alcotest :with-test)
  (cohttp-lwt-unix :with-test)
  (odoc :with-doc)))
