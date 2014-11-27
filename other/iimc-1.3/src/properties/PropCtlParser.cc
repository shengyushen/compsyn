/* A Bison parser, made by GNU Bison 2.5.  */

/* Skeleton implementation for Bison LALR(1) parsers in C++
   
      Copyright (C) 2002-2011 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* First part of user declarations.  */


/* Line 293 of lalr1.cc  */
#line 39 "src/properties/PropCtlParser.cc"


#include "PropCtlParser.hh"

/* User implementation prologue.  */


/* Line 299 of lalr1.cc  */
#line 48 "src/properties/PropCtlParser.cc"
/* Unqualified %code blocks.  */

/* Line 300 of lalr1.cc  */
#line 28 "../iimc/src/properties/PropCtlParser.yy"

#include "PropCtlWrapper.h"



/* Line 300 of lalr1.cc  */
#line 59 "src/properties/PropCtlParser.cc"

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* FIXME: INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                               \
 do                                                                    \
   if (N)                                                              \
     {                                                                 \
       (Current).begin = YYRHSLOC (Rhs, 1).begin;                      \
       (Current).end   = YYRHSLOC (Rhs, N).end;                        \
     }                                                                 \
   else                                                                \
     {                                                                 \
       (Current).begin = (Current).end = YYRHSLOC (Rhs, 0).end;        \
     }                                                                 \
 while (false)
#endif

/* Suppress unused-variable warnings by "using" E.  */
#define YYUSE(e) ((void) (e))

/* Enable debugging if requested.  */
#if YYDEBUG

/* A pseudo ostream that takes yydebug_ into account.  */
# define YYCDEBUG if (yydebug_) (*yycdebug_)

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)	\
do {							\
  if (yydebug_)						\
    {							\
      *yycdebug_ << Title << ' ';			\
      yy_symbol_print_ ((Type), (Value), (Location));	\
      *yycdebug_ << std::endl;				\
    }							\
} while (false)

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug_)				\
    yy_reduce_print_ (Rule);		\
} while (false)

# define YY_STACK_PRINT()		\
do {					\
  if (yydebug_)				\
    yystack_print_ ();			\
} while (false)

#else /* !YYDEBUG */

# define YYCDEBUG if (false) std::cerr
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_REDUCE_PRINT(Rule)
# define YY_STACK_PRINT()

#endif /* !YYDEBUG */

#define yyerrok		(yyerrstatus_ = 0)
#define yyclearin	(yychar = yyempty_)

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab
#define YYRECOVERING()  (!!yyerrstatus_)


namespace yy {

/* Line 382 of lalr1.cc  */
#line 145 "src/properties/PropCtlParser.cc"

  /* Return YYSTR after stripping away unnecessary quotes and
     backslashes, so that it's suitable for yyerror.  The heuristic is
     that double-quoting is unnecessary unless the string contains an
     apostrophe, a comma, or backslash (other than backslash-backslash).
     YYSTR is taken from yytname.  */
  std::string
  ctl_parser::yytnamerr_ (const char *yystr)
  {
    if (*yystr == '"')
      {
        std::string yyr = "";
        char const *yyp = yystr;

        for (;;)
          switch (*++yyp)
            {
            case '\'':
            case ',':
              goto do_not_strip_quotes;

            case '\\':
              if (*++yyp != '\\')
                goto do_not_strip_quotes;
              /* Fall through.  */
            default:
              yyr += *yyp;
              break;

            case '"':
              return yyr;
            }
      do_not_strip_quotes: ;
      }

    return yystr;
  }


  /// Build a parser object.
  ctl_parser::ctl_parser (ctl_driver& driver_yyarg)
    :
#if YYDEBUG
      yydebug_ (false),
      yycdebug_ (&std::cerr),
#endif
      driver (driver_yyarg)
  {
  }

  ctl_parser::~ctl_parser ()
  {
  }

#if YYDEBUG
  /*--------------------------------.
  | Print this symbol on YYOUTPUT.  |
  `--------------------------------*/

  inline void
  ctl_parser::yy_symbol_value_print_ (int yytype,
			   const semantic_type* yyvaluep, const location_type* yylocationp)
  {
    YYUSE (yylocationp);
    YYUSE (yyvaluep);
    switch (yytype)
      {
        case 8: /* "\"identifier\"" */

/* Line 449 of lalr1.cc  */
#line 39 "../iimc/src/properties/PropCtlParser.yy"
	{ debug_stream() << *(yyvaluep->sval); };

/* Line 449 of lalr1.cc  */
#line 220 "src/properties/PropCtlParser.cc"
	break;
      case 29: /* "formula" */

/* Line 449 of lalr1.cc  */
#line 41 "../iimc/src/properties/PropCtlParser.yy"
	{ debug_stream() << stringOf(*driver.ev,(yyvaluep->ival)); };

/* Line 449 of lalr1.cc  */
#line 229 "src/properties/PropCtlParser.cc"
	break;
       default:
	  break;
      }
  }


