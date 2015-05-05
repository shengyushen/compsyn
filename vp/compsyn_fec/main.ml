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

let getSteps i= begin
	let rec getLines j = begin
		let (newln,tf)= begin
			try 
				let ln=input_line stimulationFileChannel 
				in
				(ln,true)
			with End_of_file ->
				("",false)
		end
		in begin
			if(tf) then newln::(getLines j)
			else []
		end
	end
	in
	let listLines=getLines i 
	in
	let splitedLinesList=List.map (Str.split (Str.regexp "[ \t]+")) listLines
	in
	let noEmptyList=List.filter (fun x -> (isEmptyList x)=false) splitedLinesList
	in
	let isStep x = begin
		match x with
		["step";_] -> true
		| _ -> false
	end
	in
	let (rlst1,rlst2) = listPartition isStep noEmptyList 
	in begin
		assert (isEmptyList rlst1);
		let procmap y = begin
			match y with
			[a;b] -> (a,-1,int_of_string b)
			| _ -> assert false
		end
		in
		let str2valueList=List.map (fun x -> List.map procmap x) rlst2
		in
		str2valueList
	end
end
in
begin
	let stepList=getSteps 1 in begin 
(*
		Printf.printf "finished parsing\n";
		let procp x = begin
			match x with
			(str,-1,v) -> 
				Printf.printf "  %s %d\n" str v;
			| _ -> assert false
		end
		in
		let rec printSteps i stplst = begin
			match stplst with
			hd::tl -> begin
				Printf.printf "step  %d\n" i;
				List.iter procp hd;
				printSteps (i+1) tl;
			end
			| _ -> ()
		end
		in
		printSteps 0 stepList;
*)

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



