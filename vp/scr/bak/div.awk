BEGIN {
	sigma1=0;
	sigmaxor=0
} 

{
	if($2=="SAT_Solve") {
		ssy=$3
	} else if($2=="ReduceSolution_1by1") {
		delta1=$3-ssy;
		sigma1=sigma1+delta1;
		ssy=$3
	} else if($2=="ReduceSolution_xor") {
		deltaxor=$3-ssy;
		sigmaxor=sigmaxor+deltaxor
	}
} 

END{
	print sigma1/sigmaxor
}