  void
  ctl_parser::yy_symbol_print_ (int yytype,
			   const semantic_type* yyvaluep, const location_type* yylocationp)
  {
    *yycdebug_ << (yytype < yyntokens_ ? "token" : "nterm")
	       << ' ' << yytname_[yytype] << " ("
	       << *yylocationp << ": ";
    yy_symbol_value_print_ (yytype, yyvaluep, yylocationp);
    *yycdebug_ << ')';
  }
#endif

  void
  ctl_parser::yydestruct_ (const char* yymsg,
			   int yytype, semantic_type* yyvaluep, location_type* yylocationp)
  {
    YYUSE (yylocationp);
    YYUSE (yymsg);
    YYUSE (yyvaluep);

    YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

    switch (yytype)
      {
        case 8: /* "\"identifier\"" */

/* Line 480 of lalr1.cc  */
#line 40 "../iimc/src/properties/PropCtlParser.yy"
	{ delete (yyvaluep->sval); };

/* Line 480 of lalr1.cc  */
#line 268 "src/properties/PropCtlParser.cc"
	break;

	default:
	  break;
      }
  }

  void
  ctl_parser::yypop_ (unsigned int n)
  {
    yystate_stack_.pop (n);
    yysemantic_stack_.pop (n);
    yylocation_stack_.pop (n);
  }

#if YYDEBUG
  std::ostream&
  ctl_parser::debug_stream () const
  {
    return *yycdebug_;
  }

  void
  ctl_parser::set_debug_stream (std::ostream& o)
  {
    yycdebug_ = &o;
  }


  ctl_parser::debug_level_type
  ctl_parser::debug_level () const
  {
    return yydebug_;
  }

  void
  ctl_parser::set_debug_level (debug_level_type l)
  {
    yydebug_ = l;
  }
#endif

  inline bool
  ctl_parser::yy_pact_value_is_default_ (int yyvalue)
  {
    return yyvalue == yypact_ninf_;
  }

  inline bool
  ctl_parser::yy_table_value_is_error_ (int yyvalue)
  {
    return yyvalue == yytable_ninf_;
  }

