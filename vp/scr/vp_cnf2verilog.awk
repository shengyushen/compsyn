function src_idx2nm1 (i) {
	if (i==1) {
		return "truepred"
	} else if (i==2) {
		return "falsepred"
	} else if (i in src_idx2nm) {
		return src_idx2nm[i]
	} else {
		ssy=sprintf("v%d",i);
		varry[ssy]=1;
		return ssy
	}
}

function tgt_idx2nm1 (i) {
	if (i==1) {
		return "truepred"
	} else if (i==2) {
		return "falsepred"
	} else if (i in tgt_idx2nm) {
		return tgt_idx2nm[i]
	} else {
		ssy=sprintf("v%d",i);
		varry[ssy]=1;
		return ssy
	}
}

function del1and2 (curln) {
	numf=split(curln,ssya);
	nm="";
	for(i=1;i<=numf;i=i+1) {
		if (ssya[i] != -1 && ssya[i] != 2)  nm=sprintf("%s %d",nm,ssya[i]);
	}
	return nm
}

function del0 (curln) {
	numf=split(curln,ssya);
	nm="";
	for(i=1;i<=numf;i=i+1) {
		if (ssya[i] != 0)  nm=sprintf("%s %d",nm,ssya[i]);
	}
	return nm
}

function print_1bit_src(i) {
	if(i>0) printf " " src_idx2nm1(i) " ==1'b0 "
	else printf " " src_idx2nm1(-i) " ==1'b1 "
}

function print_1bit_dst(i) {
	if(i>0) printf " " tgt_idx2nm1(i) " <=1'b1 ;"
	else printf " " tgt_idx2nm1(-i) " <=1'b0 ;"
}

function print_1bit_dst_z(i) {
	printf "       " tgt_idx2nm1(abs(i)) " <=1'b0 ;"
}

function print_condition(notgtv1) {
	notgtv2=del0(notgtv1);
	numf=split(notgtv2,ssya);
	if(numf==0) {
		printf "1";
		return 
	}
	print_1bit_src(ssya[1]);
	for(i=2;i<=numf;i=i+1) {
		printf " && ";
		print_1bit_src(ssya[i]);
	}
}

function abs(i) {
	if(i>=0)  return i
	else return -i
}

function findtgt(curln,tgt)  {
	numf=split(curln,ssya);
	for(i=1;i<=numf-1;i=i+1) {
		if (ssya[i]==tgt)  return ssya[i]
		else if(ssya[i]== -tgt) return ssya[i]
	}
	print "fatal error: no such var " tgt > "/dev/stderr";
	print curln > "/dev/stderr";
	exit
}

function deltgt(curln,tgt)  {
	ress="";
	numf=split(curln,ssya);
	for(i=1;i<=numf;i=i+1) {
		if (ssya[i]!=tgt && ssya[i]!= -tgt) {
			ress=sprintf("%s %d",ress,ssya[i])
		}
	}
	return ress;
}
function unique_ln(curln1) {
	already[0]=1;
	ress="";
	numf=split(curln1,ssya);
	for(i=1;i<=numf;i=i+1) {
	   if (!(abs(ssya[i]) in already)) {
		already[abs(ssya[i])]=1;
		ress=sprintf("%s %d",ress,ssya[i]);
	   }
	}
	delete already;
	return ress;
}

function print_always(tgt_idx,curln1)  {
	print "always @(";

	curln=unique_ln(del0(curln1));

	if (tgt_idx in tgt_idx2nm) {
		if( src_idx2nm1(tgt_idx) != tgt_idx2nm1(tgt_idx) ) { # dff
			print "posedge " clkname;
		} else {# normal reg
			numf=split(curln,ssya);
			if(numf==0) {
				print "fatal error: empty 1234 line " > "/dev/stderr";
				print curln1 > "/dev/stderr";
				exit
			}
			nm=src_idx2nm1(abs(ssya[1]));
			for(i=2;i<=numf;i=i+1) {
				print "   " nm " or";
				nm=src_idx2nm1(abs(ssya[i]));
			}
			print "   " nm
		}
	} else {
		numf=split(curln,ssya);
		if(numf==0) {
			print "fatal error: empty line " > "/dev/stderr";
			print curln1 > "/dev/stderr";
			print curln > "/dev/stderr";
			exit
		}
		nm=src_idx2nm1(abs(ssya[1]));
		for(i=2;i<=numf;i=i+1) {
			if(ssya[i]!=0) {
				print "   " nm " or";
				nm=src_idx2nm1(abs(ssya[i]));
			}
		}
		print "   " nm
	}

	print ")";
}

