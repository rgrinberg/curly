(lang dune 2.4)
(name curly)

(generate_opam_files true)

(authors "Rudi Grinberg")
(maintainers "rudi.grinberg@gmail.com")
(license ISC)
(homepage "https://github.com/rgrinberg/curly")
(source (uri "git+https://github.com/rgrinberg/curly.git"))
(bug_reports "https://github.com/rgrinberg/curly/issues")

(package
 (name curly)
 (synopsis "Curly is a brain dead wrapper around the curl command line utility")
 (description "") ; TODO
 (depends
  ;; General system dependencies
  (dune (>= 2.4))
  (ocaml (>= 4.03.0))
  base-unix
  result

  (alcotest :with-test)
  (cohttp-lwt-unix :with-test)
  (odoc :with-doc)))
