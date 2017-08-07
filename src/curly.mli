module Header : sig
  type t = (string * string) list

  val pp : Format.formatter -> t -> unit
end

module Response : sig
  type t =
    { code: int
    ; headers: Header.t
    ; body: string
    }

  val pp : Format.formatter -> t -> unit
end

module Request : sig
  type t =
    { meth: string
    ; url: string
    ; headers: Header.t
    ; body: string
    }

  val make
    : ?headers:Header.t
    -> ?body:string
    -> url:string
    -> meth:string
    -> unit
    -> t

  val to_cmd_args : t -> string list

  val pp : Format.formatter -> t -> unit
end

module Process_result : sig
  type t =
    { status: Unix.process_status
    ; stderr: string
    ; stdout: string
    }

  val pp : Format.formatter -> t -> unit
end

module Error : sig
  type t =
    | Invalid_request of string
    | Bad_exit of Process_result.t
    | Failed_to_read_response of exn * Process_result.t
    | Exn of exn

  val pp : Format.formatter -> t -> unit
end

val run
  : ?exe:string
  -> ?args:string list
  -> Request.t
  -> (Response.t, Error.t) Result.result