  int
  ctl_parser::parse ()
  {
    /// Lookahead and lookahead in internal form.
    int yychar = yyempty_;
    int yytoken = 0;

    /* State.  */
    int yyn;
    int yylen = 0;
    int yystate = 0;

    /* Error handling.  */
    int yynerrs_ = 0;
    int yyerrstatus_ = 0;

    /// Semantic value of the lookahead.
    semantic_type yylval;
    /// Location of the lookahead.
    location_type yylloc;
    /// The locations where the error started and ended.
    location_type yyerror_range[3];

    /// $$.
    semantic_type yyval;
    /// @$.
    location_type yyloc;

    int yyresult;

    YYCDEBUG << "Starting parse" << std::endl;


    /* User initialization code.  */
    
/* Line 565 of lalr1.cc  */
#line 16 "../iimc/src/properties/PropCtlParser.yy"
{
  // Initialize the initial location.
  yylloc.begin.filename = yylloc.end.filename = &driver.file;
}

/* Line 565 of lalr1.cc  */
#line 366 "src/properties/PropCtlParser.cc"

    /* Initialize the stacks.  The initial state will be pushed in
       yynewstate, since the latter expects the semantical and the
       location values to have been already stored, initialize these
       stacks with a primary value.  */
    yystate_stack_ = state_stack_type (0);
    yysemantic_stack_ = semantic_stack_type (0);
    yylocation_stack_ = location_stack_type (0);
    yysemantic_stack_.push (yylval);
    yylocation_stack_.push (yylloc);

    /* New state.  */
  yynewstate:
    yystate_stack_.push (yystate);
    YYCDEBUG << "Entering state " << yystate << std::endl;

    /* Accept?  */
    if (yystate == yyfinal_)
      goto yyacceptlab;

    goto yybackup;

    /* Backup.  */
  yybackup:

    /* Try to take a decision without lookahead.  */
    yyn = yypact_[yystate];
    if (yy_pact_value_is_default_ (yyn))
      goto yydefault;

    /* Read a lookahead token.  */
    if (yychar == yyempty_)
      {
	YYCDEBUG << "Reading a token: ";
	yychar = yylex (&yylval, &yylloc, driver);
      }


    /* Convert token to internal form.  */
    if (yychar <= yyeof_)
      {
	yychar = yytoken = yyeof_;
	YYCDEBUG << "Now at end of input." << std::endl;
      }
    else
      {
	yytoken = yytranslate_ (yychar);
	YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
      }

    /* If the proper action on seeing token YYTOKEN is to reduce or to
       detect an error, take that action.  */
    yyn += yytoken;
    if (yyn < 0 || yylast_ < yyn || yycheck_[yyn] != yytoken)
      goto yydefault;

    /* Reduce or error.  */
    yyn = yytable_[yyn];
    if (yyn <= 0)
      {
	if (yy_table_value_is_error_ (yyn))
	  goto yyerrlab;
	yyn = -yyn;
	goto yyreduce;
      }

    /* Shift the lookahead token.  */
    YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

    /* Discard the token being shifted.  */
    yychar = yyempty_;

    yysemantic_stack_.push (yylval);
    yylocation_stack_.push (yylloc);

    /* Count tokens shifted since error; after three, turn off error
       status.  */
    if (yyerrstatus_)
      --yyerrstatus_;

    yystate = yyn;
    goto yynewstate;

  /*-----------------------------------------------------------.
  | yydefault -- do the default action for the current state.  |
  `-----------------------------------------------------------*/
  yydefault:
    yyn = yydefact_[yystate];
    if (yyn == 0)
      goto yyerrlab;
    goto yyreduce;

  /*-----------------------------.
  | yyreduce -- Do a reduction.  |
  `-----------------------------*/
  yyreduce:
    yylen = yyr2_[yyn];
    /* If YYLEN is nonzero, implement the default value of the action:
       `$$ = $1'.  Otherwise, use the top of the stack.

       Otherwise, the following line sets YYVAL to garbage.
       This behavior is undocumented and Bison
       users should not rely upon it.  */
    if (yylen)
      yyval = yysemantic_stack_[yylen - 1];
    else
      yyval = yysemantic_stack_[0];

    {
      slice<location_type, location_stack_type> slice (yylocation_stack_, yylen);
      YYLLOC_DEFAULT (yyloc, slice, yylen);
    }
    YY_REDUCE_PRINT (yyn);
    switch (yyn)
      {
	  case 3:

/* Line 690 of lalr1.cc  */
#line 53 "../iimc/src/properties/PropCtlParser.yy"
    { driver.eat->addCtlProperty((yysemantic_stack_[(2) - (2)].ival)); }
    break;

  case 4:

/* Line 690 of lalr1.cc  */
#line 56 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = (yysemantic_stack_[(3) - (2)].ival); }
    break;

  case 5:

/* Line 690 of lalr1.cc  */
#line 57 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->btrue(); }
    break;

  case 6:

/* Line 690 of lalr1.cc  */
#line 58 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->bfalse(); }
    break;

  case 7:

/* Line 690 of lalr1.cc  */
#line 59 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->apply(Expr::X, (yysemantic_stack_[(2) - (2)].ival)); }
    break;

  case 8:

/* Line 690 of lalr1.cc  */
#line 60 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->apply(Expr::F, (yysemantic_stack_[(2) - (2)].ival)); }
    break;

  case 9:

/* Line 690 of lalr1.cc  */
#line 61 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->apply(Expr::G, (yysemantic_stack_[(2) - (2)].ival)); }
    break;

  case 10:

/* Line 690 of lalr1.cc  */
#line 62 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->apply(Expr::U, (yysemantic_stack_[(4) - (2)].ival), (yysemantic_stack_[(4) - (4)].ival)); }
    break;

  case 11:

/* Line 690 of lalr1.cc  */
#line 63 "../iimc/src/properties/PropCtlParser.yy"
    { ID conj = driver.ev->apply(Expr::And, (yysemantic_stack_[(4) - (2)].ival), (yysemantic_stack_[(4) - (4)].ival));
                                      ID until = driver.ev->apply(Expr::U, (yysemantic_stack_[(4) - (4)].ival), conj);
                                      ID eg = driver.ev->apply(Expr::G, (yysemantic_stack_[(4) - (4)].ival));
                                      ID negu = driver.ev->apply(Expr::Not, until);
                                      ID nege = driver.ev->apply(Expr::Not, eg);
                                      ID conj2 = driver.ev->apply(Expr::And, negu, nege);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, conj2); }
    break;

  case 12:

/* Line 690 of lalr1.cc  */
#line 70 "../iimc/src/properties/PropCtlParser.yy"
    { ID until = driver.ev->apply(Expr::U, (yysemantic_stack_[(4) - (2)].ival), (yysemantic_stack_[(4) - (4)].ival));
                                      ID eg = driver.ev->apply(Expr::G, (yysemantic_stack_[(4) - (2)].ival));
                                      ID negu = driver.ev->apply(Expr::Not, until);
                                      ID nege = driver.ev->apply(Expr::Not, eg);
                                      ID conj = driver.ev->apply(Expr::And, negu, nege);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, conj); }
    break;

