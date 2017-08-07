Curly - The Dumbest Http Client
===============================

Curly is a brain dead wrapper around the curl command line utility designed to
provide a 0 dependency solution for applications that want to create some very
simple HTTP requests and want to avoid dependencies.

It doesn't have any dependencies, C bindings, and the API can be learned in 5
minutes.

Here's a simple example:

.. code-block:: ocaml

   match Curly.(run (Request.make ~url:"https://opam.ocaml.org" ~meth:`GET ())) with
   | Ok x ->
     Format.printf "status: %d\n" x.Curly.Response.code;
     Format.printf "headers: %a\n" Curly.Header.pp x.Curly.Response.headers;
     Format.printf "body: %s\n" x.Curly.Response.body
   | Error e ->
     Format.printf "Failed: %a" Curly.Error.pp e

There's not much more to it than this. Consult curly.mli to see how to construct
various requests and read responses.
