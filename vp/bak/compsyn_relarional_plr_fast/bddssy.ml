open Printf
open CaddieBdd
open Typedef
open Typedefcommon
open Misc

type bddssyType = T_bddssy_non
		| T_bddssy_node of bdd

let rec return_bdd wrap_bdd = begin
	match wrap_bdd with
	T_bddssy_non -> assert false
	| T_bddssy_node(bddfinal) -> bddfinal
end
and bdd_andlst bddlst = begin
	assert ((List.length bddlst)>1);
	let bddhead = List.hd bddlst
	and bddtail = List.tl bddlst
	in
	List.fold_left (fun x y -> CaddieBdd.bddAnd  x y) bddhead bddtail
end
and bdd_orlst bddlst = begin
	assert ((List.length bddlst)>1);
	let bddhead = List.hd bddlst
	and bddtail = List.tl bddlst
	in
	List.fold_left (fun x y -> CaddieBdd.bddOr  x y) bddhead bddtail
end
and simplify_withBDD arr_itpo ddM = begin
	assert((Array.length arr_itpo)>0 );
	let res= begin
		if((Array.length arr_itpo)>1 ) then begin
			simplify_withBDD_forced arr_itpo ddM
		end	
		else arr_itpo
	end
	in begin
		assert ((Array.length res)==1);
		res
	end