  case 13:

/* Line 690 of lalr1.cc  */
#line 76 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg = driver.ev->apply(Expr::Not, (yysemantic_stack_[(2) - (2)].ival));
                                      ID neg = driver.ev->apply(Expr::X, arg);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, neg); }
    break;

  case 14:

/* Line 690 of lalr1.cc  */
#line 79 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg = driver.ev->apply(Expr::Not, (yysemantic_stack_[(2) - (2)].ival));
                                      ID neg = driver.ev->apply(Expr::G, arg);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, neg); }
    break;

  case 15:

/* Line 690 of lalr1.cc  */
#line 82 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg = driver.ev->apply(Expr::Not, (yysemantic_stack_[(2) - (2)].ival));
                                      ID neg = driver.ev->apply(Expr::F, arg);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, neg); }
    break;

  case 16:

/* Line 690 of lalr1.cc  */
#line 85 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg2 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(4) - (2)].ival));
                                      ID arg4 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(4) - (4)].ival));
                                      ID conj = driver.ev->apply(Expr::And, arg2, arg4);
                                      ID until = driver.ev->apply(Expr::U, arg4, conj);
                                      ID eg = driver.ev->apply(Expr::G, arg4);
                                      ID negu = driver.ev->apply(Expr::Not, until);
                                      ID nege = driver.ev->apply(Expr::Not, eg);
                                      (yyval.ival) = driver.ev->apply(Expr::And, negu, nege); }
    break;

  case 17:

/* Line 690 of lalr1.cc  */
#line 93 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg2 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(4) - (2)].ival));
                                      ID arg4 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(4) - (4)].ival));
                                      ID neg = driver.ev->apply(Expr::U, arg2, arg4);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, neg); }
    break;

  case 18:

/* Line 690 of lalr1.cc  */
#line 97 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg2 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(4) - (2)].ival));
                                      ID arg4 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(4) - (4)].ival));
                                      ID argc = driver.ev->apply(Expr::And, arg2, arg4);
                                      ID neg = driver.ev->apply(Expr::U, arg4, argc);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, neg); }
    break;

  case 19:

/* Line 690 of lalr1.cc  */
#line 102 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg1 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(3) - (1)].ival));
                                      ID arg3 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(3) - (3)].ival));
                                      ID conj = driver.ev->apply(Expr::And, arg1, arg3);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, conj); }
    break;

  case 20:

/* Line 690 of lalr1.cc  */
#line 106 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->apply(Expr::And, (yysemantic_stack_[(3) - (1)].ival), (yysemantic_stack_[(3) - (3)].ival)); }
    break;

  case 21:

/* Line 690 of lalr1.cc  */
#line 107 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg1 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(3) - (1)].ival));
                                      ID arg3 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(3) - (3)].ival));
                                      ID conj1 = driver.ev->apply(Expr::And, (yysemantic_stack_[(3) - (1)].ival), (yysemantic_stack_[(3) - (3)].ival));
                                      ID conj2 = driver.ev->apply(Expr::And, arg1, arg3);
                                      ID neg1 = driver.ev->apply(Expr::Not, conj1);
                                      ID neg2 = driver.ev->apply(Expr::Not, conj2);
                                      (yyval.ival) = driver.ev->apply(Expr::And, neg1, neg2); }
    break;

  case 22:

/* Line 690 of lalr1.cc  */
#line 114 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg1 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(3) - (1)].ival));
                                      ID arg3 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(3) - (3)].ival));
                                      ID conj1 = driver.ev->apply(Expr::And, (yysemantic_stack_[(3) - (1)].ival), arg3);
                                      ID conj2 = driver.ev->apply(Expr::And, arg1, (yysemantic_stack_[(3) - (3)].ival));
                                      ID neg1 = driver.ev->apply(Expr::Not, conj1);
                                      ID neg2 = driver.ev->apply(Expr::Not, conj2);
                                      (yyval.ival) = driver.ev->apply(Expr::And, neg1, neg2); }
    break;

  case 23:

/* Line 690 of lalr1.cc  */
#line 121 "../iimc/src/properties/PropCtlParser.yy"
    { ID arg3 = driver.ev->apply(Expr::Not, (yysemantic_stack_[(3) - (3)].ival));
                                      ID conj = driver.ev->apply(Expr::And, (yysemantic_stack_[(3) - (1)].ival), arg3);
                                      (yyval.ival) = driver.ev->apply(Expr::Not, conj); }
    break;

  case 24:

/* Line 690 of lalr1.cc  */
#line 124 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->apply(Expr::Not, (yysemantic_stack_[(2) - (2)].ival)); }
    break;

  case 25:

/* Line 690 of lalr1.cc  */
#line 125 "../iimc/src/properties/PropCtlParser.yy"
    { (yyval.ival) = driver.ev->apply(Expr::Not, (yysemantic_stack_[(2) - (2)].ival)); }
    break;

  case 26:

