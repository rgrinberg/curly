open Result
open Lwt.Infix

module Request = Cohttp.Request
module Header = Cohttp.Header
module Server = Cohttp_lwt_unix.Server

let sprintf = Printf.sprintf

let port = 12297

let simple_get_body = "curly"

let callback req body = function
  | ["simple_get"] ->
    Server.respond_string ~status:`OK ~body:simple_get_body ()
  | ["read_header"] ->
    Server.respond_string ~status:`OK ~body:(
      match Header.get (Request.headers req) "x-curly" with
      | None -> failwith "x-curly header not present"
      | Some v -> v
    ) ()
  | ["write_body"] ->
    Server.respond_string ~status:`OK ~body ()
  | _ ->
     failwith (sprintf "Not found: %s" (Request.resource req))

let test_server () =
  let (stop, stopper) = Lwt.task () in
  Server.make ~callback:(fun _ req body ->
      let uri_parts =
        req
        |> Request.uri
        |> Uri.path
        (* path starts with /, so first element is empty *)
        |> String.split_on_char '/'
        |> List.tl in
      Cohttp_lwt.Body.to_string body >>= fun body ->
      callback req body uri_parts
    ) ()
  |> Server.create ~mode:(`TCP (`Port port)) ~stop
  |> Lwt.ignore_result;
  stopper
;;

open Curly

let base =
  { Request.
    meth = `GET
  ; headers = []
  ; url = Printf.sprintf "http://0.0.0.0:%d" port
  ; body = ""
  }

let t_response = Alcotest.testable Response.pp (=)

let t_error = Alcotest.testable Error.pp (=)

let t_result = Alcotest.result t_response t_error

let with_path p = { base with Request.url = base.Request.url ^ "/" ^ p }

let body_header b = ["content-length", string_of_int (String.length b)]

let run_simple_get _ =
  Alcotest.check t_result "simple_get"
    (Curly.run (with_path "simple_get"))
    (Ok { Response.code = 200
        ; body="curly"
        ; headers = body_header simple_get_body
        }
    )
;;

let read_header _ =
  let (k, v) = ("x-curly", "header value") in
  Alcotest.check t_result "read_header"
    (Curly.run { (with_path "read_header") with Request.headers = [k, v] })
    (Ok { Response.code = 200
        ; body = v
        ; headers = body_header v
        })
;;

let write_body _ =
  let body = {|
    foo bar Baez
    sample body

    the quick brown fox
|} in
  Alcotest.check t_result "write_body"
    (Ok { Response.code = 200
        ; body
        ; headers = body_header body
        })
    (Curly.run { (with_path "write_body") with Request.body ; meth = `POST } )

let () =
  let stopper = test_server () in
  let tests_done =
    Lwt_preemptive.detach (fun () ->
        Alcotest.run "curly" [
          "curly", [ "simple_get", `Quick, run_simple_get
                   ; "read_header", `Quick, read_header
                   ; "write_body", `Quick, write_body
                   ]
        ]
      ) () in
  tests_done >|= (fun () -> Lwt.wakeup stopper ())
  |> Lwt_main.run
;;
