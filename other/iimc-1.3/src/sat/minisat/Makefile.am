AM_CXXFLAGS = -ffloat-store

AM_CPPFLAGS = -I$(srcdir)/..  -I$(srcdir)/simp -I$(srcdir)/mcore -I$(srcdir)/mtl -I$(srcdir)/utils -D __STDC_LIMIT_MACROS -D __STDC_FORMAT_MACROS


noinst_LIBRARIES = libminisat.a

libminisat_a_SOURCES = \
  simp/SimpSolver.cc \
  simp/SimpSolver.h \
  mcore/Solver.cc \
  mcore/Solver.h \
  mcore/SolverTypes.h \
  mtl/Alg.h \
  mtl/Alloc.h \
  mtl/Heap.h \
  mtl/MIntTypes.h \
  mtl/Map.h \
  mtl/Rnd.h \
  mtl/Queue.h \
  mtl/Sort.h \
  mtl/Vec.h \
  mtl/XAlloc.h \
  mtl/IntMap.h \
  utils/Options.h \
  utils/ParseUtils.h \
  utils/System.h \
  utils/System.cc

EXTRA_DIST = simp/Main.cc
