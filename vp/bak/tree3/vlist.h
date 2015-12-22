typedef struct vlistnode vlistnode ;
typedef struct vlist vlist ;

struct vlistnode {
	value_t v;
	vlistnode * nextp;
};

struct vlist {
	vlistnode * headp;
	vlistnode * tailp;
};
void vlist_init (vlist * vlp);
void vlist_free (vlist * vlp);
void vlist_insert (vlist * vlp , value_t v);
