BUILT_SOURCES = parse.h
AM_YFLAGS = -d -Wall -Wno-yacc -Wcounterexamples
bin_PROGRAMS = lic
lic_CPPFLAGS = -I@top_srcdir@/lib -DLOCALEDIR=\"@localedir@\" -D_GNU_SOURCE
lic_SOURCES = parse.y scan.l lic.c ../lib/gettext.h
lic_LDADD = @LIBINTL@
