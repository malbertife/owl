(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2017 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)

module type MatrixSig = sig

  type mat

  type elt = float

  (* creation and operation functions *)

  val create : int -> int -> elt -> mat

  val empty : int -> int -> mat

  val zeros : int -> int -> mat

  val uniform : ?scale:elt -> int -> int -> mat

  val gaussian : ?sigma:elt -> int -> int -> mat

  val shape : mat -> int * int

  val row_num : mat -> int

  val col_num : mat -> int

  val get : mat -> int -> int -> elt

  val set : mat -> int -> int -> elt -> unit

  val row : mat -> int -> mat

  val clone : mat -> mat

  val reset : mat -> unit

  val copy_row_to : mat -> mat -> int -> unit

  val copy_col_to : mat -> mat -> int -> unit

  val mapi : (int -> int -> elt -> elt) -> mat -> mat

  val iteri_rows : (int -> mat -> unit) -> mat -> unit

  val iter2_rows : (mat -> mat -> unit) -> mat -> mat -> unit

  val draw_rows : ?replacement:bool -> mat -> int -> mat * int array

  val draw_rows2 : ?replacement:bool -> mat -> mat -> int -> mat * mat * int array

  val of_arrays : elt array array -> mat

  val of_rows: mat array -> mat

  val print : mat -> unit

  (* mathematical functions *)

  val abs : mat -> mat

  val neg : mat -> mat

  val floor : mat -> mat

  val ceil : mat -> mat

  val round : mat -> mat

  val sqr : mat -> mat

  val sqrt : mat -> mat

  val log : mat -> mat

  val log2 : mat -> mat

  val log10 : mat -> mat

  val exp : mat -> mat

  val sin : mat -> mat

  val cos : mat -> mat

  val tan : mat -> mat

  val sinh : mat -> mat

  val cosh : mat -> mat

  val tanh : mat -> mat

  val asin : mat -> mat

  val acos : mat -> mat

  val atan : mat -> mat

  val asinh : mat -> mat

  val acosh : mat -> mat

  val atanh : mat -> mat

  val trace : mat -> elt

  val sum : mat -> elt

  val sum_rows : mat -> mat

  val average : mat -> elt

  val signum : mat -> mat

  val transpose : mat -> mat

  val l1norm : mat -> elt

  val l2norm : mat -> elt

  val l2norm_sqr : mat -> elt

  val sigmoid : mat -> mat

  val relu : mat -> mat

  val clip_by_l2norm : elt -> mat -> mat

  val pow : mat -> mat -> mat

  val pow0 : elt -> mat -> mat

  val pow1 : mat -> elt -> mat

  val atan2 : mat -> mat -> mat

  val atan20 : elt -> mat -> mat

  val atan21 : mat -> elt -> mat

  val ( +@ ) : mat -> mat -> mat

  val ( -@ ) : mat -> mat -> mat

  val ( *@ ) : mat -> mat -> mat

  val ( /@ ) : mat -> mat -> mat

  val ( +$ ) : mat -> elt -> mat

  val ( $+ ) : elt -> mat -> mat

  val ( -$ ) : mat -> elt -> mat

  val ( $- ) : elt -> mat -> mat

  val ( *$ ) : mat -> elt -> mat

  val ( $* ) : elt -> mat -> mat

  val ( /$ ) : mat -> elt -> mat

  val ( $/ ) : elt -> mat -> mat

  val ( $@ ) : mat -> mat -> mat

end



module Make (M : MatrixSig) : sig

  type mat = M.mat

  type elt = M.elt

  type trace_op

  type t =
    | F   of float
    | Mat of mat
    | DF  of t * t * int                            (* primal, tangent, tag *)
    | DR  of t * t ref * trace_op * int ref * int   (* primal, adjoint, op, fanout, tag *)


  module Maths : sig

    val add : t -> t -> t

    val sub : t -> t -> t

    val mul : t -> t -> t

    val div : t -> t -> t

    val dot : t -> t -> t

    val pow : t -> t -> t

    val atan2 : t -> t -> t

    val min2 : t -> t -> t

    val max2 : t -> t -> t

    val cross_entropy : t -> t -> t

    val neg : t -> t

    val abs : t -> t

    val signum : t -> t

    val floor : t -> t

    val ceil : t -> t

    val round : t -> t

    val sqr : t -> t

    val sqrt : t -> t

    val log : t -> t

    val log2 : t -> t

    val log10 : t -> t

    val exp : t -> t

    val sin : t -> t

    val cos : t -> t

    val tan : t -> t

    val sinh : t -> t

    val cosh : t -> t

    val tanh : t -> t

    val asin : t -> t

    val acos : t -> t

    val atan : t -> t

    val asinh : t -> t

    val acosh : t -> t

    val atanh : t -> t

    val item : t -> int -> int -> t

    val sum : t -> t

    val average : t -> t

    val transpose : t -> t

    val l1norm : t -> t

    val l2norm : t -> t

    val l2norm_sqr : t -> t

    val sigmoid : t -> t

    val relu : t -> t

    val softplus : t -> t

    val softsign: t -> t

    val softmax : t -> t

    val ( + )  : t -> t -> t

    val ( - )  : t -> t -> t

    val ( * )  : t -> t -> t

    val ( / )  : t -> t -> t

    val ( $@ )  : t -> t -> t

    val ( ** )  : t -> t -> t

  end


  module Mat : sig

    val empty : int -> int -> t

    val zeros : int -> int -> t

    val uniform : ?scale:float -> int -> int -> t

    val gaussian : ?sigma:float -> int -> int -> t

    val shape : t -> int * int

    val row_num : t -> int

    val col_num : t -> int

    val reset : t -> unit

    val clip_by_l2norm : t -> t -> t

    val add : t -> t -> t

    val sub : t -> t -> t

    val mul : t -> t -> t

    val div : t -> t -> t

    val mapi : (int -> int -> elt -> elt) -> t -> t

    val iter2_rows : (t -> t -> unit) -> t -> t -> unit

    val map_by_row : (t -> t) -> t -> t

    val draw_rows2 : ?replacement:bool -> t -> t -> int -> t * t * int array

  end


  val unpack_flt : t -> elt

  val unpack_mat : t -> mat

  val tag : unit -> int

  val primal : t -> t

  val primal' : t -> t

  val adjval : t -> t

  val make_reverse : t -> int -> t

  val reverse_prop : t -> t -> unit

end
