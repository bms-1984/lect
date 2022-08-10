/*
   Copyright (C) 2022 Ben M. Sutter

   This file is part of Lect.
  
   Lect is free software: you can redistribute it and/or modify it under the terms of the
   GNU General Public License as published by the Free Software Foundation, either
   version 3 of the License, or (at your option) any later version.
 
   Lect is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
   PARTICULAR PURPOSE. See the GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License along with Lect. If
   not, see <https://www.gnu.org/licenses/>. 
*/

%{
  #include <stdlib.h>
  #include <string.h>
  #include "parse.h"

  extern union value yylval; 
  extern void yyerror (char const *);
%}

%option noyywrap

IDENTIFIER          [a-zA-Z][a-zA-Z0-9_]*
COMMENT             "#"|"//"

%x doc_comment

%%

"\n"
[0-9]+"."[0-9]+     yylval.d = atof (yytext); return TOK_DOUBLE;
"0x"[0-9a-fA-F]+    yylval.i = strtoll (yytext, NULL, 16); return TOK_INTEGER;
"0b"[0-1]+          yylval.i = strtoll (yytext+2, NULL, 2); return TOK_INTEGER;
"0"[0-7]+           yylval.i = strtoll (yytext, NULL, 8); return TOK_INTEGER;
[0-9]+              yylval.i = strtoll (yytext, NULL, 10); return TOK_INTEGER;
{IDENTIFIER}        yylval.s = strdup (yytext); return TOK_ID;
{COMMENT}"*"        BEGIN doc_comment;
{COMMENT}           {
                      int c;
                      for (;;) {
                        while ((c = input()) != '\n');
                        if (c == EOF) {
                          yyerror ("EOF in comment");
                          break;
                        }
                        break;
                      }
                    }
