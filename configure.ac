AC_INIT([lect],[0.1],[benjaminsutter@outlook.com])
AM_INIT_AUTOMAKE([gnu -Wall -Werror])
AC_PROG_CC
AC_PROG_LEX([noyywrap])
AC_PROG_YACC
AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.21])
AC_CHECK_FUNCS([asprintf strdup])
AX_CHECK_COMPILE_FLAG([-std=gnu11], [
    CFLAGS+=" -std=gnu11"
], [
   echo "C compiler cannot compile C11 code."
   exit -1
])
AC_CONFIG_SRCDIR([lic/lic.c])
AC_CONFIG_FILES([README lic/Makefile Makefile doc/Makefile po/Makefile.in])
AC_CONFIG_HEADERS([config.h])
AC_OUTPUT
