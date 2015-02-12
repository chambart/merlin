(* {{{ COPYING *(

  This file is part of Merlin, an helper for ocaml editors

  Copyright (C) 2013 - 2014  Frédéric Bour  <frederic.bour(_)lakaban.net>
                             Thomas Refis  <refis.thomas(_)gmail.com>
                             Simon Castellan  <simon.castellan(_)iuwt.fr>

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall
  the authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising
  from, out of or in connection with the software or the use or other dealings
  in the Software.

)* }}} *)

open Std

type namespace = [ `Vals | `Type | `Constr | `Mod | `Modtype | `Labels ]
type path = (string * namespace) list

type trie = (Location.t * namespace * node) list String.Map.t
 and node =
   | Leaf
   | Internal of trie
   | Included of path
   | Alias    of path


type cmt_item = {
  cmt_infos : Cmt_format.cmt_infos ;
  mutable location_trie : trie ;
}

include File_cache.Make (struct
  type t = cmt_item

  let read file = {
    cmt_infos = Cmt_format.read_cmt file ;
    location_trie = String.Map.empty ;
  }
end)