BEGIN	{
	ssy="";
	sssy="";
	clkname="";
}

{
	if ($0 ~ /^c module_name/)		{
		print "module " $3 " (" ;
	}else if ($0 ~ /^c module_def_end/)	{
		print "\t" sssy;
		print ");" ;
		print "`include \"vreg.v\"" ;
		print "wire truepred;";
		print "wire falsepred;"
	}else if ($0 ~ /^c module_port/)	{
		printf ssy;
		ssy=sprintf("\t%s ,\n",$3 );
		sssy=$3
	}else if ($0 ~ /^c clkname /)		{
		clkname=$3
	}else if ($0 ~ /^c output_port/)	{
		if (NF==3) { # no range
			outparry[$3]=1;
			print "output " $3  " ;"
			print "reg " $3  " ;"
		} else {
			outparry[$4]=1;
			print "output " $3 " " $4 " ;"
			print "reg " $3 " " $4 " ;"
		}
	}else if ($0 ~ /^c input_port/)		{
		if (NF==3) { # no range
			inparry[$3]=1;
			print "input " $3  " ;"
		} else {
			inparry[$4]=1;
			print "input " $3 " " $4 " ;"
		}
	}else if ($0 ~ /^c one instance mapping/) {
		name=$5;
		baseidx_cur=$6;
		baseidx_nxt=$7;
		rng_l=$8;
		rng_r=$9;
		
		if (name in inparry) {
		} else if (name in outparry) {
		} else {
			printf "reg ";
			if (rng_l != -1 || rng_r != -1) { # it has range
				printf " [" rng_l ":" rng_r "] " 
			} 
			;
			printf name;
			print  " ;";
		}
		
		# recorde the mapping between idx and name
		if (rng_l != -1 || rng_l != -1) { # it has range
			if (rng_l<rng_r) {
				for(i=rng_l;i<=rng_r;i=i+1) {
					if (baseidx_nxt != -1) { #dff
						name_off=sprintf("%s[%d]",name,i);
						idx=baseidx_nxt+i-rng_l;
						
						tgt_idx2nm[idx]=name_off;
						tgt_nm2idx[name_off]=idx;
						
						idx=baseidx_cur+i-rng_l;
						
						src_idx2nm[idx]=name_off;
						src_nm2idx[name_off]=idx
					}else { # normal reg
						name_off=sprintf("%s[%d]",name,i);
						idx=baseidx_cur+i-rng_l;
						
						tgt_idx2nm[idx]=name_off;
						tgt_nm2idx[name_off]=idx;
						src_idx2nm[idx]=name_off;
						src_nm2idx[name_off]=idx
					}
				}
			}else {
				for(i=rng_l;i>=rng_r;i=i-1) {
					if (baseidx_nxt != -1) { #dff
						name_off=sprintf("%s[%d]",name,i);
						idx=baseidx_nxt+rng_l-i;
						
						tgt_idx2nm[idx]=name_off;
						tgt_nm2idx[name_off]=idx;
						
						idx=baseidx_cur+rng_l-i;
						
						src_idx2nm[idx]=name_off;
						src_nm2idx[name_off]=idx
					}else { # normal reg
						name_off=sprintf("%s[%d]",name,i);
						idx=baseidx_cur+rng_l-i;
						
						tgt_idx2nm[idx]=name_off;
						tgt_nm2idx[name_off]=idx;
						src_idx2nm[idx]=name_off;
						src_nm2idx[name_off]=idx
					}
				}
			}
		} else {#no range 
			if (baseidx_nxt != -1) { #dff
				tgt_idx2nm[baseidx_nxt]=name;
				tgt_nm2idx[name]=baseidx_nxt;
				src_idx2nm[baseidx_cur]=name;
				src_nm2idx[name]=baseidx_cur
			}else { # normal reg
				tgt_idx2nm[baseidx_cur]=name;
				tgt_nm2idx[name]=baseidx_cur;
				src_idx2nm[baseidx_cur]=name;
				src_nm2idx[name]=baseidx_cur
			}
		} 
	}else if ($0 ~ /^c encode_ASSIGN/){ #it should be two line
		nmass_tgt=$3;
		idx_tgt=tgt_nm2idx[nmass_tgt];
		c1=$0;
		getline;
		case1=del1and2($0);
		getline;
		c2=$0;
		getline;
		case2=del1and2($0);
		
		if (c1==c2) {
			tgtv=findtgt(case1,idx_tgt);
			notgtv=deltgt(case1,idx_tgt);
			# print always
			print_always(idx_tgt,sprintf("%s %s", notgtv,deltgt(case2,idx_tgt)));
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			tgtv=findtgt(case2,idx_tgt);
			notgtv=deltgt(case2,idx_tgt);
			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
		} else {
			print "fatal error: encode_ASSIGN " > "/dev/stderr";
			print c1 > "/dev/stderr";
			print c2 > "/dev/stderr";
			exit
		}
	}else if ($0 ~ /^c encode_SEL_res/){
		# the last index is hte target
		c1=$0;
		getline;
		case1=del1and2($0);
		getline;
		c2=$0;
		getline;
		case2=del1and2($0);
		getline;
		c3=$0;
		getline;
		case3=del1and2($0);
		getline;
		c4=$0;
		getline;
		case4=del1and2($0);
	
		if (c1==c2 && c2==c3 && c3==c4) {
			numf=split(case1,ssyd);
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case1,abs(tgtv));
			# print always
			print_always(abs(tgtv),sprintf("%s %s %s %s", notgtv,deltgt(case2,abs(tgtv)),deltgt(case3,abs(tgtv)),deltgt(case4,abs(tgtv))));
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case2,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_SEL_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case2,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case3,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_SEL_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case3,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case4,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_SEL_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case4,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
		} else {
			print "fatal error: encode_SEL_res " > "/dev/stderr";
			print c1 > "/dev/stderr";
			print c2 > "/dev/stderr";
			print c3 > "/dev/stderr";
			print c4 > "/dev/stderr";
			exit
		}
	}else if ($0 ~ /^c encode_Red_AND/){
			numline=$3;
			#print numline "shegyu shen">> "/dev/stderr";
			getline;
			case1=$0;
			numf=split(case1,ssyd);
			idx_tgt=ssyd[numf-1];
			
			tgtv=findtgt(case1,idx_tgt);
			notgtv=deltgt(case1,idx_tgt);
			# print always
			print_always(abs(tgtv),notgtv);
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			for(sdi=2;sdi<=numline+1;sdi=sdi+1) {
				#print sdi " tttt " numline > "/dev/stderr";
				getline;
				if($0 ~ /^c encode_Red_AND/) {
					getline;
					case1=$0;
			
					tgtv=findtgt(case1,idx_tgt);
					notgtv=deltgt(case1,idx_tgt);

					printf "    else if(";
					print_condition(notgtv);
					print")";
					#print  "    begin";
					printf  "        " ;
					print_1bit_dst(tgtv);
					print  ""
					#print  "    end";
				} else {
					print "fatal error: encode_Red_AND " sdi > "/dev/stderr";
					print $0 > "/dev/stderr";
					exit
				}
			}
			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
	}else if ($0 ~ /^c encode_Red_OR/){
			numline=$3;
			#print numline "shegyu shen">> "/dev/stderr";
			getline;
			case1=$0;
			numf=split(case1,ssyd);
			idx_tgt=ssyd[numf-1];
			
			tgtv=findtgt(case1,idx_tgt);
			notgtv=deltgt(case1,idx_tgt);
			# print always
			print_always(abs(tgtv),notgtv);
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			for(sdi=2;sdi<=numline+1;sdi=sdi+1) {
				#print sdi " tttt " numline > "/dev/stderr";
				getline;
				if($0 ~ /^c encode_Red_OR/) {
					getline;
					case1=$0;
			
					tgtv=findtgt(case1,idx_tgt);
					notgtv=deltgt(case1,idx_tgt);

					printf "    else if(";
					print_condition(notgtv);
					print")";
					#print  "    begin";
					printf  "        " ;
					print_1bit_dst(tgtv);
					print  ""
					#print  "    end";
				} else {
					print "fatal error: encode_Red_OR " sdi > "/dev/stderr";
					print $0 > "/dev/stderr";
					exit
				}
			}
			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
	}else if ($0 ~ /^c encode_EQU_res/){
		# there should be 4 case
		# the last index is hte target
		c1=$0;
		getline;
		case1=del1and2($0);
		getline;
		c2=$0;
		getline;
		case2=del1and2($0);
		getline;
		c3=$0;
		getline;
		case3=del1and2($0);
		getline;
		c4=$0;
		getline;
		case4=del1and2($0);
	
		if (c1==c2 && c2==c3 && c3==c4) {
			numf=split(case1,ssyd);
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case1,abs(tgtv));
			# print always
			print_always(abs(tgtv),sprintf("%s %s %s %s", notgtv,deltgt(case2,abs(tgtv)),deltgt(case3,abs(tgtv)),deltgt(case4,abs(tgtv))));
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case2,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_EQU_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case2,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case3,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_EQU_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case3,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case4,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_EQU_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case4,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			print "    else";
			print_1bit_dst_z(tgtv);
			print  "end";
			print "";
			print ""
		} else {
			print "fatal error: encode_EQU_res " > "/dev/stderr";
			print c1 > "/dev/stderr";
			print c2 > "/dev/stderr";
			print c3 > "/dev/stderr";
			print c4 > "/dev/stderr";
			exit
		}
	}else if ($0 ~ /^c encode_INE_res/){
		# there should be 4 case
		# the last index is hte target
		c1=$0;
		getline;
		case1=del1and2($0);
		getline;
		c2=$0;
		getline;
		case2=del1and2($0);
		getline;
		c3=$0;
		getline;
		case3=del1and2($0);
		getline;
		c4=$0;
		getline;
		case4=del1and2($0);
	
		if (c1==c2 && c2==c3 && c3==c4) {
			numf=split(case1,ssyd);
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case1,abs(tgtv));
			# print always
			print_always(abs(tgtv),sprintf("%s %s %s %s", notgtv,deltgt(case2,abs(tgtv)),deltgt(case3,abs(tgtv)),deltgt(case4,abs(tgtv))));
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case2,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_INE_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case2,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case3,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_INE_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case3,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case4,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_INE_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case4,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
		} else {
			print "fatal error: encode_INE_res " > "/dev/stderr";
			print c1 > "/dev/stderr";
			print c2 > "/dev/stderr";
			print c3 > "/dev/stderr";
			print c4 > "/dev/stderr";
			exit
		}
	}else if ($0 ~ /^c encode_OR2_res/){
		# there should be 3 case
		# there should be 4 case
		# the last index is hte target
		c1=$0;
		getline;
		case1=del1and2($0);
		getline;
		c2=$0;
		getline;
		case2=del1and2($0);
		getline;
		c3=$0;
		getline;
		case3=del1and2($0);
	
		if (c1==c2 && c2==c3 ) {
			numf=split(case1,ssyd);
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case1,abs(tgtv));
			# print always
			print_always(abs(tgtv),sprintf("%s %s %s", notgtv,deltgt(case2,abs(tgtv)),deltgt(case3,abs(tgtv))));
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case2,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_EQU_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case2,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case3,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_EQU_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case3,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
		} else {
			print "fatal error: encode_OR2_res " > "/dev/stderr";
			print c1 > "/dev/stderr";
			print c2 > "/dev/stderr";
			print c3 > "/dev/stderr";
			exit
		}
	}else if ($0 ~ /^c encode_AND2_res/){
		# there should be 3 case
		# there should be 4 case
		# the last index is hte target
		c1=$0;
		getline;
		case1=del1and2($0);
		getline;
		c2=$0;
		getline;
		case2=del1and2($0);
		getline;
		c3=$0;
		getline;
		case3=del1and2($0);
	
		if (c1==c2 && c2==c3 ) {
			numf=split(case1,ssyd);
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case1,abs(tgtv));
			# print always
			print_always(abs(tgtv),sprintf("%s %s %s", notgtv,deltgt(case2,abs(tgtv)),deltgt(case3,abs(tgtv))));
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case2,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_AND2_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case2,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case3,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_AND2_res tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case3,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
		} else {
			print "fatal error: encode_AND2_res " > "/dev/stderr";
			print c1 > "/dev/stderr";
			print c2 > "/dev/stderr";
			print c3 > "/dev/stderr";
			exit
		}
	}else if ($0 ~ /^c encode_NEG_ASSIGN/){
		# there should be 2 case
		# the last index is hte target
		c1=$0;
		getline;
		case1=del1and2($0);
		getline;
		c2=$0;
		getline;
		case2=del1and2($0);
	
		if (c1==c2) {
			numf=split(case1,ssyd);
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case1,abs(tgtv));
			# print always
			print_always(abs(tgtv),sprintf("%s %s", notgtv,deltgt(case2,abs(tgtv))));
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case2,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_NEG_ASSIGN tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case2,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
		} else {
			print "fatal error: encode_NEG_ASSIGN " > "/dev/stderr";
			print c1 > "/dev/stderr";
			print c2 > "/dev/stderr";
			exit
		}
	}else if ($0 ~ /^c encode_NEG/){
		# there should be 2 case
		# the last index is hte target
		c1=$0;
		getline;
		case1=del1and2($0);
		getline;
		c2=$0;
		getline;
		case2=del1and2($0);
	
		if (c1==c2) {
			numf=split(case1,ssyd);
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case1,abs(tgtv));
			# print always
			print_always(abs(tgtv),sprintf("%s %s", notgtv,deltgt(case2,abs(tgtv))));
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			numf=split(case2,ssyd);
			if( abs(tgtv) != abs(ssyd[numf-1]) ) {
				print "fatal error: encode_NEG tgtv is not uniquc" > "/dev/stderr";
				print case1 > "/dev/stderr";
				print case2 > "/dev/stderr";
				print case3 > "/dev/stderr";
				print case4 > "/dev/stderr";
				exit
			}
			tgtv=ssyd[numf-1];
			notgtv=deltgt(case2,abs(tgtv));

			printf "    else if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";

			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
		} else {
			print "fatal error: encode_NEG " > "/dev/stderr";
			print c1 > "/dev/stderr";
			print c2 > "/dev/stderr";
			exit
		}
	}else if ($0 ~ /^c truepred/){
		getline;
		if ($0 == "1 0") {
			print "assign truepred=1'b1;";
		} else {
			print "fatal error: truepred " > "/dev/stderr";
			print $0 > "/dev/stderr";
		}
	}else if ($0 ~ /^c falsepred/){
		getline;
		if ($0 == "-2 0") {
			print "assign falsepred=1'b0;";
		} else {
			print "fatal error: falsepred " > "/dev/stderr";
			print $0 > "/dev/stderr";
		}
	}else if ($0 ~ /^p cnf/){
	}else if ($0 ~ /^c init carry bit encode_ADD/){
		getline;
	}else if ($0 ~ /^c encode_ADD_1bit_cry/){
			numline=8;
			getline;
			case1=$0;
			numf=split(case1,ssyd);
			idx_tgt=ssyd[numf-1];
			
			tgtv=findtgt(case1,idx_tgt);
			notgtv=deltgt(case1,idx_tgt);
			# print always
			print_always(abs(tgtv),notgtv);
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			for(sdi=2;sdi<=numline;sdi=sdi+1) {
				#print sdi " tttt " numline > "/dev/stderr";
				getline;
				if($0 ~ /^c encode_ADD_1bit_cry/) {
					getline;
					case1=$0;
			
					tgtv=findtgt(case1,idx_tgt);
					notgtv=deltgt(case1,idx_tgt);

					printf "    else if(";
					print_condition(notgtv);
					print")";
					#print  "    begin";
					printf  "        " ;
					print_1bit_dst(tgtv);
					print  ""
					#print  "    end";
				} else {
					print "fatal error: encode_ADD_1bit_cry " sdi > "/dev/stderr";
					print $0 > "/dev/stderr";
					exit
				}
			}
			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
	}else if ($0 ~ /^c encode_ADD_1bit_res/){
			numline=8;
			getline;
			case1=$0;
			numf=split(case1,ssyd);
			idx_tgt=ssyd[numf-1];
			
			tgtv=findtgt(case1,idx_tgt);
			notgtv=deltgt(case1,idx_tgt);
			# print always
			print_always(abs(tgtv),notgtv);
			print "begin";

			printf "    if(";
			print_condition(notgtv);
			print")";
			#print  "    begin";
			printf  "        " ;
			print_1bit_dst(tgtv);
			print  ""
			#print  "    end";


			for(sdi=2;sdi<=numline;sdi=sdi+1) {
				#print sdi " tttt " numline > "/dev/stderr";
				getline;
				if($0 ~ /^c encode_ADD_1bit_res/) {
					getline;
					case1=$0;
			
					tgtv=findtgt(case1,idx_tgt);
					notgtv=deltgt(case1,idx_tgt);

					printf "    else if(";
					print_condition(notgtv);
					print")";
					#print  "    begin";
					printf  "        " ;
					print_1bit_dst(tgtv);
					print  ""
					#print  "    end";
				} else {
					print "fatal error: encode_ADD_1bit_res " sdi > "/dev/stderr";
					print $0 > "/dev/stderr";
					exit
				}
			}
			print "    else";
			print_1bit_dst_z(tgtv);

			print  "end";
			print "";
			print ""
	}else if ($0 ~ /^c for_rev_cz/){
	}else if ($0 ~ /^c pre_truepred/){
	}else {
		print "fatal error:" $0 > "/dev/stderr"
		exit
	}
}

END	{
	print "endmodule";
	for(ky in varry) {
		print "reg " ky " ;">> "vreg.v"
	}
}
