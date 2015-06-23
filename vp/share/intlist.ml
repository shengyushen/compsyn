(*using lots of hash to improve the list operation*)
let rec listUniq lst = begin
	let sz=List.length lst in
	let hashMarked=Hashtbl.create sz in begin
		List.iter (fun vi -> if((Hashtbl.mem hashMarked vi)=false) then Hashtbl.add hashMarked vi true) lst;
		Hashtbl.fold (fun k d i -> k::i) hashMarked []
	end
end
and isListUniq lst = begin
	not (isListDup lst)
end
and isListDup lst= begin
	let sz=List.length lst in
	let hashMarked=Hashtbl.create sz in begin
		let rec isListDupInternal lst1 = begin
			match lst1 with
			hd::tl -> begin
				if(Hashtbl.mem hashMarked hd) then true
				else begin
					Hashtbl.add hashMarked hd true;
					isListDupInternal tl
				end
			end
			|_ -> false
		end in
		isListDupInternal lst
	end
(*	let rec isListDupInternal e lst1 = begin
		match lst1 with
		hd1::tl1 -> begin
			if(List.mem e lst1) then true
			else isListDupInternal hd1 tl1
		end
		| _ -> false
	end in 
	begin
		match lst with
		hd::tl -> isListDupInternal hd tl
		|_ -> false
	end*)
end
and listMin lst = begin
	match lst with
	hd::tl ->	List.fold_left (fun a b -> min a b) hd tl
	| _ -> assert false
end
and listMax lst = begin
	match lst with
	hd::tl -> List.fold_left (fun a b -> max a b) hd tl
	| _ -> assert false
end
and isIntersect lst1 lst2 = begin
	let sz=List.length lst2 in
	let hashMarked=Hashtbl.create sz in begin
		List.iter (fun vi ->  Hashtbl.add hashMarked vi true) lst2;
		List.exists (fun vi -> Hashtbl.mem hashMarked vi) lst1
	end
end
and listIntersect lst1 lst2 = begin
	let sz=List.length lst2 in
	let hashMarked=Hashtbl.create sz in begin
		List.iter (fun vi -> Hashtbl.add hashMarked vi true) lst2;
		List.filter (fun vi -> Hashtbl.mem hashMarked vi) lst1
	end
end
and genlst len =begin
	let rec genlst_internal pos = begin
		if (pos < len) then pos::(genlst_internal (pos+1))
		else []
	end in
	genlst_internal 0
end
and listmapi f lst = begin
	let len=List.length lst in
	let idxlst=genlst len in
	let comblst=List.combine idxlst lst in
	List.map (fun x -> match x with (a,b) -> (f a b)) comblst
end
and listiteri f lst = begin
	let len=List.length lst in
	let idxlst=genlst len in
	let comblst=List.combine idxlst lst in
	List.iter (fun x -> match x with (a,b) -> (f a b)) comblst
end
and removeSubList lst = begin(*HAHA : this can be improved by transform the lst into hash, and then *)
	let rec removeSubList_internal reslst remainlst =  begin
		match remainlst with
		hd::tl -> begin
			let issublst=List.exists (fun otherlst -> isLst1inLst2 hd otherlst) reslst in begin
				if issublst then removeSubList_internal reslst tl 
				else removeSubList_internal (hd::reslst) tl
			end
		end
		| _ -> reslst
	end in
	removeSubList_internal [] lst
end
and listSum lst= begin
	List.fold_left (fun a b -> a+b) 0 lst
end
and sublst lst1 lst2 = begin
	let sz=List.length lst2 in
	let hashMarked=Hashtbl.create sz in begin
		List.iter (fun vi ->  Hashtbl.add hashMarked vi true) lst2;
		List.filter (fun vi-> (Hashtbl.mem hashMarked vi)=false) lst1
	end
end
and isLst1inHash2 lst1 hash2 = begin
	(*if((List.length lst1)>(Hashtbl.length hash2)) then false
	else *)List.for_all (fun vi -> Hashtbl.mem hash2 vi) lst1
end
and list2Hash lst = begin
	let sz=List.length lst in
	let hashMarked=Hashtbl.create sz in begin
		List.iter (fun vi ->  Hashtbl.add hashMarked vi true) lst;
		hashMarked
	end
end
and isLst1inLst2 lst1 lst2 = begin
	let sz=List.length lst2 in begin
		(*if((List.length lst1) > sz) then false
		else begin*)
			let hashMarked=Hashtbl.create sz in begin
				List.iter (fun vi ->  Hashtbl.add hashMarked vi true) lst2;
				List.for_all (fun vi -> Hashtbl.mem hashMarked vi) lst1
			end
		(*end*)
	end
(*	if((List.length lst1) > (List.length lst2)) then false
	else List.for_all (fun x1 -> List.mem x1 lst2) lst1*)
end
and lstlstConcatUniq lstlst = begin
	let lenlst=List.map (List.length) lstlst in
	let totalsum=listSum lenlst in
	let hashMarked=Hashtbl.create totalsum in begin
		List.iter (fun lst -> List.iter (fun v -> if((Hashtbl.mem hashMarked v)=false) then Hashtbl.add hashMarked v true ) lst) lstlst;
		Hashtbl.fold (fun k d i -> k::i) hashMarked []
	end
end	
and list2lr idxlst = begin
	(*let lstsrted = List.sort compare idxlst in*)
	let rec lst2lsr lst l r = begin
		match lst with 
		[] -> (l,r)
		| hdlst::tllst -> begin
			assert(hdlst =(l+1));
			assert(l>= r);
			lst2lsr tllst (l+1) r
		end
	end in
	match idxlst with
	[] -> assert false
	| hd::tl -> begin
		lst2lsr tl hd hd
	end
end
and isEmptyList lst = begin
	match lst with
	[] -> true
	| _ -> false
end
and isSingularList lst = begin
	match lst with
	[z] -> true
	| _ -> false
end
and listPartition iselim lst = begin
	let rec listPartition_internal currentlist = begin
		match currentlist with
		hd::tl -> begin
			let (remainCurrentList,remainList)=listPartition_internal tl
			in begin
				if(iselim hd) then ([],remainCurrentList::remainList)
				else (hd::remainCurrentList,remainList)
			end
		end
		| _ -> ([],[])
	end
	in
	listPartition_internal lst
end
