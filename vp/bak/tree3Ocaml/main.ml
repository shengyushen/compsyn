open Printf
open Parser
open Typedef

(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let inputFileChannle = open_in inputFileName;;
let lexbuf = Lexing.from_channel inputFileChannle;;
let very_struct = Parser.treeNode (Very.veriloglex ) lexbuf ;;

let rec getDataNode dn = begin
	match dn with
	T_dataNode(v) -> [v]
	| T_dataNode_NULL -> []
end
and flatten treenode = begin
	match treenode with
	T_treeNode_NULL -> []
	| T_treeNode(lt,ld,mt,rd,rt) -> begin
		let lefttreeList = flatten lt
		and midtreeList = flatten mt
		and righttreeList =flatten rt
		and leftdataList= getDataNode ld
		and rightdataList = getDataNode rd
		in
		lefttreeList @ leftdataList @ midtreeList @ rightdataList @ righttreeList
	end
end
in
let flattreelist = flatten  very_struct
in begin
	printf "result of flatten is :";
	List.iter (printf "%d ") flattreelist;
	printf "\n"
end
;;

close_in  inputFileChannle ;; 
