open Rtl
open Sys
open Misc
open Intlist

(*open the temp dir*)
let tempdirname = (String.concat "" ["./";"container_";Sys.argv.(3);"/"]);;

let start_time = Unix.gettimeofday ();;

(*Manager.set_gc 1000000 (Gc.full_major) (Gc.full_major)
;;
*)
(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let elabModName = Sys.argv.(2) ;;
let stimulationFileName = Sys.argv.(3) ;;
let expNumber = int_of_string (Sys.argv.(4)) ;;



(*parsing stimulation*)

let getSteps i= begin
	let listLines=getLines stimulationFileName
	in
	let splitedLinesList=List.map (Str.split (Str.regexp "[ \t]+")) listLines
	in
	let noEmptyList=List.filter (fun x -> (isEmptyList x)=false) splitedLinesList
	in 
	let procmap y = begin
		match y with
		[a;b] -> begin
			assert ((b="0") || (b="1"));
			(a,int_of_string b)
		end
		| _ -> assert false
	end
	in
	List.map procmap noEmptyList
end
in
let stepList=getSteps 1 
and inputFileChannle = open_in inputFileName
in
let lexbuf = Lexing.from_channel inputFileChannle
in
let very_struct = Parser.source_text Very.verilog lexbuf 
in 
begin
	close_in  inputFileChannle ;
	let objRTL = new rtl very_struct tempdirname
	in begin
		objRTL#elaborate elabModName ;
		objRTL#compsyn stepList expNumber;
		exit 0
	end
end;



