{
open Parser
}

rule verilog  =      parse       
      "module"                                       { KEY_MODULE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)               }
      | "endmodule"                                  { KEY_ENDMODULE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)            }
      | "input"                                      { KEY_INPUT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "output"                                     { KEY_OUTPUT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)               }
      | "inout"                                      { KEY_INOUT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "small"                                      { KEY_SMALL(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "medium"                                     { KEY_MEDIUM(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)               }
      | "large"                                      { KEY_LARGE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "scalared"                                   { KEY_SCALARED(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)             }
      | "vectored"                                   { KEY_VECTORED(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)             }
      | "assign"                                     { KEY_ASSIGN(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)               }
      | "reg"                                        { KEY_REG(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "always"                                     { KEY_ALWAYS(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)               }
      | "if"                                         { KEY_IF(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | "else"                                       { KEY_ELSE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "case"                                       { KEY_CASE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "casex"                                      { KEY_CASEX(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "casez"                                      { KEY_CASEZ(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "endcase"                                    { KEY_ENDCASE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "disable"                                    { KEY_DISABLE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "force"                                      { KEY_FORCE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "release"                                    { KEY_RELEASE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "default"                                    { KEY_DEFAULT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "forever"                                    { KEY_FOREVER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "repeat"                                     { KEY_REPEAT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)               }
      | "while"                                      { KEY_WHILE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "for"                                        { KEY_FOR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "wait"                                       { KEY_WAIT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "begin"                                      { KEY_BEGIN(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "end"                                        { KEY_END(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "fork"                                       { KEY_FORK(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "join"                                       { KEY_JOIN(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "parameter"                                  { KEY_PARAMETER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)            }
      | "integer"                                    { KEY_INTEGER(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "real"                                       { KEY_REAL(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "time"                                       { KEY_TIME(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "event"                                      { KEY_EVENT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "edge"                                       { KEY_EDGE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "posedge"                                    { KEY_POSEDGE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "negedge"                                    { KEY_NEGEDGE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "or"                                         { KEY_OR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | "defparam"                                   { KEY_DEFPARAM(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)             }
      | "specify"                                    { KEY_SPECIFY(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "endspecify"                                 { KEY_ENDSPECIFY(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)           }
      | "initial"                                    { KEY_INITIAL(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "task"                                       { KEY_TASK(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "endtask"                                    { KEY_ENDTASK(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "function"                                   { KEY_FUNCTION(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)             }
      | "endfunction"                                { KEY_ENDFUNCTION(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)          }
      | "specparam"                                  { KEY_SPECPARAM(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)            }
      | "and"					{ GATETYPE("and")	}
      | "nand"					{ GATETYPE("nand")	}
      | "or"					{ GATETYPE("or")	}
      | "nor"					{ GATETYPE("nor")	}
      | "xor"					{ GATETYPE("xor")	}
      | "xnor"					{ GATETYPE("xnor")	}
      | "buf"					{ GATETYPE("buf")	}
      | "bufif0"				{ GATETYPE("bufif0")	}
      | "bufif1"				{ GATETYPE("bufif1")	}
      | "not"					{ GATETYPE("not")	}
      | "notif0"				{ GATETYPE("notif0")	}
      | "notif1"				{ GATETYPE("notif1")	}
      | "pulldown"				{ GATETYPE("pulldown")	}
      | "pullup"				{ GATETYPE("pullup")	}
      | "nmos"					{ GATETYPE("nmos")	}
      | "rnmos"					{ GATETYPE("rnmos")	}
      | "pmos"					{ GATETYPE("pmos")	}
      | "rpmos"					{ GATETYPE("rpmos")	}
      | "cmos"					{ GATETYPE("cmos")	}
      | "rcmos"					{ GATETYPE("rcmos")	}
      | "tran"					{ GATETYPE("tran")	}
      | "rtran"					{ GATETYPE("rtran")	}
      | "tranif0"				{ GATETYPE("tranif0")	}
      | "rtranif0"				{ GATETYPE("rtranif0")	}
      | "tranif1"				{ GATETYPE("tranif1")	}
      | "rtranif1"				{ GATETYPE("rtranif1")	}
      | "wire"                                       { NETTYPE("wire")          }
      | "tri"                                        { NETTYPE("tri")           }
      | "tri1"                                       { NETTYPE("tri1")          }
      | "supply0"                                    { NETTYPE("supply0")       }
      | "wand"                                       { NETTYPE("wand")          }
      | "triand"                                     { NETTYPE("triand")        }
      | "tri0"                                       { NETTYPE("tri0")          }
      | "supply1"                                    { NETTYPE("supply1")       }
      | "wor"                                        { NETTYPE("wor")           }
      | "trior"                                      { NETTYPE("trior")         }
      | "trireg"                                     { NETTYPE("trireg")        }
      | "supply0"                                    { STRENGTH0("supply0")     }
      | "strong0"                                    { STRENGTH0("strong0")     }
      | "pull0"                                      { STRENGTH0("pull0")       }
      | "weak0"                                      { STRENGTH0("weak0")       }
      | "highz0"                                     { STRENGTH0("highz0")      }
      | "supply1"                                    { STRENGTH1("supply1")     }
      | "strong1"                                    { STRENGTH1("strong1")     }
      | "pull1"                                      { STRENGTH1("pull1")       }
      | "weak1"                                      { STRENGTH1("weak1")       }
      | "highz1"                                     { STRENGTH1("highz1")      }
      | "$setup"                                     { DOLLOR_SETUP             }
      | "$hold"                                      { DOLLOR_HOLD              }
      | "$period"                                    { DOLLOR_PERIOD            }
      | "$width"                                     { DOLLOR_WIDTH             }
      | "$skew"                                      { DOLLOR_SKEW              }
      | "$recovery"                                  { DOLLOR_RECOVERY          }
      | "$setuphold"                                 { DOLLOR_SETUPHOLD         }
      | "$bitstoreal"		{ DOLLOR_SYSTEM_IDENTIFIER("$bitstoreal")	}
      | "$countdrivers"		{ DOLLOR_SYSTEM_IDENTIFIER("$countdrivers")	}
      | "$display"		{ DOLLOR_SYSTEM_IDENTIFIER("$display")		}
      | "$fclose"		{ DOLLOR_SYSTEM_IDENTIFIER("$fclose")		}
      | "$fdisplay"		{ DOLLOR_SYSTEM_IDENTIFIER("$fdisplay")		}
      | "$fmonitor"		{ DOLLOR_SYSTEM_IDENTIFIER("$fmonitor")		}
      | "$fopen"		{ DOLLOR_SYSTEM_IDENTIFIER("$fopen")		}
      | "$fstrobe"		{ DOLLOR_SYSTEM_IDENTIFIER("$fstrobe")		}
      | "$fwrite"		{ DOLLOR_SYSTEM_IDENTIFIER("$fwrite")		}
      | "$finish"		{ DOLLOR_SYSTEM_IDENTIFIER("$finish")		}
      | "$getpattern"		{ DOLLOR_SYSTEM_IDENTIFIER("$getpattern")	}
      | "$history"		{ DOLLOR_SYSTEM_IDENTIFIER("$history")		}
      | "$incsave"		{ DOLLOR_SYSTEM_IDENTIFIER("$incsave")		}
      | "$input"		{ DOLLOR_SYSTEM_IDENTIFIER("$input")		}
      | "$itor"			{ DOLLOR_SYSTEM_IDENTIFIER("$itor")		}
      | "$key"			{ DOLLOR_SYSTEM_IDENTIFIER("$key")		}
      | "$list"			{ DOLLOR_SYSTEM_IDENTIFIER("$list")		}
      | "$log"			{ DOLLOR_SYSTEM_IDENTIFIER("$log")		}
      | "$monitor"		{ DOLLOR_SYSTEM_IDENTIFIER("$monitor")		}
      | "$monitoroff"		{ DOLLOR_SYSTEM_IDENTIFIER("$monitoroff")	}
      | "$monitoron"		{ DOLLOR_SYSTEM_IDENTIFIER("$monitoron")	}
      | "$nokey"		{ DOLLOR_SYSTEM_IDENTIFIER("$nokey")		}
      | "$nolog"		{ DOLLOR_SYSTEM_IDENTIFIER("$nolog")		}
      | "$printtimescale"	{ DOLLOR_SYSTEM_IDENTIFIER("$printtimescale")	}
      | "$readmemb"		{ DOLLOR_SYSTEM_IDENTIFIER("$readmemb")		}
      | "$readmemh"		{ DOLLOR_SYSTEM_IDENTIFIER("$readmemh")		}
      | "$realtime"		{ DOLLOR_SYSTEM_IDENTIFIER("$realtime")		}
      | "$realtobits"		{ DOLLOR_SYSTEM_IDENTIFIER("$realtobits")	}
      | "$reset"		{ DOLLOR_SYSTEM_IDENTIFIER("$reset")		}
      | "$reset_count"		{ DOLLOR_SYSTEM_IDENTIFIER("$reset_count")	}
      | "$reset_value"		{ DOLLOR_SYSTEM_IDENTIFIER("$reset_value")	}
      | "$restart"		{ DOLLOR_SYSTEM_IDENTIFIER("$restart")		}
      | "$rtoi"			{ DOLLOR_SYSTEM_IDENTIFIER("$rtoi")		}
      | "$save"			{ DOLLOR_SYSTEM_IDENTIFIER("$save")		}
      | "$scale"		{ DOLLOR_SYSTEM_IDENTIFIER("$scale")		}
      | "$scope"		{ DOLLOR_SYSTEM_IDENTIFIER("$scope")		}
      | "$showscopes"		{ DOLLOR_SYSTEM_IDENTIFIER("$showscopes")	}
      | "$showvariables"	{ DOLLOR_SYSTEM_IDENTIFIER("$showvariables")	}
      | "$showvars"		{ DOLLOR_SYSTEM_IDENTIFIER("$showvars")		}
      | "$sreadmemb"		{ DOLLOR_SYSTEM_IDENTIFIER("$sreadmemb")	}
      | "$sreadmemh"		{ DOLLOR_SYSTEM_IDENTIFIER("$sreadmemh")	}
      | "$stime"		{ DOLLOR_SYSTEM_IDENTIFIER("$stime")		}
      | "$stop"			{ DOLLOR_SYSTEM_IDENTIFIER("$stop")		}
      | "$strobe"		{ DOLLOR_SYSTEM_IDENTIFIER("$strobe")		}
      | "$time"			{ DOLLOR_SYSTEM_IDENTIFIER("$time")		}
      | "$timeformat"		{ DOLLOR_SYSTEM_IDENTIFIER("$timeformat")	}
      | "$write"		{ DOLLOR_SYSTEM_IDENTIFIER("$write")		}
      | "`accelerate"					{ endline lexbuf }
      | "`autoexpand_vectornets"			{ endline lexbuf }
      | "`celldefine"					{ endline lexbuf }
      | "`default_nettype"				{ endline lexbuf }
      | "`endcelldefine"				{ endline lexbuf }
      | "`endprotect"					{ endline lexbuf }
      | "`endprotected"					{ endline lexbuf }
      | "`expand_vectornets"				{ endline lexbuf }
      | "`noaccelerate"					{ endline lexbuf }
      | "`noexpand_vectornets"				{ endline lexbuf }
      | "`noremove_gatenames"				{ endline lexbuf }
      | "`noremove_netnames"				{ endline lexbuf }
      | "`nounconnected_drive"				{ endline lexbuf }
      | "`protect"					{ endline lexbuf }
      | "`protected"					{ endline lexbuf }
      | "`remove_gatenames"				{ endline lexbuf }
      | "`remove_netnames"				{ endline lexbuf }
      | "`resetall"					{ endline lexbuf }
      | "`timescale"					{ endline lexbuf }
      | "`unconnected_drive"				{ endline lexbuf }
      | "+"                                          { ADD(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                      }
      | "-"                                          { SUB(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                      }
      | "*"                                          { MUL(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                      }
      | "/"                                          { DIV(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                      }
      | "%"                                          { MOD(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                      }
      | ">"                                          { GT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                       }
      | ">="                                         { GE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                       }
      | "<"                                          { LT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                       }
      | "<="                                         { LE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                       }
      | "!"                                          { LOGIC_NEG(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "&&"                                         { LOGIC_AND(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "||"                                         { LOGIC_OR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "=="                                         { LOGIC_EQU(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "!="                                         { LOGIC_INE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | "==="                                        { CASE_EQU(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "!=="                                        { CASE_INE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "~"                                          { BIT_NEG(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "&"                                          { BIT_AND(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "|"                                          { BIT_OR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | "^"                                          { BIT_XOR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "^~"                                         { BIT_EQU(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "~^"                                         { BIT_EQU(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "~&"                                         { RED_NAND(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | "~|"                                         { RED_NOR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                  }
      | "<<"                                         { LEFT_SHIFT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)               }
      | ">>"                                         { RIGHT_SHIFT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)              }
      | "?"                                          { QUESTION_MARK(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)            }
      | "->"                                         { LEADTO(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | '{'                                          { LBRACE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | '}'                                          { RBRACE(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | '['                                          { LBRACKET(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | ']'                                          { RBRACKET(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                 }
      | '('                                          { LPAREN(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | ')'                                          { RPAREN(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | ','                                          { COMMA(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                    }
      | ';'                                          { SEMICOLON(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                }
      | ':'                                          { COLON(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                    }
      | '.'					     { DOT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                      }
      | '#'					     { JING(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                     }
      | '@'					     { AT(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                       }
      | '$'					     { DOLLOR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | '='					     { SINGLEASSIGN(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)             }
      | "=>"					     { PATHTO(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                   }
      | "*>"					     { PATHTOSTAR(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)               }
      | "?:"					     { QUESTION_MARK_COLON(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)      }
      | "&&&"                                        { AND3(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                     }
      | '\n'	{
			lexbuf.Lexing.lex_curr_p <- 
				{
					Lexing.pos_fname=lexbuf.Lexing.lex_curr_p.Lexing.pos_fname ;
					Lexing.pos_lnum=lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum+1 ;
					Lexing.pos_bol=lexbuf.Lexing.lex_curr_p.Lexing.pos_cnum ;
					Lexing.pos_cnum=lexbuf.Lexing.lex_curr_p.Lexing.pos_cnum 
				};
			verilog lexbuf
		}
      | [' ' '\t']                                   { verilog lexbuf           }
      | ['+' '-']?['0'-'9' '_']+(['.']['0'-'9' '_']+)?['E' 'e']['+' '-']?['0'-'9' '_']+ as lxm                                   
                                                     { FLOAT_NUMBER(lxm)        }
      | ['A'-'Z' 'a'-'z' '_' ]['A'-'Z' 'a'-'z' '_' '0'-'9']*  as idstr
                                                     { IDENTIFIER(idstr)        }
      | '\\'[^ ' ' '\t' '\n' ]*[' ' '\t' '\n' ]  as idstr
                                                     { IDENTIFIER(idstr)        }
      | '"'[^ '"' '\n'  ] '"'  as str
                                                     { STRING(str)              }
      | ['0'-'9' '_']+ as lxm                        { UNSIGNED_NUMBER(lxm)     }
      | ['0'-'9' '_']*'\''['b' 'B' 'o' 'O' 'd' 'D' 'h' 'H' ]['A'-'Z' 'a'-'z' '_' '0'-'9' '?']+ as lxm                        
                                                     { BASE_NUMBER(lxm)         }
      | "//"                                         { endline lexbuf           }
      | "/*"                                         { comment 1 lexbuf         }
      | eof                                          { EOF(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                      }
      | _ as c                                       
      		{ 
			let pos = Lexing.lexeme_end_p lexbuf
			in
			let fn = pos.Lexing.pos_fname
			and ln = (pos.Lexing.pos_lnum) + 1
			and cn = pos.Lexing.pos_cnum-pos.Lexing.pos_bol
			in
			Printf.printf "fatal error : unrecognized char %c in file %s line %d char %d " c fn ln cn
			;
			exit 1
		}
and endline = parse
      '\n'	{
			lexbuf.Lexing.lex_curr_p <- 
				{
					Lexing.pos_fname=lexbuf.Lexing.lex_curr_p.Lexing.pos_fname ;
					Lexing.pos_lnum=lexbuf.Lexing.lex_curr_p.Lexing.pos_lnum+1 ;
					Lexing.pos_bol=lexbuf.Lexing.lex_curr_p.Lexing.pos_cnum ;
					Lexing.pos_cnum=lexbuf.Lexing.lex_curr_p.Lexing.pos_cnum 
				};
			verilog lexbuf
		}
      | [' ' '\t']                                   { endline lexbuf           }
      | eof                                          { EOF(Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf)                      }
      | _                                            { endline lexbuf           }
and comment nest = parse 
      "/*"                                           { comment (nest+1) lexbuf  }
      | "*/"                                         { if (nest==1) then 
                                                          verilog lexbuf 
                                                       else  
                                                          comment (nest-1) lexbuf 
                                                     }
      | _                                            { comment nest   lexbuf    }
