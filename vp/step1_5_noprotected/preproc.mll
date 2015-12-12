{
	
	(*this is the list of definition*)
	let can_print = ref true;;
	type token = Eof | Other
	exception Ssyeof of string
}


rule preproc = parse
	"//" [' ' '\t']* "pragma" [' ' '\t']+ "protect" [' ' '\t']+ "begin_protected" [' ' '\t']* '\n' as cmt   {
			can_print := false;
			Other
		} 
	| "//" [' ' '\t']* "pragma" [' ' '\t']+ "protect" [' ' '\t']+ "end_protected" [' ' '\t']* '\n' as cmt   {
			can_print := true;
			Other
		} 
	| eof {Eof}
	| [^ '/' ]+ as cmt {
		if(!can_print) then begin
			print_string cmt
		end
		;
		Other
		}
	| _ as cmt {
		if(!can_print) then begin
			print_char cmt
		end
		;
		Other
	}
