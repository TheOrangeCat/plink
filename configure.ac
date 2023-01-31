# This is free software, licensed under the GNU Public License V2.
# See the file COPYING for details.

AC_INIT([plink],[0.12.6])
AC_CONFIG_SRCDIR([include/pi-version.h.in])
AC_CONFIG_MACRO_DIR([m4])

dnl Initialize maintainer mode
AM_MAINTAINER_MODE

dnl Run all of the sane intltool tests
dnl IT_PROG_INTLTOOL

AC_PREFIX_DEFAULT(/usr/local)

dnl ******************************
dnl Limit to a specific ac version
dnl ******************************
AC_PREREQ([2.71])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_HEADERS([include/pi-md5.h])

dnl ******************************
dnl Pilot Link Version
dnl ******************************
PILOT_LINK_VERS=0
PILOT_LINK_MAJOR=12
PILOT_LINK_MINOR=6
PILOT_LINK_PATCH=

AC_SUBST(PILOT_LINK_VERS)
AC_SUBST(PILOT_LINK_MAJOR)
AC_SUBST(PILOT_LINK_MINOR)
AC_SUBST(PILOT_LINK_PATCH)
#VERSION="$PILOT_LINK_VERS.$PILOT_LINK_MAJOR.$PILOT_LINK_MINOR$PILOT_LINK_PATCH"

dnl ******************************
dnl Pilot Link Library Version
dnl libpisock.so.CURRENT.AGE.REVISION
dnl Please see the following URL for details:
dnl http://sources.redhat.com/autobook/autobook/autobook_91.html
dnl ******************************
PISOCK_CURRENT=9
PISOCK_REVISION=2
PISOCK_AGE=0

AC_SUBST(PISOCK_CURRENT)
AC_SUBST(PISOCK_REVISION)
AC_SUBST(PISOCK_AGE)


dnl ******************************
dnl Pilot Link Sync Library Version
dnl libpisync.so
dnl ******************************
PISYNC_CURRENT=1
PISYNC_REVISION=3
PISYNC_AGE=0

AC_SUBST(PISYNC_CURRENT)
AC_SUBST(PISYNC_REVISION)
AC_SUBST(PISYNC_AGE)

dnl Check host type
AC_CANONICAL_HOST
AC_CANONICAL_TARGET
AC_DEFINE_UNQUOTED(HOST_OS, "$host", [Host type])

AM_INIT_AUTOMAKE([subdir-objects])


dnl ******************************
dnl Checks for basic programs.
dnl ******************************
AC_PROG_CC
AC_PROG_INSTALL(install ginstall)
LT_INIT
AC_PROG_YACC

dnl ******************************
dnl Platform-specific things
dnl ******************************

dnl PIC_LIBS is flags needed to compile PIC, for shared libs
dnl where some linker offsets are not allowed. Currently set
dnl for FreeBSD-amd64 only.
PIC_LIBS=""


dnl null_device is the default NULL device on your system
dnl (usually /dev/null or NUL). If yours is _not_ /dev/null,
dnl set it in the platform-specific section below.
null_device="/dev/null"

