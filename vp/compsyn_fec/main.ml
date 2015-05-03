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
let stimulationFileName = Sys.argv.(3) ;;
let expNumber = int_of_string (Sys.argv.(4)) ;;



(*parsing stimulation*)
let stimulationFileChannel = open_in stimulationFileName;;

let rec getSVList sname svstr = begin
	let len=String.length svstr
	in 
	if (len=0) then []
	else begin
		let substr=String.sub svstr 1 (len-1)
		and c=String.get svstr 0
		in
		let cv= begin
			match c with
			'0' -> 0
			| '1' -> 1
			| _ -> assert false
		end
		in
		(sname,len-1,cv)::(getSVList sname substr)
	end
end
in
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
			assert (Str.string_match (Str.regexp "[01]+") signalValueString 0);
			if((String.length signalValueString)=1) then begin
				let signalValue=int_of_string signalValueString
				in begin
					assert (signalValue==0 || signalValue==1);
					let restList=getStep i in
					(signalName,-1,signalValue)::restList
				end
			end
			else begin
				let signalValuePairList=getSVList signalName signalValueString
				in
				let restList=getStep i 
				in
				signalValuePairList@restList
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
		flush stdout;

		let inputFileChannle = open_in inputFileName
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
		end
	end
end;



