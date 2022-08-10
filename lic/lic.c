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

#include <stdio.h>
#include <locale.h>
#include <gettext.h>
#include <config.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include "parse.h"
#define _(String) gettext(String)

char *input_filename;
char *output_filename;
int parse_opts (int argc, char *argv[]);
void cleanup ();
extern void yyerror (char const *);

int
main (int argc, char *argv[])
{
  setlocale (LC_ALL, "");
  bindtextdomain (PACKAGE, LOCALEDIR);
  textdomain (PACKAGE);
  int err = parse_opts (argc, argv);
  switch (err)
    {
    case -1:
      cleanup ();
      return err;
    case 1:
      cleanup ();
      return 0;
    case 0:
      break;
    }
  printf (_("input: %s\noutput: %s\n"), input_filename, output_filename);

  cleanup ();
}

// performs argument processing
// returns 0 on normal success, 1 on short success, and -1 on error
int
parse_opts (int argc, char *argv[])
{
  int c;

  while (1)
    {
      static struct option long_options[] =
        {
          {"help",     no_argument,       0, 'h'},
          {"version",  no_argument,       0, 'v'},
          {"output",   required_argument, 0, 'o'},
	  {}
        };
      int option_index = 0;
      c = getopt_long (argc, argv, "hvo:",
                       long_options, &option_index);

      if (c == -1)
        break;

      switch (c)
        {
	case 'h':
          printf (_("lic [options] file\n"
		    "    --help, -h        Print this help message.\n"
		    "    --version, -v     Print the program version.\n"
		    "    --output, -o      Specify output filename.\n"
		    "Report bugs to: https://github.com/bms-1984/lect/issues\n"
		    "Lect home page: https://github.com/bms-1984/lect\n"));
          return 1;

        case 'v':
          printf ("%s\n", PACKAGE_STRING);
	  printf (_("Copyright (C) 2022 Ben M. Sutter\n"
		    "License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>\n"
		    "This is free software: you are free to change and redistribute it.\n"
		    "There is NO WARRANTY, to the extent permitted by law.\n"));
          return 1;

        case 'o':
	  output_filename = strdup (optarg);
          break;

        case '?':
          break;

        default:
          return -1;
        }
    }

  if (optind < argc)
    {
      input_filename = strdup (argv[optind]);
      if (output_filename == NULL)
	asprintf (&output_filename, "%s.out", input_filename);
    }
  else
    {
      yyerror (_("no input file specified"));
      return -1;
    }

  return 0;
}

void
cleanup ()
{
  if (output_filename != NULL) free (output_filename);
  if (input_filename != NULL)  free (input_filename);
}
