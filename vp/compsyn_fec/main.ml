open Rtl
open Sys
open Print_v
open Misc

(*open the temp dir*)
let tempdirname = (String.concat "" ["./";"container_";Sys.argv.(3);"/"]);;

let start_time = Unix.gettimeofday ();;

(*Manager.set_gc 1000000 (Gc.full_major) (Gc.full_major)
;;
*)
(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let elabModName = Sys.argv.(2) ;;

let inputFileChannle = open_in inputFileName;;

let lexbuf = Lexing.from_channel inputFileChannle;;

let very_struct = Parser.source_text Very.verilog lexbuf ;;
close_in  inputFileChannle ;; 

let objRTL = new rtl very_struct tempdirname ;;

objRTL#elaborate elabModName ;;


(*parsing stimulation*)
let stimulationFileName = Sys.argv.(3) ;;
let stimulationFileChannel = open_in stimulationFileName;;

let getSplitedLine i = begin
	let ln=input_line stimulationFileChannel in
	let spltln=Str.split (Str.regexp "[ \t]+") ln in
	(spltln,ln)
end in
let rec getStepHead i = begin
	try 
	let (strList,str) = getSplitedLine  i in begin
		match	strList with
		[] -> getStepHead i
		| ["step";_] -> true
		| _  -> errorMessageQuit "%s\n" str
	end
	with  End_of_file -> false
end in
let rec getStep i = begin
	let (strList,str)=getSplitedLine i in begin
		match strList with
		[signalName;signalValueString] ->  begin
			(*assert (Str.string_match (Str.regexp "0\|1") signalValueString 0);*)
			let signalValue = int_of_string signalValueString  in begin
				assert (signalValue==0 || signalValue==1);
				let restList=getStep i in
				(signalName,signalValue)::restList
			end
		end
		| [] -> []
		| _ -> errorMessageQuit "%s\n" str
	end
end in
let rec getStepIter i =
begin
	let currentStep=getStep i in 
	begin
		match (getStepHead i) with
		false -> [currentStep]
		| _ -> 
		begin
			let remainStepList=getStepIter i in
			currentStep::remainStepList
		end
	end
end in 
begin
	getStepHead 1;
	let stepList=getStepIter 1 in begin
          Printf.printf "finished parsing\n";
		objRTL#compsyn stepList 20;
		exit 0
	end
end;



