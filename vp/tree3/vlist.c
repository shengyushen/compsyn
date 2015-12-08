#include <stdio.h> 
#include <stdlib.h> 
#include <assert.h> 
#include "typedef.h"
#include "vlist.h"

void vlist_init (vlist * vlp) {
	vlp->headp =(vlistnode *) NULL;
	vlp->tailp =(vlistnode *) NULL;
}


void vlist_free (vlist * vlp) {
	assert(vlp);
	vlistnode * currentp = vlp-> headp;
	while(currentp) {
		vlistnode * nextpp = currentp -> nextp;
		free((void *)currentp);
		currentp=nextpp;
	}
	vlist_init(vlp);
	return;
}

void vlist_insert (vlist * vlp , value_t v) {
	vlistnode * newvlnp = malloc (sizeof(vlistnode));
	newvlnp -> nextp = (vlistnode *)NULL;
	newvlnp -> v = v;
	if(vlp->headp) {
		assert(vlp->tailp);
		vlp->tailp->nextp = newvlnp;
		vlp->tailp = newvlnp;
	} else {
		assert (!(vlp->tailp));
		vlp->headp = newvlnp;
		vlp->tailp = newvlnp;
	}
}

unsigned vlist_compare_array (vlist * vlp, DataNode * dnp,size_t num) {
	assert (num >=0);
	if(num==0) {
		assert (!(vlp->headp));
		assert (!(vlp->tailp));
		return 1;
	} else {
		assert (vlp->headp);
		assert (vlp->tailp);
		int i;
		vlistnode * currentp=vlp->headp;
		for(i=0;i<num;i++) {
			assert(currentp);
			if((currentp->v)!=((dnp[i]).value)) {
				return 0;
			}
			currentp=currentp->nextp;
		}
		return 1;
	}
}


void vlist_print(vlist * vlp) {
	assert(vlp);
	vlistnode * currentp = vlp-> headp;
	while(currentp) {
		vlistnode * nextpp = currentp -> nextp;
		printf( "%d ", currentp->v);
		currentp=nextpp;
	}
	printf("\n");
	return;
	}
