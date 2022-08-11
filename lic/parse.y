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
  #include <stdio.h>
  #include <gettext.h>
  
  #define _(String) gettext(String)
  
  extern int yylex ();
  void yyerror (char const *);
%}

%define parse.error detailed
%define parse.lac full
%define parse.trace

%union value {
  double d;
  long long i;
  char* s;
}

%token <s> TOK_ID _("identifier")
%token <i> TOK_INTEGER _("integer")
%token <d> TOK_DOUBLE _("double")

%left '-' '+'
%left '*' '/'

%%
program:
  line program |
  line         ;

line:
  expr               |
  error { yyerrok; } ;

expr:
  expr '+' expr |
  expr '-' expr |
  expr '/' expr |
  expr '*' expr |
  TOK_ID                  { printf ("%s\n", $1); }   |
  TOK_INTEGER             { printf ("%lld\n", $1); } |
  TOK_DOUBLE              { printf ("%f\n", $1); }   ;
   
%% 

void yyerror (char const *s)
{
  fprintf (stderr, _("error: %s\n"), s);
}


