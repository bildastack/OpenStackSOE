if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi

# if isinstalled $1; then echo "installed"; else echo "not installed"; fi


