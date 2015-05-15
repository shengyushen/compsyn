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
let notUsedOutputFilename = Sys.argv.(5) ;;
let debugFlag = bool_of_string (Sys.argv.(6)) ;;


(*parsing stimulation*)

let stepList = begin
	let listLines=getLines stimulationFileName
	in
	let splitedLinesList=List.map (Str.split (Str.regexp "[ \t]+")) listLines
	in
	let noEmptyList=List.filter (fun x -> (isEmptyList x)=false) splitedLinesList
	in 
	let procmap y = begin
		match y with
		[a;b] -> begin
			if ((b="0") || (b="1")) then
				(a,int_of_string b)
			else begin
				Printf.printf "Error : invalid input step %s %s\n" a b;
				flush stdout;
				assert false
			end
		end
		| _ -> assert false
	end
	in
	List.map procmap noEmptyList
end
(*not used output list*)
and notUsedOutputList = begin
	let listLines=getLines notUsedOutputFilename
	in
	let splitedLinesList=List.map (Str.split (Str.regexp "[ \t]+")) listLines
	in
	let lstSingular=List.filter (fun x -> assert ((List.length x)<=1); (isEmptyList x)=false) splitedLinesList
	in
	List.map (fun x -> List.hd x) lstSingular
end
and objRTL= begin
	let inputFileChannle = open_in inputFileName
	in
	let lexbuf = Lexing.from_channel inputFileChannle
	in
	let very_struct = Parser.source_text Very.verilog lexbuf 
	in begin
		close_in  inputFileChannle ;
		new rtl very_struct tempdirname debugFlag
	end
end
in
begin
	objRTL#elaborate elabModName ;
	objRTL#compsyn stepList expNumber notUsedOutputList;
	exit 0
end;



