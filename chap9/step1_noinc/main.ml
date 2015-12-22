open Arg
open Printf

let start_time = Unix.gettimeofday ();;

(*
actually my syntax is 
many -I that can only be add to pathlist by a function
one anonymous filename that can only be added by a function
while those non-anonymous options with only instance can use Set_* to set
*)
let get_args () = begin
	let usage_msg = "Usage : vp_step1 -S [verilog file] -I [include dir1]  -I [include dir2] > [output file]"
	and pathlist =  ref []
	and inputFilename = ref ""
	in
	let addpath str = begin
		pathlist := str::(!pathlist)
	end
	and addinput str = begin
		if((!inputFilename)="") then 
			inputFilename := str
		else begin
			fprintf stderr "FATAL : more than 1 input file %s\n" str;
			flush stderr;
			exit 1;
		end
	end
	and anon_fun str = begin
		fprintf stderr "%s\n" usage_msg;
		fprintf stderr "WARNING : extra option %s\n" str;
		flush stderr;
		exit 1
	end
	in
	let oldspeclist = [
	("-I",String(addpath) ," include paths");
	("-S",String(addinput)," source file");
	]
	in 
	let speclist = align oldspeclist 
	in
	begin
		parse speclist anon_fun usage_msg;
		fprintf stderr "inputFilename is %s\n" !inputFilename;
		List.iter (fprintf stderr "path %s\n") !pathlist;
		flush stderr;
		(!inputFilename , !pathlist)
	end
end
in
let (inputFilename ,  pathlist) = get_args ()
in  
(*now open the file to be processed*)
let inputFileChannle = open_in inputFilename in
let lexbuf = Lexing.from_channel inputFileChannle in 
begin
	(*setting the file name in lexbuf*)
	lexbuf.Lexing.lex_curr_p <- { lexbuf.Lexing.lex_curr_p with Lexing.pos_fname = inputFilename };
	(*the loop to run though source code*)
	while true do
		if (Proc_inc.proc_inc pathlist lexbuf)==Proc_inc.Eof then begin
			let end_time = Unix.gettimeofday ();
			in
			Printf.fprintf stderr "TIME : end %f \n" (end_time -. start_time)
			;
			close_in inputFileChannle;
			exit 0
		end
	done
end