end
and simplify_withBDD_forced arr_itpo ddM = begin
		let hsh_Varidx_bddVar = Hashtbl.create 1 
		and hsh_bddVar_Varidx = Hashtbl.create 1 
		in begin
			let size=Array.length arr_itpo
			in
			let bddarray=Array.make size T_bddssy_non
			in
			let new_arr_itpo= Array.make 1 TiterpCircuit_none
			in begin
				(*you can place this here to ensure safety
				but you can also place it just before foreachcube function*)
				(*CaddieBdd.dynDisable ddM ;*)
				
				let rec find_dep pos = begin
					let itpo_elem = arr_itpo.(pos)
					and bdd_elem=bddarray.(pos)
					in
					let rec find_nonpos itpo_elem = begin
						match itpo_elem with
						TiterpCircuit_true -> begin
							T_bddssy_node(CaddieBdd.bddTrue ddM)
						end
						| TiterpCircuit_false -> begin
							T_bddssy_node(CaddieBdd.bddFalse ddM)
						end
						| TiterpCircuit_refcls(clsidx) -> begin
							let res=find_dep clsidx
							in begin
								assert ( res!=T_bddssy_non );
								res
							end
						end
						| TiterpCircuit_refvar(varidx1) -> begin
							let varidx = abs varidx1
							in
							if ((Hashtbl.mem hsh_Varidx_bddVar varidx)==false) then begin
								(*this var have not been mapped*)
								let res1=CaddieBdd.bddNewVar ddM
								in
								let res= if (varidx1<0) then CaddieBdd.bddNot res1 else res1
								in
								let newbddidx=CaddieBdd.bddIndex res1
								(*and newbddidxInv=CaddieBdd.bddIndex res*)
								in begin
									(*printf "new map bdd %d bddInv %d to var %d\n" newbddidx newbddidxInv varidx;*)
									Hashtbl.add hsh_Varidx_bddVar varidx newbddidx;
									Hashtbl.add hsh_bddVar_Varidx newbddidx varidx;
									(*Array.set bddarray pos res;*)
									T_bddssy_node(res)
								end
							end
							else begin
								let res1=CaddieBdd.bddIthVar ddM (Hashtbl.find hsh_Varidx_bddVar varidx)
								in
								let res= if (varidx1<0) then CaddieBdd.bddNot res1 else res1
								in begin
									(*Array.set bddarray pos res;*)
									T_bddssy_node(res)
								end
							end
						end
						| TiterpCircuit_and(itpolst) -> begin
							if ((List.length itpolst)==0) then begin
								T_bddssy_node(CaddieBdd.bddTrue ddM)
							end
							else if ((List.length itpolst)==1) then begin
								let res=find_nonpos (List.hd itpolst)
								in begin
									assert ( res!=T_bddssy_non );
									res
								end
							end
							else begin
								let bddlst=List.map find_nonpos itpolst
								in 
								T_bddssy_node(bdd_andlst (List.map (return_bdd) bddlst))
							end
						end
						| TiterpCircuit_or(itpolst) -> begin
							if ((List.length itpolst)==0) then begin
								T_bddssy_node(CaddieBdd.bddFalse ddM)
							end
							else if ((List.length itpolst)==1) then begin
								let res=find_nonpos (List.hd itpolst)
								in begin
									assert ( res!=T_bddssy_non );
									res
								end
							end
							else begin
								let bddlst=List.map find_nonpos itpolst
								in 
								T_bddssy_node(bdd_orlst (List.map (return_bdd) bddlst))
							end
						end
						| TiterpCircuit_not(itpo) -> begin
							T_bddssy_node(CaddieBdd.bddNot (return_bdd (find_nonpos itpo)))
						end
						| TiterpCircuit_none -> begin
							assert false ;
						end
						| TiterpCircuit_printed(_) -> begin
							assert false ;
						end
					end
					in begin
						if (bddarray.(pos)!=T_bddssy_non) then bdd_elem
						else begin
						match itpo_elem with
						TiterpCircuit_true -> begin
							let res=CaddieBdd.bddTrue ddM
							in begin
								Array.set bddarray pos (T_bddssy_node(res));
								(T_bddssy_node(res))
							end
						end
						| TiterpCircuit_false -> begin
							let res=CaddieBdd.bddFalse ddM
							in begin
								Array.set bddarray pos (T_bddssy_node(res));
								(T_bddssy_node(res))
							end
						end
						| TiterpCircuit_refcls(clsidx) -> begin
							let res=find_dep clsidx
							in begin
								assert(res!=T_bddssy_non);
								Array.set bddarray pos res;
								res
							end
						end
						| TiterpCircuit_refvar(varidx1) -> begin
							let varidx = abs varidx1
							in
							if ((Hashtbl.mem hsh_Varidx_bddVar varidx)==false) then begin
								(*this var have not been mapped*)
								let res1=CaddieBdd.bddNewVar ddM
								in
								let res= if (varidx1<0) then CaddieBdd.bddNot res1 else res1
								in
								let newbddidx=CaddieBdd.bddIndex res1
								(*and newbddidxInv=CaddieBdd.bddIndex res*)
								in begin
									(*printf "new map bdd %d bddInv %d to var %d\n" newbddidx newbddidxInv varidx;*)
									Hashtbl.add hsh_Varidx_bddVar varidx newbddidx;
									Hashtbl.add hsh_bddVar_Varidx newbddidx varidx;
									Array.set bddarray pos (T_bddssy_node(res));
									(T_bddssy_node(res))
								end
							end
							else begin
								let res1=CaddieBdd.bddIthVar ddM (Hashtbl.find hsh_Varidx_bddVar varidx)
								in
								let res= if (varidx1<0) then CaddieBdd.bddNot res1 else res1
								in begin
									Array.set bddarray pos (T_bddssy_node(res));
									(T_bddssy_node(res))
								end
							end
						end
						| TiterpCircuit_and(itpolst) -> begin
							if ((List.length itpolst)==0) then begin
								let res=T_bddssy_node(CaddieBdd.bddTrue ddM)
								in begin
									Array.set bddarray pos res;
									res
								end
							end
							else if ((List.length itpolst)==1) then begin
								let res=find_nonpos (List.hd itpolst)
								in begin
									assert ( res!=T_bddssy_non );
									Array.set bddarray pos res;
									res
								end
							end
							else begin
								let bddlst=List.map find_nonpos itpolst
								in 
								let res=bdd_andlst (List.map (return_bdd) bddlst)
								in begin
									Array.set bddarray pos (T_bddssy_node(res));
									(T_bddssy_node(res))
								end
							end
						end
						| TiterpCircuit_or(itpolst) -> begin
							if ((List.length itpolst)==0) then begin
								let res=T_bddssy_node(CaddieBdd.bddFalse ddM)
								in begin
									Array.set bddarray pos res;
									res
								end
							end
							else if ((List.length itpolst)==1) then begin
								let res=find_nonpos (List.hd itpolst)
								in begin
									assert ( res!=T_bddssy_non );
									Array.set bddarray pos res;
									res
								end
							end
							else begin
								let bddlst=List.map find_nonpos itpolst
								in 
								let res=bdd_orlst (List.map (return_bdd) bddlst)
								in begin
									Array.set bddarray pos (T_bddssy_node(res));
									(T_bddssy_node(res))
								end
							end
						end
						| TiterpCircuit_not(itpo) -> begin
							let res=T_bddssy_node(CaddieBdd.bddNot (return_bdd (find_nonpos itpo)))
							in begin
								assert ( res!=T_bddssy_non );
								Array.set bddarray pos res;
								res
							end
						end
						| TiterpCircuit_none -> begin
							assert false ;
						end
						| TiterpCircuit_printed(_) -> begin
							assert false ;
						end
						end
					end
				end
				in begin
					find_dep (size-1);
					
					(*bddarray.(size-1) is the bdd of the function 
					I need to change it back to itpo*)
					match (bddarray.(size-1)) with
					T_bddssy_non -> begin
						printf "FATAL : size %d \n" size;
						flush stdout ;
						assert false
					end
					| T_bddssy_node(bddfinal) -> begin
						let itpolst4bdd = ref []
						in
						let proc_itpobddcube cube = begin
							let proc_cubeelem cubeelem valueelem = begin
								if ( valueelem == 0 ) then begin
									let varidx111=Hashtbl.find hsh_bddVar_Varidx cubeelem
									in
									TiterpCircuit_refvar(-varidx111)
								end
								else if ( valueelem == 1 ) then begin
									let varidx111=Hashtbl.find hsh_bddVar_Varidx cubeelem
									in
									TiterpCircuit_refvar(varidx111)
								end
								else begin
									assert ( valueelem == 2 );
									TiterpCircuit_true
								end
							end
							in
							let cube1=Array.mapi proc_cubeelem cube
							in
							let lst_cube_itpo=List.filter (fun x -> match x with TiterpCircuit_true -> false | _ -> true) (Array.to_list cube1)
							in
							itpolst4bdd := (TiterpCircuit_and(lst_cube_itpo))::(!itpolst4bdd)
						end
						in begin
							CaddieBdd.dynDisable ddM ;
							dbg_print "before bddForeachCube";
							CaddieBdd.bddForeachCube bddfinal proc_itpobddcube;
							dbg_print "after bddForeachCube" ;

							if(CaddieBdd.bddEqual bddfinal (CaddieBdd.bddTrue ddM)) then begin
								Array.set new_arr_itpo 0 (TiterpCircuit_true)
							end
							else if(CaddieBdd.bddEqual bddfinal (CaddieBdd.bddFalse ddM)) then begin
								Array.set new_arr_itpo 0 (TiterpCircuit_false)
							end
							else if ((List.length (!itpolst4bdd))==0) then begin
								printf "warning : itpolst4bdd is null\n" ;
								Array.set new_arr_itpo 0 (TiterpCircuit_false)
							end
							else begin
								Array.set new_arr_itpo 0 (TiterpCircuit_or(!itpolst4bdd))
							end
							;
							
							(*CaddieBdd.exit ddM;*)
							Hashtbl.clear hsh_Varidx_bddVar ;
							Hashtbl.clear hsh_bddVar_Varidx ;
							dbg_print (sprintf "simplify_withBDD reduce %d to %d" (Array.length arr_itpo) (List.length (!itpolst4bdd)));
							new_arr_itpo
						end
					end
				end
			end
		end