/* Line 690 of lalr1.cc  */
#line 126 "../iimc/src/properties/PropCtlParser.yy"
    { if (driver.ev->varExists(*(yysemantic_stack_[(1) - (1)].sval))) {
                                        (yyval.ival) = driver.ev->newVar(*(yysemantic_stack_[(1) - (1)].sval));
                                      } else {
                                        error(yylloc, std::string("unknown variable: ") + *(yysemantic_stack_[(1) - (1)].sval));
                                        YYERROR;
                                      }
                                      delete (yysemantic_stack_[(1) - (1)].sval);
                                    }
    break;

  case 27:

/* Line 690 of lalr1.cc  */
#line 134 "../iimc/src/properties/PropCtlParser.yy"
    { YYERROR; }
    break;



/* Line 690 of lalr1.cc  */
#line 715 "src/properties/PropCtlParser.cc"
	default:
          break;
      }
    /* User semantic actions sometimes alter yychar, and that requires
       that yytoken be updated with the new translation.  We take the
       approach of translating immediately before every use of yytoken.
       One alternative is translating here after every semantic action,
       but that translation would be missed if the semantic action
       invokes YYABORT, YYACCEPT, or YYERROR immediately after altering
       yychar.  In the case of YYABORT or YYACCEPT, an incorrect
       destructor might then be invoked immediately.  In the case of
       YYERROR, subsequent parser actions might lead to an incorrect
       destructor call or verbose syntax error message before the
       lookahead is translated.  */
    YY_SYMBOL_PRINT ("-> $$ =", yyr1_[yyn], &yyval, &yyloc);

    yypop_ (yylen);
    yylen = 0;
    YY_STACK_PRINT ();

    yysemantic_stack_.push (yyval);
    yylocation_stack_.push (yyloc);

    /* Shift the result of the reduction.  */
    yyn = yyr1_[yyn];
    yystate = yypgoto_[yyn - yyntokens_] + yystate_stack_[0];
    if (0 <= yystate && yystate <= yylast_
	&& yycheck_[yystate] == yystate_stack_[0])
      yystate = yytable_[yystate];
    else
      yystate = yydefgoto_[yyn - yyntokens_];
    goto yynewstate;

  /*------------------------------------.
  | yyerrlab -- here on detecting error |
  `------------------------------------*/
  yyerrlab:
    /* Make sure we have latest lookahead translation.  See comments at
       user semantic actions for why this is necessary.  */
    yytoken = yytranslate_ (yychar);

    /* If not already recovering from an error, report this error.  */
    if (!yyerrstatus_)
      {
	++yynerrs_;
	if (yychar == yyempty_)
	  yytoken = yyempty_;
	error (yylloc, yysyntax_error_ (yystate, yytoken));
      }

    yyerror_range[1] = yylloc;
    if (yyerrstatus_ == 3)
      {
	/* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

	if (yychar <= yyeof_)
	  {
	  /* Return failure if at end of input.  */
	  if (yychar == yyeof_)
	    YYABORT;
	  }
	else
	  {
	    yydestruct_ ("Error: discarding", yytoken, &yylval, &yylloc);
	    yychar = yyempty_;
	  }
      }

    /* Else will try to reuse lookahead token after shifting the error
       token.  */
    goto yyerrlab1;


  /*---------------------------------------------------.
  | yyerrorlab -- error raised explicitly by YYERROR.  |
  `---------------------------------------------------*/
  yyerrorlab:

    /* Pacify compilers like GCC when the user code never invokes
       YYERROR and the label yyerrorlab therefore never appears in user
       code.  */
    if (false)
      goto yyerrorlab;

    yyerror_range[1] = yylocation_stack_[yylen - 1];
    /* Do not reclaim the symbols of the rule which action triggered
       this YYERROR.  */
    yypop_ (yylen);
    yylen = 0;
    yystate = yystate_stack_[0];
    goto yyerrlab1;

  /*-------------------------------------------------------------.
  | yyerrlab1 -- common code for both syntax error and YYERROR.  |
  `-------------------------------------------------------------*/
  yyerrlab1:
    yyerrstatus_ = 3;	/* Each real token shifted decrements this.  */

    for (;;)
      {
	yyn = yypact_[yystate];
	if (!yy_pact_value_is_default_ (yyn))
	{
	  yyn += yyterror_;
	  if (0 <= yyn && yyn <= yylast_ && yycheck_[yyn] == yyterror_)
	    {
	      yyn = yytable_[yyn];
	      if (0 < yyn)
		break;
	    }
	}

	/* Pop the current state because it cannot handle the error token.  */
	if (yystate_stack_.height () == 1)
	YYABORT;

	yyerror_range[1] = yylocation_stack_[0];
	yydestruct_ ("Error: popping",
		     yystos_[yystate],
		     &yysemantic_stack_[0], &yylocation_stack_[0]);
	yypop_ ();
	yystate = yystate_stack_[0];
	YY_STACK_PRINT ();
      }

    yyerror_range[2] = yylloc;
    // Using YYLLOC is tempting, but would change the location of
    // the lookahead.  YYLOC is available though.
    YYLLOC_DEFAULT (yyloc, yyerror_range, 2);
    yysemantic_stack_.push (yylval);
    yylocation_stack_.push (yyloc);

    /* Shift the error token.  */
    YY_SYMBOL_PRINT ("Shifting", yystos_[yyn],
		     &yysemantic_stack_[0], &yylocation_stack_[0]);

    yystate = yyn;
    goto yynewstate;

    /* Accept.  */
  yyacceptlab:
    yyresult = 0;
    goto yyreturn;

    /* Abort.  */
  yyabortlab:
    yyresult = 1;
    goto yyreturn;

  yyreturn:
    if (yychar != yyempty_)
      {
        /* Make sure we have latest lookahead translation.  See comments
           at user semantic actions for why this is necessary.  */
        yytoken = yytranslate_ (yychar);
        yydestruct_ ("Cleanup: discarding lookahead", yytoken, &yylval,
                     &yylloc);
      }

    /* Do not reclaim the symbols of the rule which action triggered
       this YYABORT or YYACCEPT.  */
    yypop_ (yylen);
    while (yystate_stack_.height () != 1)
      {
	yydestruct_ ("Cleanup: popping",
		   yystos_[yystate_stack_[0]],
		   &yysemantic_stack_[0],
		   &yylocation_stack_[0]);
	yypop_ ();
      }

    return yyresult;
  }

  // Generate an error message.
  std::string
  ctl_parser::yysyntax_error_ (int yystate, int yytoken)
  {
    std::string yyres;
    // Number of reported tokens (one for the "unexpected", one per
    // "expected").
    size_t yycount = 0;
    // Its maximum.
    enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
    // Arguments of yyformat.
    char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];

    /* There are many possibilities here to consider:
       - If this state is a consistent state with a default action, then
         the only way this function was invoked is if the default action
         is an error action.  In that case, don't check for expected
         tokens because there are none.
       - The only way there can be no lookahead present (in yytoken) is
         if this state is a consistent state with a default action.
         Thus, detecting the absence of a lookahead is sufficient to
         determine that there is no unexpected or expected token to
         report.  In that case, just report a simple "syntax error".
       - Don't assume there isn't a lookahead just because this state is
         a consistent state with a default action.  There might have
         been a previous inconsistent state, consistent state with a
         non-default action, or user semantic action that manipulated
         yychar.
       - Of course, the expected token list depends on states to have
         correct lookahead information, and it depends on the parser not
         to perform extra reductions after fetching a lookahead from the
         scanner and before detecting a syntax error.  Thus, state
         merging (from LALR or IELR) and default reductions corrupt the
         expected token list.  However, the list is correct for
         canonical LR with one exception: it will still contain any
         token that will not be accepted due to an error action in a
         later state.
    */
    if (yytoken != yyempty_)
      {
        yyarg[yycount++] = yytname_[yytoken];
        int yyn = yypact_[yystate];
        if (!yy_pact_value_is_default_ (yyn))
          {
            /* Start YYX at -YYN if negative to avoid negative indexes in
               YYCHECK.  In other words, skip the first -YYN actions for
               this state because they are default actions.  */
            int yyxbegin = yyn < 0 ? -yyn : 0;
            /* Stay within bounds of both yycheck and yytname.  */
            int yychecklim = yylast_ - yyn + 1;
            int yyxend = yychecklim < yyntokens_ ? yychecklim : yyntokens_;
            for (int yyx = yyxbegin; yyx < yyxend; ++yyx)
              if (yycheck_[yyx + yyn] == yyx && yyx != yyterror_
                  && !yy_table_value_is_error_ (yytable_[yyx + yyn]))
                {
                  if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                    {
                      yycount = 1;
                      break;
                    }
                  else
                    yyarg[yycount++] = yytname_[yyx];
                }
          }
      }

    char const* yyformat = 0;
    switch (yycount)
      {
#define YYCASE_(N, S)                         \
        case N:                               \
          yyformat = S;                       \
        break
        YYCASE_(0, YY_("syntax error"));
        YYCASE_(1, YY_("syntax error, unexpected %s"));
        YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
        YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
        YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
        YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
#undef YYCASE_
      }

    // Argument number.
    size_t yyi = 0;
    for (char const* yyp = yyformat; *yyp; ++yyp)
      if (yyp[0] == '%' && yyp[1] == 's' && yyi < yycount)
        {
          yyres += yytnamerr_ (yyarg[yyi++]);
          ++yyp;
        }
      else
        yyres += *yyp;
    return yyres;
  }


  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
  const signed char ctl_parser::yypact_ninf_ = -8;
  const signed char
  ctl_parser::yypact_[] =
  {
        -8,    34,    -8,    -8,    -8,    -8,    -8,    55,    55,    55,
      55,    55,    55,    55,    55,    55,    55,    55,    96,    -8,
      -8,    78,    87,    -8,    -8,    -8,    -8,    -8,    -8,     9,
      55,    55,    55,    55,    55,    55,    55,    55,    55,    55,
      55,    -8,     4,     4,     4,     0,    -8,    -8,    -8,    -8,
      -8,    -8,    -8
  };

  /* YYDEFACT[S] -- default reduction number in state S.  Performed when
     YYTABLE doesn't specify something else to do.  Zero means the
     default is an error.  */
  const unsigned char
  ctl_parser::yydefact_[] =
  {
         2,     0,     1,     5,     6,    27,    26,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     3,    24,
      25,     0,     0,    15,    14,    13,     9,     8,     7,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     4,    22,    23,    21,    19,    20,    18,    17,    16,
      12,    11,    10
  };

  /* YYPGOTO[NTERM-NUM].  */
  const signed char
  ctl_parser::yypgoto_[] =
  {
        -8,    -8,    -7
  };

  /* YYDEFGOTO[NTERM-NUM].  */
  const signed char
  ctl_parser::yydefgoto_[] =
  {
        -1,     1,    18
  };

  /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule which
     number is the opposite.  If YYTABLE_NINF_, syntax error.  */
  const signed char ctl_parser::yytable_ninf_ = -1;
  const unsigned char
  ctl_parser::yytable_[] =
  {
        19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    34,    30,    31,    33,    34,     0,     0,    32,    33,
      34,     0,     0,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,     2,    41,     0,     0,     0,     3,
       4,     5,     6,     0,     0,     0,     7,     8,     0,     0,
       0,     9,    10,    11,    12,    13,    14,    15,    16,    17,
       3,     4,     5,     6,     0,     0,     0,     7,     8,     0,
       0,     0,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    30,    31,     0,     0,     0,     0,    32,    33,    34,
      30,    31,    35,    36,    37,     0,    32,    33,    34,    30,
      31,    38,    39,    40,     0,    32,    33,    34
  };

  /* YYCHECK.  */
  const signed char
  ctl_parser::yycheck_[] =
  {
         7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    11,     3,     4,    10,    11,    -1,    -1,     9,    10,
      11,    -1,    -1,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,     0,    26,    -1,    -1,    -1,     5,
       6,     7,     8,    -1,    -1,    -1,    12,    13,    -1,    -1,
      -1,    17,    18,    19,    20,    21,    22,    23,    24,    25,
       5,     6,     7,     8,    -1,    -1,    -1,    12,    13,    -1,
      -1,    -1,    17,    18,    19,    20,    21,    22,    23,    24,
      25,     3,     4,    -1,    -1,    -1,    -1,     9,    10,    11,
       3,     4,    14,    15,    16,    -1,     9,    10,    11,     3,
       4,    14,    15,    16,    -1,     9,    10,    11
  };

  /* STOS_[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
  const unsigned char
  ctl_parser::yystos_[] =
  {
         0,    28,     0,     5,     6,     7,     8,    12,    13,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    29,    29,
      29,    29,    29,    29,    29,    29,    29,    29,    29,    29,
       3,     4,     9,    10,    11,    14,    15,    16,    14,    15,
      16,    26,    29,    29,    29,    29,    29,    29,    29,    29,
      29,    29,    29
  };

#if YYDEBUG
  /* TOKEN_NUMBER_[YYLEX-NUM] -- Internal symbol number corresponding
     to YYLEX-NUM.  */
  const unsigned short int
  ctl_parser::yytoken_number_[] =
  {
         0,   256,   257,   258,   259,   260,   261,   262,   263,    94,
     124,    38,   126,    33,   264,   265,   266,   267,   268,   269,
     270,   271,   272,   273,   274,    40,    41
  };
