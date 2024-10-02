dnl Copyright (C) 2024 Ildar Rechapov <ildar.rch@gmail.com>
dnl This code is public domain and can be freely used or copied.

dnl Macro that checks for a C compiler flag availability
dnl
dnl _RDKAFKA_CHECK_C_COMPILER_FLAG(FLAGS)
dnl AC_SUBST : RDKAFKA_CFLAGS_WARN
dnl have_flag: yes or no.
AC_DEFUN(
    [_RDKAFKA_CHECK_C_COMPILER_FLAG],
    [dnl

        dnl store in options -Wfoo if -Wno-foo is passed
        option="m4_bpatsubst([[$1]], [-Wno-], [-W])"
        CFLAGS_save="${CFLAGS}"
        CFLAGS="${CFLAGS} ${option}"
        AC_LANG_PUSH([C])
        
        AC_MSG_CHECKING([whether the C compiler supports $1])
        AC_COMPILE_IFELSE(
        [AC_LANG_PROGRAM([[]])],
        [have_flag="yes"],
        [have_flag="no"])
        AC_MSG_RESULT([${have_flag}])
        
        AC_LANG_POP([C])
        CFLAGS="${CFLAGS_save}"
        
        AS_IF(
            [test "x${have_flag}" = "xyes"],
            [RDKAFKA_CFLAGS_WARN="${RDKAFKA_CFLAGS_WARN} [$1]"]
        )
        
        AC_SUBST(RDKAFKA_CFLAGS_WARN)dnl
    ]
)

dnl
dnl Let's check if FLAGS are available and add them to RDKAFKA_CFLAGS
dnl

AC_DEFUN(
    [RDKAFKA_CHECK_C_COMPILER_FLAGS],
    [
        _RDKAFKA_CHECK_C_COMPILER_FLAG([$1])

        AS_IF(
            [test "${have_flag}" != "yes"],
            [
                m4_foreach_w(
                    [flag],
                    [$1],
                    [_RDKAFKA_CHECK_C_COMPILER_FLAG(m4_defn([flag]))]
                )
            ]
        )
    ]
)
