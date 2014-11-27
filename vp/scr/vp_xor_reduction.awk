function find_dup (a,l,r) {
	if((l,r) in a) return a[l,r]
	else if ((r,l) in a) return a[r,l]
	else return ""
}

{
	if($1=="assign" && $2 ~ /_localxor_v/ && $3=="=" && $5=="^") {
		dst=$2;
		left=$4;
		right=$6;
		olddst=find_dup(arr,left,right);
		if(olddst=="") {
			arr[left,right]=dst;
			print
		} else {
			print "assign " dst " = " olddst " ; ";
		}
	} else {
		print
	}
}
