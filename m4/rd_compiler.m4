###Copyright (C) 2024 Ildar Rechapov <ildar.rch@gmail.com>
###This code is public domain and can be freely used or copied.

###
### Let's check for a C compiler flag availability
###

AC_DEFUN(
    [
        _RDKAFKA_CHECK_C_COMPILER_FLAG
    ],
    [
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

###
### Let's check if FLAGS are available and add them to RDKAFKA_CFLAGS
###

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
])