AS_CASE([$host],
	[*darwin*],
		[ CPPFLAGS="$CPPFLAGS -DMACOSX"
		AC_MSG_CHECKING(for fink support)
		AS_IF([test -d "/sw/lib" -a -d "/sw/include"],[
				CPPFLAGS="$CPPFLAGS -I/sw/include"
				LDFLAGS="$LDFLAGS -L/sw/lib"
				AC_MSG_RESULT(yes)
			]
			[AC_MSG_RESULT(no)])],

	[amd64*freebsd*],
		[PIC_LIBS="-fPIC"],
	[*solaris*],
		[AC_CHECK_FUNC(inet_pton,,
			[AC_CHECK_LIB(resolv,inet_pton,LIBS="-lresolv $LIBS")])
		AC_CHECK_FUNC(pow,,
			[AC_CHECK_LIB(m,pow,LIBS="-lm $LIBS")])],[]
)
AC_DEFINE_UNQUOTED(NULL_DEVICE, "$null_device",
		   [Your system's bitbucket (usually /dev/null or NUL)])
AC_SUBST(PIC_LIBS)

dnl ******************************
dnl Pilot Link Checks
dnl ******************************
AC_C_CONST
AC_STRUCT_TM
AC_PROG_GCC_TRADITIONAL

AC_CHECK_HEADERS(
	dirent.h errno.h fcntl.h inttypes.h memory.h netdb.h 		\
	netinet/in.h regex.h stdint.h stdlib.h string.h strings.h	\
	sys/ioctl_compat.h sys/ioctl.h 	sys/malloc.h sys/select.h	\
	sys/sockio.h sys/time.h sys/utsname.h unistd.h IOKit/IOBSD.h)
AC_CHECK_HEADERS(ifaddrs.h inttypes.h)

AC_CHECK_FUNCS(
	atexit cfmakeraw cfsetispeed cfsetospeed cfsetspeed dup2 	\
	gethostname inet_aton malloc memcpy memmove putenv sigaction	\
	snprintf strchr strdup strtok strtoul strerror uname)

dnl Find optional libraries (borrowed from Tcl)
tcl_checkBoth=0
AC_CHECK_FUNC(connect, tcl_checkSocket=0, tcl_checkSocket=1)

AS_IF([test "$tcl_checkSocket" = 1],
        [AC_CHECK_LIB(socket, main, LIBS="$LIBS -lsocket", tcl_checkBoth=1)]
)

AS_IF([test "$tcl_checkBoth" = 1], [
        tk_oldLibs=$LIBS
        LIBS="$LIBS -lsocket -lnsl"
        AC_CHECK_FUNC(
                accept, tcl_checkNsl=0, [LIBS=$tk_oldLibs])
])

AC_CHECK_FUNC(gethostbyname, , AC_CHECK_LIB(nsl, main, [LIBS="$LIBS -lnsl"]))
AC_CHECK_LIB(inet, main, [LIBS="$LIBS -linet"])

AC_CACHE_CHECK([for cispeed and cospeed members of struct termios],
	ac_cv_termios_cspeed,

	[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <termios.h>]], [[int main(void) {
		 struct termios t;t.c_ispeed=t.c_ospeed=0;}]])],[ac_cv_termios_cspeed=yes],[ac_cv_termios_cspeed=no])])

AS_IF([test $ac_cv_termios_cspeed = yes],
	[AC_DEFINE(TERMIOS_CSPEED, 1, [Define if we have termios(3) support])])

AC_CHECK_SOCKLEN_T

dnl ******************************
dnl pilot-link conduits
dnl ******************************
AC_MSG_CHECKING(whether to enable userland conduits)
AC_ARG_ENABLE(conduits,
	[  --enable-conduits       Build the userland conduits],
		[enable_conduits="yes"], [enable_conduits="no"],
)
AM_CONDITIONAL(ENABLE_CONDUITS,[test "x$enable_conduits" != "xno"])
AC_MSG_RESULT($enable_conduits)

