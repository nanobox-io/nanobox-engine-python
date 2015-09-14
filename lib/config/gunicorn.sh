# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

install_gunicorn() {
  [[ "$(can_run)" = "true" ]] && (cd $(live_dir); run_subprocess "pip install" "env/bin/pip install gunicorn")
}

create_gunicorn_conf() {
	if [[ "$(can_run)" = "true" ]]; then
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
  cat <<-END
{
	"backlog": "$(gunicorn_backlog)",
	"workers": "$(gunicorn_workers)",
	"worker_class": "$(gunicorn_worker_class)",
	"threads": "$(gunicorn_threads)",
	"worker_connections": "$(gunicorn_worker_connections)",
	"max_requests": "$(gunicorn_max_requests)",
	"max_requests_jitter": "$(gunicorn_max_requests_jitter)",
	"timeout": "$(gunicorn_timeout)",
	"graceful_timeout": "$(gunicorn_graceful_timeout)",
	"keepalive": "$(gunicorn_keepalive)",
	"limit_request_line": "$(gunicorn_limit_request_line)",
	"limit_request_fields": "$(gunicorn_limit_request_fields)",
	"limit_request_field_size": "$(gunicorn_limit_request_field_size)",
	"spew": "$(gunicorn_spew)",
	"preload_app": "$(gunicorn_preload_app)",
	"sendfile": "$(gunicorn_sendfile)",
	"live_dir": "$(live_dir)",
	"raw_env": "$(gunicorn_raw_env)",
	"deploy_dir": "$(deploy_dir)",
	"loglevel": "$(gunicorn_loglevel)",
	"app_name": "$(app_name)"
}
END
}

gunicorn_backlog() {
	echo "$(validate "$(payload boxfile_gunicorn_backlog)" "integer" "2048")"
}

gunicorn_workers() {
	echo "$(validate "$(payload boxfile_gunicorn_workers)" "integer" "2")"
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
