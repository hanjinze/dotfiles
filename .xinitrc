if which dbus-launch > /dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
	    eval "$(dbus-launch --sh-syntax --exit-with-session)"
		fi

exec ck-launch-session dbus-launch awesome >> ~/.cache/awesome/awesome.log 2>> ~/.cache/awesome/awesome-error.log
#exec openbox