#endif

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
  const unsigned char
  ctl_parser::yyr1_[] =
  {
         0,    27,    28,    28,    29,    29,    29,    29,    29,    29,
      29,    29,    29,    29,    29,    29,    29,    29,    29,    29,
      29,    29,    29,    29,    29,    29,    29,    29
  };

  /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
  const unsigned char
  ctl_parser::yyr2_[] =
  {
         0,     2,     0,     2,     3,     1,     1,     2,     2,     2,
       4,     4,     4,     2,     2,     2,     4,     4,     4,     3,
       3,     3,     3,     3,     2,     2,     1,     1
  };

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
  /* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
     First, the terminals, then, starting at \a yyntokens_, nonterminals.  */
  const char*
  const ctl_parser::yytname_[] =
  {
    "\"end of file\"", "error", "$undefined", "\"==\"", "\"->\"", "TRUE",
  "FALSE", "INVALID_CHAR", "\"identifier\"", "'^'", "'|'", "'&'", "'~'",
  "'!'", "WEAK_UNTIL", "RELEASES", "UNTIL", "AQUANT", "EQUANT", "AG", "AF",
  "AX", "EG", "EF", "EX", "'('", "')'", "$accept", "input", "formula", 0
  };
#endif

#if YYDEBUG
  /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
  const ctl_parser::rhs_number_type
  ctl_parser::yyrhs_[] =
  {
        28,     0,    -1,    -1,    28,    29,    -1,    25,    29,    26,
      -1,     5,    -1,     6,    -1,    24,    29,    -1,    23,    29,
      -1,    22,    29,    -1,    18,    29,    16,    29,    -1,    18,
      29,    15,    29,    -1,    18,    29,    14,    29,    -1,    21,
      29,    -1,    20,    29,    -1,    19,    29,    -1,    17,    29,
      16,    29,    -1,    17,    29,    15,    29,    -1,    17,    29,
      14,    29,    -1,    29,    10,    29,    -1,    29,    11,    29,
      -1,    29,     9,    29,    -1,    29,     3,    29,    -1,    29,
       4,    29,    -1,    12,    29,    -1,    13,    29,    -1,     8,
      -1,     7,    -1
  };

  /* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
     YYRHS.  */
  const unsigned char
  ctl_parser::yyprhs_[] =
  {
         0,     0,     3,     4,     7,    11,    13,    15,    18,    21,
      24,    29,    34,    39,    42,    45,    48,    53,    58,    63,
      67,    71,    75,    79,    83,    86,    89,    91
  };

  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
  const unsigned char
  ctl_parser::yyrline_[] =
  {
         0,    52,    52,    53,    56,    57,    58,    59,    60,    61,
      62,    63,    70,    76,    79,    82,    85,    93,    97,   102,
     106,   107,   114,   121,   124,   125,   126,   134
  };

  // Print the state stack on the debug stream.
  void
  ctl_parser::yystack_print_ ()
  {
    *yycdebug_ << "Stack now";
    for (state_stack_type::const_iterator i = yystate_stack_.begin ();
	 i != yystate_stack_.end (); ++i)
      *yycdebug_ << ' ' << *i;
    *yycdebug_ << std::endl;
  }

  // Report on the debug stream that the rule \a yyrule is going to be reduced.
  void
  ctl_parser::yy_reduce_print_ (int yyrule)
  {
    unsigned int yylno = yyrline_[yyrule];
    int yynrhs = yyr2_[yyrule];
    /* Print the symbols being reduced, and their result.  */
    *yycdebug_ << "Reducing stack by rule " << yyrule - 1
	       << " (line " << yylno << "):" << std::endl;
    /* The symbols being reduced.  */
    for (int yyi = 0; yyi < yynrhs; yyi++)
      YY_SYMBOL_PRINT ("   $" << yyi + 1 << " =",
		       yyrhs_[yyprhs_[yyrule] + yyi],
		       &(yysemantic_stack_[(yynrhs) - (yyi + 1)]),
		       &(yylocation_stack_[(yynrhs) - (yyi + 1)]));
  }
