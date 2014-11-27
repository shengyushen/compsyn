function sort_vstring(s) {
	split(s,a);
	num=asort(a);
	sdf1=a[1];
	for(i=2;i<=num;i=i+1) {
		sdf1=sprintf("%s %s",sdf1,a[i]);
	}
	return sdf1;
}

function replace_red_internal(arrR, tobr) {
	l=0;
	bb_cur="";
	for(bb in arrR) {
		if(index(tobr,bb)!=0 ) {
			bbl=split(bb,bba);
			if(bbl>l) {
				l=bbl;
				bb_cur=bb;
			}
		}
	}
	if(l==0) {
		return tobr;
	} else {
#		print "replacing " tobr " with " bb_cur;
#		print " geting " gensub(bb_cur,arrR[bb_cur],1,tobr);
		return gensub(bb_cur,arrR[bb_cur],1,tobr);
	}
}

function replace_red(arrR, tobr) {
	new_tobr=tobr;
	do {
		tobr=new_tobr;
		new_tobr=replace_red_internal(arrR, tobr);
	} while (new_tobr!=tobr)
	return new_tobr;
}

BEGIN{
	ssyssy=0;
}

{
	if($1=="assign" && $2 ~ /_localxor_v/ && $3=="=" && $5=="^") {
		dst=$2;
		left=$4;
		right=$6;
		if(left in arr) {
			sdf=arr[left];
		}else {
			sdf=left;
		}
		
		if(right in arr) {
			sdf=sprintf("%s %s",sdf,arr[right]);
		}else {
			sdf=sprintf("%s %s",sdf,right);
		}
		
		sdf2=sort_vstring(sdf);
		arr[dst]=sdf2;
		printf "assign " dst " = " > "wire.v";
		if(sdf2 in arrR) {
			sdf3 = arrR[sdf2];
		} else {
			sdf3=replace_red(arrR,sdf2);
			arrR[sdf2]=dst;
		}
		
		split(sdf3,a3);
		num3=asort(a3);
		sdf4=a3[1];
		for(i3=2;i3<=num3;i3=i3+1) {
			sdf4=sprintf("%s ^ %s",sdf4,a3[i3]);
		}
		
		print sdf4 " ; " > "wire.v";
	} else if($1=="endmodule") {
		print "`include \"wire.v\""> "red.v";
		print > "red.v";
	} else {
		print > "red.v";
	}
}
