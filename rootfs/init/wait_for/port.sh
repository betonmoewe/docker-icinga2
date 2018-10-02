
wait_for_port() {

  local server=${1}
  local port=${2}
  local max_retry=${3:-30}
  local retry=0

  log_info "check if the port ${port} for '${server}' is available"

  until [[ ${max_retry} -lt ${retry} ]]
  do
    # -v              Verbose
    # -w secs         Timeout for connects and final net reads
    # -X proto        Proxy protocol: "4", "5" (SOCKS) or "connect"
    #
    status=$(nc -v -w1 -X connect ${server} ${port} 2>&1 > /dev/null)

    #log_debug "'${status}'"

    if [[ $(echo "${status}" | grep -c succeeded) -eq 1 ]]
    then
      break
    else
      retry=$(expr ${retry} + 1)
      log_info "  wait for an open port (${retry}/${max_retry})"
      sleep 5s
    fi
  done

  if [[ ${retry} -eq ${max_retry} ]] || [[ ${retry} -gt ${max_retry} ]]
  then
    log_error "could not connect to the icinga2 master instance '${server}'"
    exit 1
  fi
}

