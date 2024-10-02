###Copyright (C) 2024 Ildar Rechapov <ildar.rch@gmail.com>
###This code is public domain and can be freely used or copied.

###
### Let's define the version and release information
###

m4_define([version_major], [2])
m4_define([version_minor], [5])
m4_define([version_micro], [3])
m4_define([version], [version_major.version_minor.version_micro])

m4_define([version_release], [])
m4_define([version_info_current], [m4_eval(version_major + version_minor)])
m4_define([version_info_revision], [version_micro])
m4_define([version_info_age], [version_minor])

version_info="version_info_current:version_info_revision:version_info_age"
release_info="version_release"

AC_SUBST([version_info])
AC_SUBST([release_info])

VMAJ=version_major
AC_SUBST([VMAJ])


###
### Prereqs
### TODO: can we omit m4 for now?
###

AC_PREREQ([2.69])
AC_INIT([librdkafka], [version], [librdkafka on confluent])
AC_CONFIG_SRCDIR([configure.ac])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIRS([m4])
### The following for librdkafka.pc.in
AC_SUBST([PROJECT_VERSION],[version])

###
### Let's configure some additional options
###

AC_ARG_ENABLE(
    [sanitize],
    [
        AS_HELP_STRING(
            [--enable-sanitize], [
                enable sanitize compiler option @<:@default=no@:>@
            ]
        )
    ],
    [
        AS_IF(
            [test "x${enableval}" = "xyes"],
            [enable_sanitize="yes"],
            [enable_sanitize="no"]
        )
    ],
    [enable_sanitize="no"]
)

AC_ARG_ENABLE(
    [wall],
    [
        AS_HELP_STRING(
            [--enable-wall],
            [enable -Wall and other options @<:@default=no@:>@]
        )
    ],
    [
        AS_IF(
            [test "x${enableval}" = "xyes"],
            [enable_wall="yes"],
            [enable_wall="no"]
        )
   ],
   [enable_wall="no"])

###
### Let's configure the default options with respect to host
### (linux support only)
###

AC_CANONICAL_HOST

###
### Let's check for programs
###

AM_PROG_AR

AM_INIT_AUTOMAKE([1.6 dist-xz subdir-objects])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

LT_INIT([disable-shared static])

AC_PROG_CC
AC_PROG_CXX
AC_PROG_CC_C_O

PKG_PROG_PKG_CONFIG

###
### TODO: Let's check for the requirements
###

###
### Let's avoid unnecessary warnings for now
###

AC_TYPE_UINTPTR_T
AC_TYPE_INTPTR_T
AC_TYPE_UINT32_T

###
### Let's check the compiler characteristics
###

AC_C_BIGENDIAN
AC_SUBST([LIBRDKAFKA_BIGENDIAN],[${ac_cv_c_bigendian}])
AC_ARG_VAR(
    [LIBRDKAFKA_BIGENDIAN],
    [big endian yes/no needed various places]
)

c_common_flags="-Wall -Wextra -Wpointer-arith -Wmissing-declarations -Wcomment -Wformat -Wpedantic -Wuninitialized -Wshadow -Werror -Wno-long-long"
AS_IF(
    [ test "x$enable_wall" = "xyes" ],
    [
       cxx_compiler_flags="$c_common_flags"
       c_compiler_flags="$c_common_flags -Wmissing-prototypes -Wdeclaration-after-statement -Wmissing-parameter-type -Wnested-externs -Wredundant-decls -Wsign-compare"
    ]
)
#-Wnull-dereference causes bogus warnings.
#-Wbad-function-cast removes useful warnings
#-Wnostringop-overread removes useful warnings
#-Wmissing-parameter-type removes useful warnings


###
### TODO: do we need this option?
###
RDKAFKA_CHECK_C_COMPILER_FLAGS([${c_compiler_flags}])

# If we can compile then the runtime can do the
# setlocal itself.
# We do not run this since the C compiler needs
# the C locale to compile correctly.
AC_COMPILE_IFELSE(
    [
        AC_LANG_PROGRAM(
            [[
                #include <langinfo.h>
                #include <locale.h>
                #include <string.h>
                #include <stdio.h>
            ]],
            [[
                char * langinfo = 0;

                setlocale(LC_CTYPE, "");
                setlocale(LC_NUMERIC, "");

                langinfo = nl_langinfo(CODESET);

                printf("Lang: %s\n",langinfo);
                if ( strcmp( langinfo,"UTF-8" ) && strcmp( langinfo,"UTF8" ) )
                {
                    return 1;
                }
            ]]
        )
    ],
    [     
        have_utf8="yes"
        AC_DEFINE(
            [HAVE_UTF8],
            [1],
            [Set to 1 as utf8 is fully printable]
        )
    ],
    [
        have_utf8="no"
        AC_MSG_WARN([utf8 printed uri-style])
    ]
)
AC_MSG_CHECKING([whether "utf-8" is available])
AC_MSG_RESULT([${have_utf8}])

# unused attribute
AC_COMPILE_IFELSE(
    [
        AC_LANG_PROGRAM(
            [[
                static unsigned int foo(unsigned int x, __attribute__ ((unused)) int y)
                {
                    unsigned int x2 = x + 1;
                    return x2;
                }

                int goo()
                {
                    unsigned int y = 0;
                    y = foo(12, y);
                }
            ]],
            [[]]
        )
    ],
    [
        have_unused="yes"
        AC_DEFINE(
            [HAVE_UNUSED_ATTRIBUTE],
            [1],
            [Set to 1 if __attribute__ ((unused)) is available.])
    ],
    [have_unused="no"]
)
AC_MSG_CHECKING([whether "unused" attribute is available])
AC_MSG_RESULT([${have_unused}])

# sanitize
AS_IF(
    [test "x${enable_sanitize}" = "xyes"],
    [
        CFLAGS_save=${CFLAGS}
        CFLAGS="${CFLAGS} -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-omit-frame-pointer"
        AC_COMPILE_IFELSE(
            [AC_LANG_PROGRAM([[]], [[]])],
            [
                enable_sanitize="yes"
                RDKAFKA_CFLAGS="$RDKAFKA_CFLAGS -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-omit-frame-pointer"
                LDFLAGS="$LDFLAGS -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-omit-frame-pointer"
            ],
            [enable_sanitize="no"]
        )

        CFLAGS="${CFLAGS_save} ${RDKAFKA_CFLAGS}"
    ])
AC_MSG_CHECKING([whether sanitize options are used])
AC_MSG_RESULT([${enable_sanitize}])

###
### TODO: Let's check for library functions
###

AC_FUNC_ALLOCA

###
### Checks for system services
###

AC_CONFIG_FILES(
    [
        Makefile
        src/Makefile
        librdkafka.pc
    ]
)

AC_OUTPUT


echo
echo "$PACKAGE $VERSION"
echo
echo "Configuration Options Summary:"
echo
echo "  BuildOS..............: ${build_os}"
echo "  HostOS...............: ${host_os}"
echo
echo "  sanitize support.....: ${enable_sanitize}"
echo "  BuildOS-BigEndian....: ${ac_cv_c_bigendian}"
echo
echo "  librdkafka.............: always"
echo "  librdkafka print utf-8: ${have_utf8}"
echo
echo "Compilation............: make (or gmake)"
echo "  CFLAGS...............: $CFLAGS ${c_compiler_flags}"
echo "  LDFLAGS..............: $LDFLAGS"
echo "  RDKAFKA_CFLAGS.......: $RDKAFKA_CFLAGS"
echo
echo "Installation...........: make install (as root if needed, with 'su' or 'sudo')"
echo "  prefix...............: $prefix"
echo
