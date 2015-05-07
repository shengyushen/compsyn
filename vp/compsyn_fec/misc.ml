open List

let starttime=ref (Unix.gettimeofday ());;
let oldtime=ref (Unix.gettimeofday ());;

let set_current_time = begin
	starttime := Unix.gettimeofday ();
	oldtime := Unix.gettimeofday ()
end
and	dbg_print str = begin
	let current_time=Unix.gettimeofday () in begin
		Printf.printf "dbg_print : %s\t\t\ttime %5f delta %5f\n" str (current_time -. (!starttime)) (current_time -. (!oldtime)) ;
		flush stdout;
		oldtime := current_time
	end
end
and flush_assert_false = begin
	flush stdout;
	assert false
end