dnl ******************************
dnl PNG Support
dnl ******************************
msg_png=no
AS_IF([test "x$enable_conduits" != "xno"], [
	have_png=no

	AC_ARG_WITH(libpng,
		[  --with-libpng           Prefix where libpng is installed])

	AS_CASE([$with_libpng],
		[/*],[
		PNG_CFLAGS="-I$withval/include"
		PNG_LIBS="-L$withval/lib"
		])

	save_CFLAGS="$CFLAGS"
	save_CPPFLAGS="$CPPFLAGS"
	save_LDFLAGS="$LDFLAGS"
	CFLAGS="$CFLAGS $PNG_CFLAGS"
	CPPFLAGS="$CPPFLAGS $PNG_CFLAGS"
	LDFLAGS="$LDFLAGS $PNG_LIBS"

	AC_CHECK_LIB(png, main, [have_png=yes; PNG_LIBS="$PNG_LIBS -lpng"],[have_png=no],[-lm])
	AS_IF([test "$have_png" = yes],[
		AC_CHECK_HEADER(png.h, , have_png=no)
		AS_IF([test "$have_png" = yes],[
			AC_MSG_CHECKING(for png setjmp support)
			AC_EGREP_CPP(yes,
			[#include <png.h>
			#ifdef PNG_SETJMP_SUPPORTED
				yes
			#endif], , have_png=no)
			AC_MSG_RESULT($have_png)
			AS_IF([test "$have_png" = yes],[
				AC_DEFINE(HAVE_PNG, 1, [Define if we have PNG support])
				have_png=yes
				msg_png=yes
			])
	])])

	CFLAGS="$save_CFLAGS"
	CPPFLAGS="$save_CPPFLAGS"
	LDFLAGS="$save_LDFLAGS"],
	[ have_png="none"
	PNG_CFLAGS=
	PNG_LIBS=
])

AC_SUBST(PNG_CFLAGS)
AC_SUBST(PNG_LIBS)


dnl ******************************
dnl Threading support
dnl ******************************
msg_threads=no
PILOT_LINK_THREADS_SUPPORT
AS_IF([$use_threads],[
	msg_threads=yes])


dnl ***************************************
dnl Test if building USB Support
dnl for Linux, FreeBSD or Darwin (Mac OS X)
dnl ***************************************
have_libusb=no
use_libusb=no
usb_type=
usb_libs=

AC_ARG_ENABLE(libusb,
	      AS_HELP_STRING([--enable-libusb         Enable usage of libusb]),
	      if test "x$enableval" != "xno" ; then
	          AC_CHECK_LIB(usb, usb_open, [have_libusb=yes;],[have_libusb=no])
	      fi
	      )
AS_IF([test "$have_libusb" = yes],[
	AC_DEFINE(HAVE_USB, 1, [Define if we have USB support])
	usb_type=libusb
	msg_usb="yes, libusb"
	AS_CASE(["$host"],
		[*darwin*],
			[usb_libs="-lusb -Wl,-framework,IOKit,-framework,CoreFoundation"],
			[AS_IF([test "$msg_threads" = "no"],[
			    usb_libs="-lusb -lpthread"],[
			    usb_libs="-lusb"
			])])
],[
	AS_CASE(["$host"],
		[*linux*],[
			AC_DEFINE(HAVE_USB, 1, [Define if we have USB support])
			usb_type=linux
			msg_usb="yes, Linux"
		],
		[*freebsd*],[
			AC_DEFINE(HAVE_USB, 1, [Define if we have USB support])
			usb_type=freebsd
			msg_usb="yes, FreeBSD"
		],
	    	[*darwin*],[
		   	AC_DEFINE(HAVE_USB, 1, [Define if we have USB support])
		    	usb_type=darwin
		    	msg_usb="yes, Darwin"
		    	usb_libs="-Wl,-framework,IOKit,-framework,CoreFoundation"
	    ])
])
AM_CONDITIONAL(WITH_USB, test x$usb_type)
AM_CONDITIONAL(WITH_LIBUSB, test x$usb_type = xlibusb)
AM_CONDITIONAL(WITH_LINUXUSB, test x$usb_type = xlinux)
AM_CONDITIONAL(WITH_FREEBSDUSB, test x$usb_type = xfreebsd)
AM_CONDITIONAL(WITH_DARWINUSB, test x$usb_type = xdarwin)
AC_SUBST(usb_libs)

dnl ******************************
dnl BlueZ Support
dnl ******************************
have_bluez=no
use_bluez=auto

AC_ARG_WITH(bluez,
		AS_HELP_STRING([--with-bluez],[Enable use of BlueZ]),
		[use_bluez="$withval"])
AS_IF([test "$use_bluez" != "no"],[
	PKG_CHECK_MODULES([BLUEZ],[bluez],[
		have_bluez=yes
		use_bluez=yes
	],[
		AC_MSG_RESULT([no pkgconfig package])
		AC_BLUEZ([
			have_bluez=yes
			use_bluez=yes
		],[
			test "$use_bluez" != "no" -a "$use_bluez" != "auto" \
			&& AC_MSG_ERROR([BlueZ explicitly requested, but no library found]) 
			use_bluez=no
			have_bluez=no
		])
	])
])

AS_IF([test "$use_bluez" = "yes"],[
	AC_DEFINE([HAVE_BLUEZ],[1],[Define if we build with BlueZ])
	AC_SUBST([BLUEZ_CFLAGS])
	AC_SUBST([BLUEZ_LIBS])])

AM_CONDITIONAL([WITH_BLUEZ],[test "$use_bluez" = "yes"])



dnl *********************************
dnl Check for popt (use internal if needed)
dnl *********************************
AC_ARG_WITH(included-popt,
[  --with-included-popt    use bundled popt library, not from system],,
		[with_included_popt="auto"]
)
AS_IF([test "x$enable_conduits" != "xno"],[
	AS_IF([test "x$with_included_popt" != "xyes"],[
		PKG_CHECK_MODULES([POPT], [popt])
		POPT_INCLUDES="${POPT_CFLAGS}"
	])

	AC_MSG_CHECKING(whether to use included popt)
	AS_IF([test "x$with_included_popt" = "xyes"],[
		msg_popt="yes (internal)"
	    AC_MSG_RESULT(yes)
		POPT_LIBS='$(top_builddir)/popt/libpopt.la'
	    POPT_INCLUDES='-I$(top_srcdir)/popt'
	],[
	    AC_MSG_RESULT(no)
		msg_popt="yes (system)"
	    POPT_LIBS="-lpopt"
	])
],[
	with_included_popt="no"
	msg_popt="none"
	POPT_LIBS=
	POPT_INCLUDES=
])
AM_CONDITIONAL(INCLUDED_POPT, [test "x$with_included_popt" = "xyes"])
AC_SUBST(POPT_LIBS)
AC_SUBST(POPT_INCLUDES)

dnl ******************************
dnl iconv checking
dnl ******************************
have_iconv=no

AC_ARG_WITH(libiconv, [  --with-libiconv         Prefix where libiconv is installed])

AS_CASE([$withval],
	[/*],[
		ICONV_CFLAGS="-I$withval/include"
		ICONV_LIBS="-L$withval/lib"
	])

save_CFLAGS="$CFLAGS"
save_LDFLAGS="$LDFLAGS"
CFLAGS="$CFLAGS $ICONV_CFLAGS"
LDFLAGS="$LDFLAGS $ICONV_LIBS"

AC_CHECK_LIB(
	iconv, libiconv, [have_iconv=yes; ICONV_LIBS="$ICONV_LIBS -liconv"], [
		AC_CHECK_FUNC(iconv, [
			AC_CHECK_FUNCS(gnu_get_libc_version)
			AC_MSG_CHECKING(if system iconv handles CP1252)
			AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <iconv.h>
#include <stdlib.h>
#include <string.h>
#ifdef HAVE_GNU_GET_LIBC_VERSION
#include <gnu/libc-version.h>
#endif

int main (int argc, char **argv)
{
	const char *pc = "\x66\x66\x66\x66\x66\x66\x66\xA9";
	const char *utf8 = "\x66\x66\x66\x66\x66\x66\x66\xC2\xA9";
	char transbuf[10], *trans = transbuf;
	iconv_t cd;
	size_t pc_len = strlen (pc), utf8_len = 10;
	size_t utf8_real_len = strlen (utf8);

	cd = iconv_open ("UTF-8", "CP1252");
	if (!cd)
		exit (1);
	if (iconv (cd, &pc, &pc_len, &trans, &utf8_len) == -1 || pc_len != 0)
		exit (1);
	if (memcmp (utf8, transbuf, utf8_real_len) != 0)
		exit (1);

	exit (0);
}]])],[AC_MSG_RESULT(yes); have_iconv=yes],[AC_MSG_RESULT(no);],[AC_MSG_RESULT(not cross compiling);])])])

dnl ##  Fixed AC_RUN_IFELSE([AC_LANG_SOURCE([[]])],[],[],[]) warning, missing third argument. -DD 22/01/2002
dnl
dnl 	AC_RUN_IFELSE([AC_LANG_SOURCE([[]])],[],[],[]) is a macro that's basically like an if-then-else structure. If
dnl 	the test program (whose text is the first argument) succeeds, the second
dnl 	argument is executed; if the test fails, the third argument is executed; and
dnl 	if autoconf knows it is cross-compiling for another machine and therefore
dnl 	can't run a test program at all, it doesn't try but just executes the fourth
dnl 	argument.  Usually that last alternative should be the most conservative
dnl 	assumption.

CFLAGS="$save_CFLAGS"
LDFLAGS="$save_LDFLAGS"

AS_IF([test "$have_iconv" = yes],[
	AC_DEFINE(HAVE_ICONV, 1, [Define if we have libiconv support])
	msg_iconv=yes
],[
	msg_iconv=no
])
AC_SUBST(ICONV_CFLAGS)
AC_SUBST(ICONV_LIBS)

dnl ******************************
dnl readline checking
dnl ******************************
AS_IF([test "x$enable_conduits" != "xno"],[
	VL_LIB_READLINE
],[
	msg_readline="none"
])

dnl ******************************
dnl Perl
dnl ******************************
use_perl=false
#msg_perl=no

AC_ARG_WITH(perl,    [  --with-perl=perlexec    use Perl                    [[default=no]]],
	, with_perl=no)
AS_IF([test "x$with_perl" = "xno"],[
	AC_MSG_CHECKING(if perl was enabled)
	AC_MSG_RESULT(no)
	PERL=''
],[
	AS_IF([test "x$with_perl" != "xyes" && test "x$with_perl" != "x"],[
		PERL="$with_perl"
	],[
		AC_CHECK_PROG(PERL, perl, perl)
	])
])

dnl Check if version of Perl is sufficient
PERL_MINVERSION="5.000_00"

AS_IF([ test "x$PERL" != "x" ], [
	AC_MSG_CHECKING(for perl version greater than or equal to $PERL_MINVERSION)
	$PERL -e "exit ! eval 'use $PERL_MINVERSION; 1'"
	dnl Don't replace with m4 AS_IF, it doesn't work for some reason
	if test $? -ne 0 ; then
		AC_MSG_RESULT(no)
		use_perl=false
	else
		AC_MSG_RESULT(yes)
		PERL_VERSION=`$PERL -e 'print $]'`
		use_perl=true
	fi
])

AM_CONDITIONAL(WITH_PERL, $use_perl)
#if $use_perl; then
#	msg_perl=yes
#fi
AC_SUBST(PERL)


dnl ******************************
dnl TCL
dnl ******************************
PILOT_LINK_PATH_TCLCONFIG
AS_IF([$use_tcl],[
	PILOT_LINK_LOAD_TCLCONFIG
	PILOT_LINK_PUBLIC_TCL_HEADERS
	PILOT_LINK_PROG_TCLSH
	PILOT_LINK_PROG_WISH
])

#AC_SUBST(TCL_INCLUDES)
#AC_SUBST(TCL_LIB_FILE)
#AC_SUBST(TCL_LIB_FLAG)
#AC_SUBST(TCL_LIB_SPEC)
#AC_SUBST(TCL_LIBS)
#AC_SUBST(TCL_VERSION)
#AC_SUBST(TCLSH_PROG)
#AC_SUBST(WISH_PROG)

AM_CONDITIONAL(WITH_TCL, $use_tcl)


dnl ******************************
dnl Python
dnl ******************************
use_python=false
AC_ARG_WITH(python,   [  --with-python=pybase    use Python,                 [[default=no]]],
        , with_python=no)

AS_IF([test "x$with_python" != "xno"],[
        AC_PATH_PROGS(PYTHON, [python])
        AS_IF([test "x$PYTHON" != "x"],[
		AM_CHECK_PYTHON
	])

	AS_IF([test "x$PYTHON_H" = "xyes"],[
		AC_SUBST(PYTHON_VERSION)
		AC_SUBST(PYTHON_CFLAGS)
		AC_SUBST(PYTHON_LIBS)
		AC_SUBST(PYTHON_H)

		use_python=true
	],[
		PYTHON_VERSION=''
	])
])

AM_CONDITIONAL(WITH_PYTHON, $use_python)
AS_IF([$use_python],[
        msg_python=yes])

dnl *************************************
dnl ElectricFence (optional)
dnl *************************************
msg_efence=no
AC_ARG_WITH(efence, [  --with-efence           use ElectricFence,          [[default=no]]],
	, with_efence=no)

AS_IF([test "x$with_efence" != "xno"],[
	AC_CHECK_LIB(efence, malloc, LIBS="$LIBS -lefence")
        AS_IF([test "$ac_cv_lib_efence_malloc" = yes],[
                msg_efence=true
        ],[
                echo "Unable to locate ElectricFence malloc() debugging library!"
                echo "Please download from ftp://ftp.perens.com/pub/ElectricFence/"
                echo "You may also try omitting --with-efence when running configure."
                echo ""
                exit 1;
        ])
])


dnl *************************************
dnl Runtime debugging
dnl *************************************
set_debug=yes
AC_ARG_ENABLE(debug,
	      [  --disable-debug         Shunt runtime debugging],
	      [set_debug=no])

AS_IF([test "${enable_debug+set}" = set],[
	AS_IF([test "$enable_debug" = yes],[
		CFLAGS="-g $CFLAGS"
		set_debug=yes
	])
])

echo -n "Runtime debugging is "
AS_IF([test "$set_debug" = "yes"],[
	echo "enabled"
	AC_DEFINE(PI_DEBUG, 1, [Define if we have debugging enabled])
],[
	echo "disabled"
	CFLAGS=`echo "$CFLAGS" | sed -e "s/-g //"`
])

dnl *************************************
dnl Profiling information
dnl *************************************
AC_ARG_ENABLE(profile,
        [  --enable-profile        use gprof profiling [[default=no]]],
        CFLAGS="-pg $CFLAGS")

dnl *************************************
dnl Check for xsltproc
dnl *************************************
AM_CONDITIONAL(BUILD_XML,[test ! -d "{$srcdir}/CVS"])
# if test -d "${srcdir}/CVS" ; then

AC_ARG_ENABLE([xsltproc], [AS_HELP_STRING([--enable-xsltproc],[Use xsltproc to build documentation [default=no]])],
	[enable_xsltproc="$enableval"],
[enable_xsltproc=no])
AS_IF([test x"$enable_xsltproc" = x"yes"],[
  AC_PATH_PROG([XSLTPROC], [xsltproc], [no])
  AS_IF([test x"$XSLTPROC" = x"no"],[
    enable_xsltproc=no
  ])
])
AM_CONDITIONAL([ENABLE_XSLTPROC], [test x"$enable_xsltproc" = x"yes"])

# fi

# now let's test to see if we can find the docbook-xsl stuff
XSLTPROC_FLAGS="--nonet"
AC_SUBST(XML_CATALOG)
AC_SUBST(XSLTPROC_FLAGS)
AC_SUBST(DOCBOOK_ROOT)  
AC_SUBST(CAT_ENTRY_START)
AC_SUBST(CAT_ENTRY_END)  
AC_SUBST(XSLTPROC)

dnl *************************************
dnl Extra warnings
dnl *************************************
set_compile_warnings=no

AC_ARG_ENABLE(compile-warnings,
	      [  --enable-compile-warnings
                          Enable verbose compiler warnings],
	      set_compile_warnings=yes)

AS_IF([test "$GCC" = "yes" -a "$set_compile_warnings" != "no"],[
	CFLAGS="$CFLAGS \
		-std=gnu99 -g -Wshadow -Wall -W -Waggregate-return -Wcast-align 	\
		-Wcast-qual -Wnested-externs -Wpointer-arith -Wundef -Winline	\
		-Wbad-function-cast -pedantic -O0"

])

AS_CASE([$host],
	[*bsd*],
		[AC_DEFINE(TTYPrompt, "/dev/cua[<0..n>]", [Define verbose tty device])],
		[AC_DEFINE(TTYPrompt, "/dev/tty[<0..n>]", [Define verbose tty device])])


dnl *************************************
dnl Promote warnings to errors
dnl *************************************
dnl (already done) enable_werror=no

AC_ARG_ENABLE(compile-werror,
	      [  --enable-compile-werror
                          Causes warnings to be treated as errors in GCC],
	      enable_werror=yes)
AS_IF([test "x$GCC" = "xyes" -a "x$enable_werror" = "xyes"],[
	CFLAGS="$CFLAGS -Werror"
])

AC_CONFIG_FILES([
	Makefile
	pilot-link.m4
	pilot-link.pc
	pilot-link-pp.pc
	libpisock/Makefile
	libpisync/Makefile
	include/Makefile
	include/pi-version.h
	popt/Makefile
	src/Makefile
	src/prc/Makefile
	src/pix/Makefile
	bindings/Makefile
	bindings/Perl/Makefile.PL
	bindings/Python/setup.py
	bindings/Python/setup-standalone.py
	bindings/Tcl/Makefile
	doc/Makefile
	doc/doxygen.cfg
	doc/xml/Makefile
	doc/xml/catalog.xml
	doc/xml/docbook.xsl
	doc/man/Makefile
	
tests/Makefile
	darwin/Makefile
])
AC_OUTPUT

AC_MSG_RESULT([
  Options detected/selected
  -------------------------.
  pilot-link version...... : AC_PACKAGE_VERSION
  libpisock version....... : $PISOCK_CURRENT.$PISOCK_AGE.$PISOCK_REVISION
  libpisync version....... : $PISYNC_CURRENT.$PISYNC_AGE.$PISYNC_REVISION
  Build for host.......... : $host
  Extra Warnings.......... : $set_compile_warnings
  Direct USB support...... : $msg_usb
  BlueZ support........... : $use_bluez
  Thread-safe libpisock... : $msg_threads
  ElectricFence checks.... : $msg_efence
  CPPFLAGS................ : $CPPFLAGS
  CFLAGS.................. : $CFLAGS

  Userland Tools
  -------------------------.
  Build userland tools.... : $enable_conduits
  Support for popt........ : $msg_popt
  Readline support........ : $msg_readline
  PNG support............. : $msg_png

  Internal Language Support
  -------------------------.
  Iconv support........... : $msg_iconv

  External Language Support
  -------------------------.
  TCL support............. : $use_tcl	$TCL_VERSION
  Python support.......... : $use_python	$PYTHON_VERSION
  Perl support............ : $use_perl	$PERL_VERSION
])

