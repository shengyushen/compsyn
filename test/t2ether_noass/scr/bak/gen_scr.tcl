set regcnt 1
set allcell [find cell *]
foreach_in_collection cc ${allcell} {
	set name [get_object_name ${cc}]
	set refn [get_attribute ${cc} ref_name]
	
	if { [string compare IV $refn]==0 } {
		# find its pin net
		set Apin ${name}/A
		set Anet [get_object_name [get_nets -of_objects [get_pins ${Apin}]]]
		set Zpin ${name}/Z
		set Znet [get_object_name [get_nets -of_objects [get_pins ${Zpin}]]]
		echo " assign " ${Znet} " = !" ${Anet} " ; " >> ${outfile}
		echo " wire " ${Znet} " ; " >> ${wirefile}
	} elseif { [string compare OR2 $refn]==0 } {
		# find its pin net
		set Apin ${name}/A
		set Anet [get_object_name [get_nets -of_objects [get_pins ${Apin}]]]

		set Bpin ${name}/B
		set Bnet [get_object_name [get_nets -of_objects [get_pins ${Bpin}]]]

		set Zpin ${name}/Z
		set Znet [get_object_name [get_nets -of_objects [get_pins ${Zpin}]]]
		echo " assign " ${Znet} " = " ${Anet} " | " ${Bnet}  " ; " >> ${outfile}
		echo " wire " ${Znet} " ; " >> ${wirefile}
	} elseif { [string compare AN2 $refn]==0 } {
		# find its pin net
		set Apin ${name}/A
		set Anet [get_object_name [get_nets -of_objects [get_pins ${Apin}]]]

		set Bpin ${name}/B
		set Bnet [get_object_name [get_nets -of_objects [get_pins ${Bpin}]]]

		set Zpin ${name}/Z
		set Znet [get_object_name [get_nets -of_objects [get_pins ${Zpin}]]]
		echo " assign " ${Znet} " = " ${Anet} " & " ${Bnet}  " ; " >> ${outfile}
		echo " wire " ${Znet} " ; " >> ${wirefile}
	} elseif { [string compare "FD1" $refn]==0 } {
		# following four are for async 
		set Dnet [get_object_name [get_nets -of_objects [get_pins ${name}/D]]]

		set CPnet [get_object_name [get_nets -of_objects [get_pins ${name}/CP]]]

		set Qnet_set  [get_nets -of_objects [get_pins ${name}/Q]]
		set QNnet_set [get_nets -of_objects [get_pins ${name}/QN]]

		echo " reg reg_${regcnt}_ssy ; " >> ${outfile}
		echo " always @(posedge " ${CPnet} ") " >> ${outfile}
		echo "      reg_${regcnt}_ssy  <= " ${Dnet} " ; " >> ${outfile}
		if {[sizeof_collection ${Qnet_set}]==1} {
			set Qnet [get_object_name ${Qnet_set}]
			echo " assign " ${Qnet} "= reg_${regcnt}_ssy ; " >> ${outfile}
			echo " wire " ${Qnet} " ; " >> ${wirefile}
		}

		if {[sizeof_collection ${QNnet_set}]==1} {
			set QNnet [get_object_name ${QNnet_set}]
			echo " assign " ${Qnet} "= !reg_${regcnt}_ssy ; " >> ${outfile}
			echo " wire " ${QNnet} " ; " >> ${wirefile}
		}
		incr regcnt
	} else {
		echo "unclassify " ${name} " " ${refn} >> ${wastefile}
	}
}

