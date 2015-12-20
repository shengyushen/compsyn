open Printf
open Unix

let get_time_string = begin
	let cur_tm = localtime (time ())
	in 
	sprintf "%d %d %d %d %d %d" (cur_tm.tm_year+1900) (cur_tm.tm_mon+1) cur_tm.tm_mday cur_tm.tm_hour cur_tm.tm_min cur_tm.tm_sec
end