#endif // YYDEBUG

  /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
  ctl_parser::token_number_type
  ctl_parser::yytranslate_ (int t)
  {
    static
    const token_number_type
    translate_table[] =
    {
           0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    13,     2,     2,     2,     2,    11,     2,
      25,    26,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     9,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    10,     2,    12,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,    14,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24
    };
    if ((unsigned int) t <= yyuser_token_number_max_)
      return translate_table[t];
    else
      return yyundef_token_;
  }

  const int ctl_parser::yyeof_ = 0;
  const int ctl_parser::yylast_ = 107;
  const int ctl_parser::yynnts_ = 3;
  const int ctl_parser::yyempty_ = -2;
  const int ctl_parser::yyfinal_ = 2;
  const int ctl_parser::yyterror_ = 1;
  const int ctl_parser::yyerrcode_ = 256;
  const int ctl_parser::yyntokens_ = 27;

  const unsigned int ctl_parser::yyuser_token_number_max_ = 274;
  const ctl_parser::token_number_type ctl_parser::yyundef_token_ = 2;


} // yy

/* Line 1136 of lalr1.cc  */
#line 1246 "src/properties/PropCtlParser.cc"


/* Line 1138 of lalr1.cc  */
#line 135 "../iimc/src/properties/PropCtlParser.yy"


void
yy::ctl_parser::error(const yy::ctl_parser::location_type& l,
                      const std::string& m)
{
  driver.error(l, m);
}