end
and simplify_withBDD_withassumption itpcircuit assumptionlist ddM= begin
		let arr_itpo=simplify_withBDD itpcircuit ddM
		in begin
				let rec find_dep pos = begin
					let itpo_elem = arr_itpo.(pos)
					in
					let rec find_nonpos itpo_elem = begin
						match itpo_elem with
						TiterpCircuit_true -> itpo_elem
						| TiterpCircuit_false -> itpo_elem
						| TiterpCircuit_refcls(clsidx) -> itpo_elem
						| TiterpCircuit_refvar(varidx1) -> begin
							let varidx1_neg = -varidx1
							in
							if ((List.mem varidx1 assumptionlist )==true) then begin
								(*varidx1 is in *)
								TiterpCircuit_true
							end
							else if ((List.mem varidx1_neg assumptionlist )==true) then begin
								TiterpCircuit_false
							end
							else itpo_elem
						end
						| TiterpCircuit_and(itpolst) -> begin
							if ((List.length itpolst)>0) then 
								TiterpCircuit_and(List.map find_nonpos itpolst)
							else TiterpCircuit_true
						end
						| TiterpCircuit_or(itpolst) -> begin
							if ((List.length itpolst)>0) then 
								TiterpCircuit_or(List.map find_nonpos itpolst)
							else TiterpCircuit_false
						end
						| TiterpCircuit_not(itpo) -> begin
							TiterpCircuit_not(find_nonpos itpo)
						end
						| TiterpCircuit_none -> begin
							assert false ;
						end
						| TiterpCircuit_printed(_) -> begin
							assert false ;
						end
					end
					in begin
						match itpo_elem with
						TiterpCircuit_true -> ()
						| TiterpCircuit_false -> ()
						| TiterpCircuit_refcls(clsidx) -> ()
						| TiterpCircuit_refvar(varidx1) -> begin
							let varidx1_neg = -varidx1
							in
							if ((List.mem varidx1 assumptionlist )==true) then begin
								(*varidx1 is in *)
								Array.set arr_itpo pos TiterpCircuit_true;
								()
							end
							else if ((List.mem varidx1_neg assumptionlist )==true) then begin
								Array.set arr_itpo pos TiterpCircuit_false;
								()
							end
						end
						| TiterpCircuit_and(itpolst) -> begin
							if ((List.length itpolst)>0) then begin
								let itpooolst=List.map find_nonpos itpolst
								in
								Array.set arr_itpo pos (TiterpCircuit_and(itpooolst));
								()
							end
							else begin
								Array.set arr_itpo pos TiterpCircuit_true;
								()
							end
						end
						| TiterpCircuit_or(itpolst) -> begin
							if ((List.length itpolst)>0) then begin
								let itpooolst=List.map find_nonpos itpolst
								in
								Array.set arr_itpo pos (TiterpCircuit_or(itpooolst));
								()
							end
							else begin
								Array.set arr_itpo pos TiterpCircuit_false;
								()
							end
						end
						| TiterpCircuit_not(itpo) -> begin
							let itpooo=find_nonpos itpo
							in
							Array.set arr_itpo pos (TiterpCircuit_not(itpooo));
							()
						end
						| TiterpCircuit_none -> begin
							assert false ;
						end
						| TiterpCircuit_printed(_) -> begin
							assert false ;
						end
					end
				end
				in 
				find_dep ((Array.length arr_itpo)-1);
				
				simplify_withBDD arr_itpo ddM
		end
end
	
