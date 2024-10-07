dnl ######################################################################
dnl OpenSSL support
AC_DEFUN([RDKAFKA_OPENSSL], [
if test "x$OPT_SSL" != xno -a X"$OPT_SSL" != Xno; then
   dnl backup the pre-ssl variables
   LDFLAGS_SAVE="$LDFLAGS"
   CPPFLAGS_SAVE="$CPPFLAGS"
   LIBS_SAVE="$LIBS"

   case "$OPT_SSL" in
   yes)
      dnl --with-ssl (without path) used
      if test x$cross_compiling != xyes; then
         dnl only do pkg-config magic when not cross-compiling
         PKGTEST="yes"
      fi
      PREFIX_OPENSSL=/usr/local/ssl
      LIB_OPENSSL="$PREFIX_OPENSSL/lib$libsuff"
      ;;
   off)
      dnl no --with-ssl option given, just check default places
      if test x$cross_compiling != xyes; then
         dnl only do pkg-config magic when not cross-compiling
         PKGTEST="yes"
      fi
      PREFIX_OPENSSL=
      ;;
   *)
      dnl check the given --with-ssl spot
      PKGTEST="no"
      PREFIX_OPENSSL=$OPT_SSL

      dnl Try pkg-config even when cross-compiling.  Since we
      dnl specify PKG_CONFIG_LIBDIR we're only looking where
      dnl the user told us to look
      OPENSSL_PCDIR="$OPT_SSL/lib/pkgconfig"
      if test -f "$OPENSSL_PCDIR/openssl.pc"; then
         AC_MSG_NOTICE([PKG_CONFIG_LIBDIR will be set to "$OPENSSL_PCDIR"])
         PKGTEST="yes"
      elif test ! -f "$PREFIX_OPENSSL/include/openssl/ssl.h"; then
         AC_MSG_ERROR([$PREFIX_OPENSSL is a bad --with-ssl prefix!])
      fi

      dnl in case pkg-config comes up empty, use what we got
      dnl via --with-ssl
      LIB_OPENSSL="$PREFIX_OPENSSL/lib$libsuff"
      if test "$PREFIX_OPENSSL" != "/usr" ; then
         SSL_LDFLAGS="-L$LIB_OPENSSL"
         SSL_CPPFLAGS="-I$PREFIX_OPENSSL/include"
      fi
      SSL_CPPFLAGS="$SSL_CPPFLAGS -I$PREFIX_OPENSSL/include/openssl"
      ;;
   esac

   OPENSSL_INCS=$PREFIX_OPENSSL/include

   dnl finally, set flags to use SSL
   CPPFLAGS="$CPPFLAGS $SSL_CPPFLAGS"
   LDFLAGS="$LDFLAGS $SSL_LDFLAGS"

   AC_CHECK_HEADERS([openssl/ssl.h], [], [have_openssl=no])
   LDFLAGS="$LDFLAGS_SAVE"
   CPPFLAGS="$CPPFLAGS_SAVE"
   LIBS="$LIBS_SAVE"
   AC_SUBST(OPENSSL_INCS)
fi
])
