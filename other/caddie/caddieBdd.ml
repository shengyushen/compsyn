(*
BLAST is a tool for software model checking.
This file is part of BLAST.

Copyright (c) 2002-2007, The BLAST Team.
All rights reserved. 

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of the authors nor their organizations 
   may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(This is the Modified BSD License, see also
 http://www.opensource.org/licenses/bsd-license.php)

The BLAST Team consists of
        Dirk Beyer (SFU), Thomas A. Henzinger (EPFL),
        Ranjit Jhala (UCSD), and Rupak Majumdar (UCLA).

BLAST web page:
        http://mtc.epfl.ch/blast/

Bug reports:
        Dirk Beyer:      firstname.lastname@sfu.ca or
        Rupak Majumdar:  firstname@cs.ucla.edu or
        Ranjit Jhala:    lastname@cs.ucla.edu
 *)
type ddMgr
type bdd
type add
type zadd
type varSet
type varMap

type addOp = AddPlus | AddTimes | AddDivide | AddMinus | AddAgree | AddMax | AddMin
type zaddOp = ZaddAnd | ZaddOr | ZaddNand | ZaddNor | ZaddXor | ZaddXnor

type reorderType = Same| NoReorder | Random | RandomPivot | Sift | SiftConv | SymmSift | SymmSiftConv | Window2 | Window3 | Window4 | Window2Conv | Window3Conv | Window4Conv | GroupSift | GroupSiftConv | Anneal | Genetic | Linear | LinearConv | Exact

exception InvalidMgr
exception DifferentMgrs
let _ = Callback.register_exception "invalid mgr" (InvalidMgr)
let _ = Callback.register_exception "diff mgr" (DifferentMgrs)


external init : int -> int -> int -> int -> ddMgr = "caddie_init"
external exit : ddMgr -> unit = "caddie_exit"

external dynEnable : ddMgr -> reorderType -> unit = "caddie_dynEnable"
external dynDisable : ddMgr -> unit = "caddie_dynDisable"

external bddTrue : ddMgr -> bdd = "caddie_true"
external bddFalse : ddMgr -> bdd = "caddie_false"
external addOne : ddMgr -> add = "caddie_true"
external addZero : ddMgr -> add = "caddie_zero"
external zaddOne : ddMgr -> zadd = "caddie_true"
external zaddZero : ddMgr -> zadd = "caddie_zero"
external addPlusInf : ddMgr -> add = "caddie_plusInf"
external addMinusInf : ddMgr -> add = "caddie_minusInf"
external addConst : ddMgr -> float -> add = "caddie_addConst"
external addVal : add -> float = "caddie_addVal"
external addReadBack : ddMgr -> add = "caddie_addReadBack"
external addSetBack : add -> unit = "caddie_addSetBack"
external bddIsConst : bdd -> bool = "caddie_isConst"
external addIsConst : add -> bool = "caddie_isConst"
external zaddIsConst : zadd -> bool = "caddie_isConst"

external bddCountMinterm : ddMgr -> bdd -> int -> float = "caddie_bddCountMinterm"
external bddIthVar : ddMgr -> int -> bdd = "caddie_bddIthVar"
external bddNewVar : ddMgr -> bdd = "caddie_bddNewVar"
external addIthVar : ddMgr -> int -> add = "caddie_addIthVar"
external addNewVar : ddMgr -> add = "caddie_addNewVar"
external zaddIthVar : ddMgr -> int -> zadd = "caddie_addIthVar"
external zaddNewVar : ddMgr -> zadd = "caddie_addNewVar"
external bddEqual : bdd -> bdd -> bool = "caddie_equal"
external addEqual : add -> add -> bool = "caddie_equal"
external zaddEqual : zadd -> zadd -> bool = "caddie_equal"

external bddNot : bdd -> bdd = "caddie_bddNot"
external bddIte : bdd -> bdd -> bdd -> bdd = "caddie_bddIte"
external bddThen : bdd -> bdd = "caddie_bddThen"
external bddElse : bdd -> bdd = "caddie_bddElse"
external bddAnd : bdd -> bdd -> bdd = "caddie_bddAnd"
external bddNand : bdd -> bdd -> bdd = "caddie_bddNand"
external bddOr : bdd -> bdd -> bdd = "caddie_bddOr"
external bddNor : bdd -> bdd -> bdd = "caddie_bddNor"
external bddXor : bdd -> bdd -> bdd = "caddie_bddXor"
external bddImp : bdd -> bdd -> bdd = "caddie_bddImp"
external bddBiimp : bdd -> bdd -> bdd = "caddie_bddBiimp"
external zaddNot : zadd -> zadd =  "caddie_addCmpl"
external zaddApply : zaddOp -> zadd -> zadd -> zadd = "caddie_zaddApply"

external bddFromBool : ddMgr -> bool -> bdd = "caddie_fromBool"
external bddToBool : bdd -> bool = "caddie_toBool"
external zaddFromBool : ddMgr -> bool -> zadd = "caddie_zFromBool"
external zaddToBool : zadd -> bool = "caddie_zToBool"

external empty : ddMgr -> varSet = "caddie_true"
external insertVar : varSet -> int -> varSet = "caddie_addVar"
external singleVar : ddMgr -> int -> varSet = "caddie_bddIthVar"
let rec fromList m ilist = 
  match ilist with 
    [] -> empty m
  | head :: tail -> insertVar (fromList m tail) head

external forall : varSet -> bdd -> bdd = "caddie_forall"
external exists : varSet -> bdd -> bdd = "caddie_exists"

external toMap_ : ddMgr -> int array -> int array -> varMap = "caddie_toMap"
let toMap m pl =
	let (o,n) = (List.split pl)
	in (toMap_ m (Array.of_list o) (Array.of_list n))

external replace : bdd -> varMap -> bdd = "caddie_replace"

external addApply : addOp -> add -> add -> add = "caddie_addApply"
external addIte : zadd -> add -> add -> add = "caddie_addIte"
external addCmpl : add -> add = "caddie_addCmpl"
external addCompose : add -> zadd -> int -> add = "caddie_addCompose"
external addMax : add -> add = "caddie_addMax"
external addMin : add -> add = "caddie_addMin"

external zaddToAdd : zadd -> add = "caddie_nop"
external zaddToBdd : zadd -> bdd = "caddie_addBddPattern"
external addToBdd : add -> bdd = "caddie_addBddPattern"
external bddToZadd : bdd -> zadd = "caddie_bddAdd"
external bddToAdd : bdd -> add = "caddie_bddAdd"
external addIthBit : add -> int -> bdd = "caddie_addIthBit"

external bddPrint : bdd -> unit = "caddie_print"
external addPrint : add -> unit = "caddie_print"
external zaddPrint : zadd -> unit = "caddie_print"

(* Other useful functions added later by Rupak.
   These are from the Glu bdd.h interface.
   The hope is that ultimately all of that interface
   would be incorporated.
*)
external bddCofactor : bdd -> bdd -> bdd = "caddie_bddCofactor"
external bddVarCofactor : bdd -> bdd -> bdd = "caddie_bddVarCofactor"
external bddCompose : bdd -> bdd -> bdd -> bdd = "caddie_bddCompose"
external bddSubstitute : bdd -> int array -> int array -> bdd = "caddie_bddSubstitute"
external bddTopVar : bdd -> bdd = "caddie_bddTopVar"
external bddAndAbstract : bdd -> bdd -> bdd -> bdd = "caddie_bddAndAbstract"


external bddIndex : bdd -> int = "caddie_bddIndex"
external bddSupport : bdd -> bdd = "caddie_bddSupport"
external bddSupportSet : bdd -> int list = "caddie_bddSupportSet"

external bddForeachCube : bdd -> (int array -> unit) -> unit = "caddie_forEachCube"	
(* Iterate over all nodes of the BDD and invoke the function
   argument on each node.
*)
external bddForEachNode : bdd -> (bdd -> unit) -> unit = "caddie_forEachNode"

(** dddmp utilities to write a BDD to disk and to read a BDD from disk *)
external bddStore : ddMgr -> bdd -> string -> unit = "caddie_bddStore"
external bddLoad : ddMgr -> string -> bdd = "caddie_bddLoad"


