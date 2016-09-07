# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

install_gunicorn() {
  [[ "$(can_run)" = "true" ]] && (cd $(nos_code_dir); nos_run_process "pip install" "env/bin/pip install gunicorn")
}

create_gunicorn_conf() {
  if [[ "$(can_run)" = "true" ]]; then
    nos_print_bullet "Generating gunicorn config.py"
    mkdir -p $(nos_etc_dir)/gunicorn
    mkdir -p $(nos_data_dir)/var/log/gunicorn
    mkdir -p $(nos_data_dir)/var/run
    mkdir -p $(nos_data_dir)/var/tmp
    nos_template \
      "gunicorn/config.py.mustache" \
      "$(nos_etc_dir)/gunicorn/config.py" \
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
  nos_print_bullet_sub "Backlog: ${_gunicorn_backlog}"
  nos_print_bullet_sub "Workers: ${_gunicorn_workers}"
  nos_print_bullet_sub "Worker class: ${_gunicorn_worker_class}"
  nos_print_bullet_sub "Threads: ${_gunicorn_threads}"
  nos_print_bullet_sub "Worker connections: ${_gunicorn_worker_connections}"
  nos_print_bullet_sub "Max requests: ${_gunicorn_max_requests}"
  nos_print_bullet_sub "Max requests jitter: ${_gunicorn_max_requests_jitter}"
  nos_print_bullet_sub "Timeout: ${_gunicorn_timeout}"
  nos_print_bullet_sub "Graceful timeout: ${_gunicorn_graceful_timeout}"
  nos_print_bullet_sub "Keepalive: ${_gunicorn_keepalive}"
  nos_print_bullet_sub "Limit request line: ${_gunicorn_limit_request_line}"
  nos_print_bullet_sub "Limit request fields: ${_gunicorn_limit_request_fields}"
  nos_print_bullet_sub "Limit request field_size: ${_gunicorn_limit_request_field_size}"
  nos_print_bullet_sub "Spew: ${_gunicorn_spew}"
  nos_print_bullet_sub "Preload app: ${_gunicorn_preload_app}"
  nos_print_bullet_sub "Sendfile: ${_gunicorn_sendfile}"
  nos_print_bullet_sub "Raw env: ${_gunicorn_raw_env}"
  nos_print_bullet_sub "Log level: ${_gunicorn_loglevel}"
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
  "code_dir": "$(nos_code_dir)",
  "raw_env": "${_gunicorn_raw_env}",
  "data_dir": "$(nos_data_dir)",
  "loglevel": "${_gunicorn_loglevel}",
  "app_name": "$(app_name)"
}
END
}

gunicorn_backlog() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_backlog)" "integer" "2048")"
}

gunicorn_workers() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_workers)" "integer" "1")"
}

gunicorn_worker_class() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_worker_class)" "string" "sync")"
}

gunicorn_threads() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_threads)" "integer" "1")"
}

gunicorn_worker_connections() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_worker_connections)" "integer" "1000")"
}

gunicorn_max_requests() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_max_requests)" "integer" "1024")"
}

gunicorn_max_requests_jitter() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_max_requests_jitter)" "integer" "128")"
}

gunicorn_timeout() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_timeout)" "integer" "30")"
}

gunicorn_graceful_timeout() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_graceful_timeout)" "integer" "30")"
}

gunicorn_keepalive() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_keepalive)" "integer" "15")"
}

gunicorn_limit_request_line() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_limit_request_line)" "integer" "4094")"
}

gunicorn_limit_request_fields() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_limit_request_fields)" "integer" "100")"
}

gunicorn_limit_request_field_size() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_limit_request_field_size)" "integer" "8190")"
}

gunicorn_spew() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_spew)" "boolean" "False")"
}

gunicorn_preload_app() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_preload_app)" "boolean" "True")"
}

gunicorn_sendfile() {
  echo "$(nos_validate "$(nos_payload config_gunicorn_sendfile)" "boolean" "True")"
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
  echo "$(nos_validate "$(nos_payload config_gunicorn_loglevel)" "string" "info")"
}
