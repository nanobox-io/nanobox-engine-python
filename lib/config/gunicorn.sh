# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

install_gunicorn() {
  [[ "$(can_run)" = "true" ]] && (cd $(live_dir); run_subprocess "pip install" "env/bin/pip install gunicorn")
}

create_gunicorn_conf() {
  if [[ "$(can_run)" = "true" ]]; then
    print_bullet "Generating gunicorn config.py"
    mkdir -p $(etc_dir)/gunicorn
    mkdir -p $(deploy_dir)/var/log/gunicorn
    mkdir -p $(deploy_dir)/var/run
    mkdir -p $(deploy_dir)/var/tmp
    template \
      "gunicorn/config.py.mustache" \
      "$(etc_dir)/gunicorn/config.py" \
      "$(gunicorn_conf_payload)"
  fi
}

gunicorn_conf_payload() {
  _gunicorn_backlog=$(gunicorn_backlog)
  _gunicorn_workers=$(gunicorn_workers)
  _gunicorn_worker_class=$(gunicorn_worker_class)
  _gunicorn_threads=$(gunicorn_threads)
  _gunicorn_worker_connections=$(gunicorn_worker_connections)
  _gunicorn_max_requests=$(gunicorn_max_requests)
  _gunicorn_max_requests_jitter=$(gunicorn_max_requests_jitter)
  _gunicorn_timeout=$(gunicorn_timeout)
  _gunicorn_graceful_timeout=$(gunicorn_graceful_timeout)
  _gunicorn_keepalive=$(gunicorn_keepalive)
  _gunicorn_limit_request_line=$(gunicorn_limit_request_line)
  _gunicorn_limit_request_fields=$(gunicorn_limit_request_fields)
  _gunicorn_limit_request_field_size=$(gunicorn_limit_request_field_size)
  _gunicorn_spew=$(gunicorn_spew)
  _gunicorn_preload_app=$(gunicorn_preload_app)
  _gunicorn_sendfile=$(gunicorn_sendfile)
  _gunicorn_raw_env=$(gunicorn_raw_env)
  _gunicorn_loglevel=$(gunicorn_loglevel)
  print_bullet_sub "Backlog: ${_gunicorn_backlog}"
  print_bullet_sub "Workers: ${_gunicorn_workers}"
  print_bullet_sub "Worker class: ${_gunicorn_worker_class}"
  print_bullet_sub "Threads: ${_gunicorn_threads}"
  print_bullet_sub "Worker connections: ${_gunicorn_worker_connections}"
  print_bullet_sub "Max requests: ${_gunicorn_max_requests}"
  print_bullet_sub "Max requests jitter: ${_gunicorn_max_requests_jitter}"
  print_bullet_sub "Timeout: ${_gunicorn_timeout}"
  print_bullet_sub "Graceful timeout: ${_gunicorn_graceful_timeout}"
  print_bullet_sub "Keepalive: ${_gunicorn_keepalive}"
  print_bullet_sub "Limit request line: ${_gunicorn_limit_request_line}"
  print_bullet_sub "Limit request fields: ${_gunicorn_limit_request_fields}"
  print_bullet_sub "Limit request field_size: ${_gunicorn_limit_request_field_size}"
  print_bullet_sub "Spew: ${_gunicorn_spew}"
  print_bullet_sub "Preload app: ${_gunicorn_preload_app}"
  print_bullet_sub "Sendfile: ${_gunicorn_sendfile}"
  print_bullet_sub "Raw env: ${_gunicorn_raw_env}"
  print_bullet_sub "Log level: ${_gunicorn_loglevel}"
  cat <<-END
{
  "backlog": "${_gunicorn_backlog}",
  "workers": "${_gunicorn_workers}",
  "worker_class": "${_gunicorn_worker_class}",
  "threads": "${_gunicorn_threads}",
  "worker_connections": "${_gunicorn_worker_connections}",
  "max_requests": "${_gunicorn_max_requests}",
  "max_requests_jitter": "${_gunicorn_max_requests_jitter}",
  "timeout": "${_gunicorn_timeout}",
  "graceful_timeout": "${_gunicorn_graceful_timeout}",
  "keepalive": "${_gunicorn_keepalive}",
  "limit_request_line": "${_gunicorn_limit_request_line}",
  "limit_request_fields": "${_gunicorn_limit_request_fields}",
  "limit_request_field_size": "${_gunicorn_limit_request_field_size}",
  "spew": "${_gunicorn_spew}",
  "preload_app": "${_gunicorn_preload_app}",
  "sendfile": "${_gunicorn_sendfile}",
  "live_dir": "$(live_dir)",
  "raw_env": "${_gunicorn_raw_env}",
  "deploy_dir": "$(deploy_dir)",
  "loglevel": "${_gunicorn_loglevel}",
  "app_name": "$(app_name)"
}
END
}

gunicorn_backlog() {
  echo "$(validate "$(payload boxfile_gunicorn_backlog)" "integer" "2048")"
}

gunicorn_workers() {
  echo "$(validate "$(payload boxfile_gunicorn_workers)" "integer" "1")"
}

gunicorn_worker_class() {
  echo "$(validate "$(payload boxfile_gunicorn_worker_class)" "string" "sync")"
}

gunicorn_threads() {
  echo "$(validate "$(payload boxfile_gunicorn_threads)" "integer" "1")"
}

gunicorn_worker_connections() {
  echo "$(validate "$(payload boxfile_gunicorn_worker_connections)" "integer" "1000")"
}

gunicorn_max_requests() {
  echo "$(validate "$(payload boxfile_gunicorn_max_requests)" "integer" "1024")"
}

gunicorn_max_requests_jitter() {
  echo "$(validate "$(payload boxfile_gunicorn_max_requests_jitter)" "integer" "128")"
}

gunicorn_timeout() {
  echo "$(validate "$(payload boxfile_gunicorn_timeout)" "integer" "30")"
}

gunicorn_graceful_timeout() {
  echo "$(validate "$(payload boxfile_gunicorn_graceful_timeout)" "integer" "30")"
}

gunicorn_keepalive() {
  echo "$(validate "$(payload boxfile_gunicorn_keepalive)" "integer" "15")"
}

gunicorn_limit_request_line() {
  echo "$(validate "$(payload boxfile_gunicorn_limit_request_line)" "integer" "4094")"
}

gunicorn_limit_request_fields() {
  echo "$(validate "$(payload boxfile_gunicorn_limit_request_fields)" "integer" "100")"
}

gunicorn_limit_request_field_size() {
  echo "$(validate "$(payload boxfile_gunicorn_limit_request_field_size)" "integer" "8190")"
}

gunicorn_spew() {
  echo "$(validate "$(payload boxfile_gunicorn_spew)" "boolean" "False")"
}

gunicorn_preload_app() {
  echo "$(validate "$(payload boxfile_gunicorn_preload_app)" "boolean" "True")"
}

gunicorn_sendfile() {
  echo "$(validate "$(payload boxfile_gunicorn_sendfile)" "boolean" "True")"
}

gunicorn_raw_env() {
  declare -a envs
  for key in ${Pl_env_nodes}; do
    value=PL_env_${key}_value
    envs+=("${key}=${!value}")
  done
  if [[ -n "${envs[@]}" ]]; then
    echo "[\"$(join '","' "${envs[@]}")\"]"
  else
    echo "[]"
  fi
}

gunicorn_loglevel() {
  echo "$(validate "$(payload boxfile_gunicorn_loglevel)" "string" "info")"
}
