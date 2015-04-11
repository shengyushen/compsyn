open Rtl
open Sys
open Print_v

(*parsing input files*)
let inputFileName = Sys.argv.(1) ;;
let inputFileChannle = open_in inputFileName;;
close_in  inputFileChannle ;; 

let inputsString=input_line inputFileChannle;;
if () then begin
end

exit 0

