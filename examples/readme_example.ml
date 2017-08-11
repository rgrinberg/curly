
let () =
  match Curly.(request (Request.make ~url:"https://opam.ocaml.org" ~meth:`GET ())) with
  | Ok x ->
    Format.printf "status: %d\n" x.Curly.Response.code;
    Format.printf "headers: %a\n" Curly.Header.pp x.Curly.Response.headers;
    Format.printf "body: %s\n" x.Curly.Response.body
  | Error e ->
    Format.printf "Failed: %a" Curly.Error.pp e
