AC_DEFUN([AC_PILOT_LINK_HOOK], [
	PILOT_LINK_VERS=0
	PILOT_LINK_MAJOR=12
	PILOT_LINK_MINOR=6
	PILOT_LINK_PATCH=

	AC_MSG_CHECKING(for pilot-link version >= $1)

	vers=$PILOT_LINK_VERS.$PILOT_LINK_MAJOR.$PILOT_LINK_MINOR$PILOT_LINK_PATCH
	pl_ve=`echo $1|sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\1/'`
	pl_ma=`echo $1|sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\2/'`
	pl_mi=`echo $1|sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\3/'`

	if test $PILOT_LINK_VERS -gt $pl_ve; then
		AC_MSG_RESULT(yes ($vers))
	elif test $PILOT_LINK_VERS -eq $pl_ve; then
		if test $PILOT_LINK_MAJOR -gt $pl_ma; then 
			AC_MSG_RESULT(yes ($vers))
		elif test $PILOT_LINK_MAJOR -eq $pl_ma; then 
			if test $PILOT_LINK_MINOR -gt $pl_mi; then 
				AC_MSG_RESULT(yes ($vers))
			elif test $PILOT_LINK_MINOR -eq $pl_mi; then 
				AC_MSG_RESULT(yes ($vers))
			else
				AC_MSG_ERROR(no)
			fi
		else
			AC_MSG_ERROR(no)
		fi
	else
		AC_MSG_ERROR(no)
	fi
])

AC_DEFUN([AC_PILOT_LINK],[
	if test x$1 = x; then
		plv=$PILOT_LINK_VERS.$PILOT_LINK_MAJOR.$PILOT_LINK_MINOR
	else
		plv=$1
	fi
		
	AC_PILOT_LINK_HOOK($plv)
])
