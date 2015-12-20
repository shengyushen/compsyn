(*
usage : vp_step1 -S <verilog file> <options>
options : 
-I <include dir>
*)
let start_time = Unix.gettimeofday ();;

(*to find all include path*)
let optlen=Array.length Sys.argv;;

if optlen < 3 then begin
	Printf.fprintf stderr "Usage 1 : vp_step1 -S <verilog file> <options> > <dst file>\n";
	Printf.fprintf stderr "options : \n";
	Printf.fprintf stderr "-I <include dir>\n";
	exit 1
end
;;

let pathlist = 
if optlen > 3 then begin
	let rec find_include_path i = begin
		if i>=optlen then []
		else begin
			let pn = Sys.argv.(i)
			in
			if pn="-I" then (Sys.argv.(i+1))::(find_include_path (i+2))
			else (find_include_path (i+2))
		end
	end
	in
	find_include_path 3
end
else []
;;

(*now open the file to be processed*)

let inputFileName = 
if (Sys.argv.(1)) = "-S" then
	Sys.argv.(2)
else begin
	Printf.fprintf stderr "%s" Sys.argv.(2);
	Printf.fprintf stderr "Usage 2 : vp_step1 -S <verilog file> <options> > > <dst file>\n";
	Printf.fprintf stderr "options : \n";
	Printf.fprintf stderr "-I <include dir>\n";
	exit 1
end

let inputFileChannle = open_in inputFileName;;

let lexbuf = Lexing.from_channel inputFileChannle;;

lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with pos_fname = inputFileName };;

let parseverilog lexbuf1 = 
	while true do
		if (Proc_inc.proc_inc pathlist lexbuf1)==Proc_inc.Eof then  raise (Proc_inc.Ssyeof "Ssyeof") ;
		flush stdout;
	done
;;

try
	parseverilog lexbuf
with Proc_inc.Ssyeof s -> 
		let end_time = Unix.gettimeofday ();
		in
		Printf.fprintf stderr "TIME : end %f \n" (end_time -. start_time)
		;
		exit 0
;;

close_in inputFileChannle;;
