open Sys
open Str

(*open the temp dir*)

(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let outputFileName = Sys.argv.(2) ;;
let inputFileChannle = open_in inputFileName;;

(*reading the aag files*)
let aagConfigLine=input_line inputFileChannle;;
let aagConfigStringList=split (regexp "[ \t]+") aagConfigLine;;
assert ((List.length aagConfigStringList)=6);;
assert ((List.hd aagConfigStringList)="aag");;

let maxVarNumber=int_of_string (List.nth aagConfigStringList 1);;
let inputNumber =int_of_string (List.nth aagConfigStringList 2);;
let latchNumber =int_of_string (List.nth aagConfigStringList 3);;
let outputNumber=int_of_string (List.nth aagConfigStringList 4);;
let andNumber   =int_of_string (List.nth aagConfigStringList 5);;
assert (inputNumber<=maxVarNumber);;
assert (latchNumber<=maxVarNumber);;
assert (outputNumber<=maxVarNumber);;
assert (andNumber<=maxVarNumber);;
assert ((inputNumber+latchNumber+andNumber)=maxVarNumber);;


(*************************************)
(**)
(*************************************)
let rec readInputs inpnum = begin
	if(inpnum<=0) then []
	else begin
		let newLine=input_line inputFileChannle 
		and newList=readInputs (inpnum-1) in
		(int_of_string newLine)::newList
	end
end
;;

let isEven x = begin
	((x/2)*2)=x
end
;;

let inputsIdxList=List.map (fun x -> assert (isEven x);x/2) (readInputs inputNumber);;

(*print_endline "input list idx";;
List.iter (fun x -> Printf.printf "%d\n" x) inputsIdxList;;
print_endline "";;*)

let rec readLatches lnum = begin
	if(lnum<=0) then []
	else begin
		let newLine=input_line inputFileChannle 
		and newList=readLatches (lnum-1)in
		let latchNameList=split (regexp "[ \t]+") newLine in begin
			assert ((List.length latchNameList)=2);
			let qidx=int_of_string (List.nth latchNameList 0)
			and didx=int_of_string (List.nth latchNameList 1) in begin
				assert (isEven qidx);
				if(isEven didx) then	(qidx/2,didx/2)::newList
				else									(qidx/2,-(didx/2))::newList
			end
		end
	end
end;;

let latch2wireList=List.map (fun x -> x) (readLatches latchNumber);;


(*print_endline "latch list idx";;
List.iter (fun x ->  match x with (q,d)->Printf.printf "%d %d\n" q d) latch2wireList;;
print_endline "";;*)

(*reading output list*)
let rec readOutputs inpnum = begin
	if(inpnum<=0) then []
	else begin
		let newLine=input_line inputFileChannle 
		and newList=readOutputs (inpnum-1) in
		let outputNameList=split (regexp "[ \t]+") newLine in begin
			assert ((List.length outputNameList)=1);
			(int_of_string newLine)::newList
		end
	end
end
;;

let outputList=List.map (fun x -> assert (isEven x);x/2) (readOutputs outputNumber);;

(*print_endline "output list idx";;
List.iter (fun x -> Printf.printf "%d\n" x) outputList;;
print_endline "";;*)
let rec readANDs inpnum = begin
	if(inpnum<=0) then []
	else begin
		let newLine=input_line inputFileChannle 
		and newList=readANDs (inpnum-1) in
		let outputNameList=split (regexp "[ \t]+") newLine in begin
			assert ((List.length outputNameList)=3);
			let z=int_of_string (List.nth outputNameList 0)
			and a=int_of_string (List.nth outputNameList 1)
			and b=int_of_string (List.nth outputNameList 2) in begin
				assert (isEven z);
				assert ((z/2)<=maxVarNumber);
				assert ((a/2)<=maxVarNumber);
				assert ((b/2)<=maxVarNumber);
				let z2=z/2
				and a2=if(isEven a) then a/2 else -a/2
				and b2=if(isEven b) then b/2 else -b/2 in
				(z2,a2,b2)::newList
			end
		end
	end
end
;;

let andList=readANDs andNumber;;

(*print_endline "and list idx";;
List.iter (fun x -> match x with (z,a,b) -> Printf.printf "%d = %d & %d\n" z a b) andList;;
print_endline "";;*)


(*now all remain is symbol mapping*)
(*input symbol*)
let rec readInputsSymbol inpnum = begin
	if(inpnum<=0) then []
	else begin
		let newLine=input_line inputFileChannle 
		and newList=readInputsSymbol (inpnum-1) in
		let strlst=split (regexp "[ \t]+") newLine in begin
			assert ((List.length strlst)=2);
			assert ((Str.string_before (List.hd strlst) 1)="i");
			let idx=int_of_string (Str.string_after (List.hd strlst) 1) in begin
				assert (idx+inpnum=inputNumber);
				(List.nth strlst 1)::newList
			end
		end
	end
end
;;

let inputsNameList=readInputsSymbol inputNumber;;
let inputIdx2NameList=List.combine inputsIdxList inputsNameList;;
(*print_endline "input list idx";;
List.iter (fun x -> match x with (idx,nm) -> Printf.printf "%d %s\n" idx nm) inputIdx2NameList;;
print_endline "";;*)

(*latches symbol*)
let rec readLatchesSymbol inpnum = begin
	if(inpnum<=0) then []
	else begin
		let newLine=input_line inputFileChannle 
		and newList=readLatchesSymbol (inpnum-1) in
		let strlst=split (regexp "[ \t]+") newLine in begin
			assert ((List.length strlst)=2);
			assert ((Str.string_before (List.hd strlst) 1)="l");
			let idx=int_of_string (Str.string_after (List.hd strlst) 1) in begin
				assert (idx+inpnum=latchNumber);
				(List.nth strlst 1)::newList
			end
		end
	end
end
;;

let latchesNameList=readLatchesSymbol latchNumber;;
let latches2NameList=List.combine latch2wireList latchesNameList;;
(*print_endline "latch list idx";;
List.iter (fun x -> match x with ((q,d),nm) -> Printf.printf "%d (%d) %s\n" q d nm) latches2NameList;;
print_endline "";;*)

(*output symbol*)
let rec readOutputsSymbol inpnum = begin
	if(inpnum<=0) then []
	else begin
		let newLine=input_line inputFileChannle 
		and newList=readOutputsSymbol (inpnum-1) in
		let strlst=split (regexp "[ \t]+") newLine in begin
			assert ((List.length strlst)=2);
			assert ((Str.string_before (List.hd strlst) 1)="o");
			let idx=int_of_string (Str.string_after (List.hd strlst) 1) in begin
				assert (idx+inpnum=outputNumber);
				(List.nth strlst 1)::newList
			end
		end
	end
end
;;

let outputsNameList=readOutputsSymbol outputNumber;;
let outputIdx2NameList=List.combine outputList outputsNameList;;
(*print_endline "output list idx";;
List.iter (fun x -> match x with (idx,nm) -> Printf.printf "%d %s\n" idx nm) outputIdx2NameList;;
print_endline "";;*)

let clkname=ref "";;
let modulename=ref "";;

let rec readOther x=  begin
	try 
	let newLine=input_line inputFileChannle in
	let strlst=split (regexp "[ \t]+") newLine in begin
		if((List.length strlst)=2 && (List.hd strlst)="CLOCKNAME") then begin
			clkname := List.nth strlst 1
		end;
		if((List.length strlst)=2 && (List.hd strlst)="MODULENAME") then begin
			 modulename:= List.nth strlst 1
		end;
		readOther x
	end
	with End_of_file -> ()
end;;

readOther 1;;
(*Printf.printf "clock name is %s\n" (!clkname);;
Printf.printf "module name is %s\n" (!modulename);;*)
close_in inputFileChannle;;



(*print out the verilog*)
let outputFileChannle=open_out outputFileName;;

Printf.fprintf outputFileChannle "module %s (\n" (!modulename);;
Printf.fprintf outputFileChannle "//inputs\n" ;;
List.iter (fun x -> Printf.fprintf outputFileChannle " %s ,\n" x) inputsNameList;;
Printf.fprintf outputFileChannle "//outputs\n" ;;
List.iter (fun x -> Printf.fprintf outputFileChannle " %s ,\n" x) outputsNameList;;
Printf.fprintf outputFileChannle "//clock\n" ;;
Printf.fprintf outputFileChannle " %s\n" (!clkname);;
Printf.fprintf outputFileChannle ");\n" ;;

Printf.fprintf outputFileChannle "//inputs\n" ;;
List.iter (fun x -> Printf.fprintf outputFileChannle "input %s ;\n" x) inputsNameList;;
Printf.fprintf outputFileChannle "//outputs\n" ;;
List.iter (fun x -> Printf.fprintf outputFileChannle "output %s ;\n" x) outputsNameList;;
Printf.fprintf outputFileChannle "//clock\n" ;;
Printf.fprintf outputFileChannle "input %s ;\n" (!clkname);;


(*declaring latches*)
Printf.fprintf outputFileChannle "//latches\n" ;;
List.iter (fun x -> Printf.fprintf outputFileChannle "reg %s ;\n" x) latchesNameList;;

(*declaring other nets*)
Printf.fprintf outputFileChannle "//other net driven by and\n" ;;
List.iter (fun x ->match x with (z,_,_) -> Printf.fprintf outputFileChannle "wire andnet%d ;\n" z) andList;;

(*latches assignment*)
Printf.fprintf outputFileChannle "//latches assignment\n" ;;

(*the name mapping list*)
let nameMappingList=inputIdx2NameList@outputIdx2NameList@(List.map (fun x -> match x with ((q,d),nm) -> (q,nm)) latches2NameList);;

let mapIdx2Name id = begin
	let absid=abs id in 
	let nm=begin
		try
			List.assoc absid nameMappingList
		with Not_found -> Printf.sprintf "andnet%d" absid
	end in begin
		assert (id!=0);
		if(id>0) then nm
		else Printf.sprintf "!%s" nm
	end
end;;

List.iter (fun x -> match x with ((q,d),nm) -> Printf.fprintf outputFileChannle "always @(posedge %s) begin\n  %s <= %s ; \nend\n" (!clkname) nm (mapIdx2Name d)) latches2NameList;;

(*the list of and*)
List.iter (fun x -> match x with (z,a,b)-> Printf.fprintf outputFileChannle "assign %s=%s & %s;\n" (mapIdx2Name z) (mapIdx2Name a) (mapIdx2Name b)) andList;;


Printf.fprintf outputFileChannle "endmodule\n" ;;
close_out outputFileChannle;;

exit 0

