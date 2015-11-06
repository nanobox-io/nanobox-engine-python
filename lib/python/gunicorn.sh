# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

python_install_gunicorn() {
  [[ "$(python_can_run)" = "true" ]] && (cd $(nos_live_dir); nos_run_subprocess "pip install" "env/bin/pip install gunicorn")
}

python_create_gunicorn_conf() {
  if [[ "$(python_can_run)" = "true" ]]; then
    nos_print_bullet "Generating gunicorn config.py"
    mkdir -p $(nos_etc_dir)/gunicorn
    mkdir -p $(nos_deploy_dir)/var/log/gunicorn
    mkdir -p $(nos_deploy_dir)/var/run
    mkdir -p $(nos_deploy_dir)/var/tmp
    nos_template \
      "gunicorn/config.py.mustache" \
      "$(nos_etc_dir)/gunicorn/config.py" \
      "$(python_gunicorn_conf_payload)"
  fi
}

python_gunicorn_conf_payload() {
  _gunicorn_backlog=$(python_gunicorn_backlog)
  _gunicorn_workers=$(python_gunicorn_workers)
  _gunicorn_worker_class=$(python_gunicorn_worker_class)
  _gunicorn_threads=$(python_gunicorn_threads)
  _gunicorn_worker_connections=$(python_gunicorn_worker_connections)
  _gunicorn_max_requests=$(python_gunicorn_max_requests)
  _gunicorn_max_requests_jitter=$(python_gunicorn_max_requests_jitter)
  _gunicorn_timeout=$(python_gunicorn_timeout)
  _gunicorn_graceful_timeout=$(python_gunicorn_graceful_timeout)
  _gunicorn_keepalive=$(python_gunicorn_keepalive)
  _gunicorn_limit_request_line=$(python_gunicorn_limit_request_line)
  _gunicorn_limit_request_fields=$(python_gunicorn_limit_request_fields)
  _gunicorn_limit_request_field_size=$(python_gunicorn_limit_request_field_size)
  _gunicorn_spew=$(python_gunicorn_spew)
  _gunicorn_preload_app=$(python_gunicorn_preload_app)
  _gunicorn_sendfile=$(python_gunicorn_sendfile)
  _gunicorn_raw_env=$(python_gunicorn_raw_env)
  _gunicorn_loglevel=$(python_gunicorn_loglevel)
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
  "live_dir": "$(nos_live_dir)",
  "raw_env": "${_gunicorn_raw_env}",
  "deploy_dir": "$(nos_deploy_dir)",
  "loglevel": "${_gunicorn_loglevel}",
  "app_name": "$(python_app_name)"
}
END
}

python_gunicorn_backlog() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_backlog)" "integer" "2048")"
}

python_gunicorn_workers() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_workers)" "integer" "1")"
}

python_gunicorn_worker_class() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_worker_class)" "string" "sync")"
}

python_gunicorn_threads() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_threads)" "integer" "1")"
}

python_gunicorn_worker_connections() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_worker_connections)" "integer" "1000")"
}

python_gunicorn_max_requests() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_max_requests)" "integer" "1024")"
}

python_gunicorn_max_requests_jitter() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_max_requests_jitter)" "integer" "128")"
}

python_gunicorn_timeout() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_timeout)" "integer" "30")"
}

python_gunicorn_graceful_timeout() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_graceful_timeout)" "integer" "30")"
}

python_gunicorn_keepalive() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_keepalive)" "integer" "15")"
}

python_gunicorn_limit_request_line() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_limit_request_line)" "integer" "4094")"
}

python_gunicorn_limit_request_fields() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_limit_request_fields)" "integer" "100")"
}

python_gunicorn_limit_request_field_size() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_limit_request_field_size)" "integer" "8190")"
}

python_gunicorn_spew() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_spew)" "boolean" "False")"
}

python_gunicorn_preload_app() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_preload_app)" "boolean" "True")"
}

python_gunicorn_sendfile() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_sendfile)" "boolean" "True")"
}

python_gunicorn_raw_env() {
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

python_gunicorn_loglevel() {
  echo "$(nos_validate "$(nos-payload boxfile_gunicorn_loglevel)" "string" "info")"
}
