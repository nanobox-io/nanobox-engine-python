# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

python_create_boxfile() {
  nos_template \
    "boxfile.mustache" \
    "-" \
    "$(python_boxfile_payload)"
}

python_boxfile_payload() {
  _has_bower=$(nodejs_has_bower)
  _has_redis=$(python_has_redis)
  _can_run=$(python_can_run)
  _app_module=$(python_app_module)
  if [[ "${_can_run}" = "true" ]]; then
    nos_print_bullet_sub "Using ${_app_module} as Python app module"
  else
    nos_print_bullet_sub "Did not have app_module in Boxfile, not creating web service"
  fi
  if [[ "$_has_bower" = "true" ]]; then
    nos_print_bullet_sub "Adding lib_dirs for bower"
  fi
  cat <<-END
{
  "has_bower": ${_has_bower},
  "has_redis": ${_has_redis},
  "can_run": ${_can_run},
  "etc_dir": "$(nos_etc_dir)",
  "live_dir": "$(nos_live_dir)",
  "deploy_dir": "$(nos_deploy_dir)",
  "app_module": "${_app_module}"
}
END
}

python_app_name() {
  # payload app
  echo "$(nos_payload app)"
}

python_can_run() {
  [[ -n "$(python_app_module)" ]] && echo "true" || echo "false"
}

python_app_module() {
  echo "$(nos_validate "$(nos_payload 'boxfile_app_module')" "string" "")"
}

python_runtime() {
  echo "$(nos_validate "$(nos_payload 'boxfile_python_runtime')" "string" "python27")"
}

python_install_runtime() {
  nos_install "$(python_runtime)"
}

python_virtualenv_package() {
  _python_runtime=$(python_runtime)
  [[ "${_python_runtime}" =~ ^python[0-9]+$ ]] && echo "${_python_runtime//thon/}-virtualenv"
}

python_install_virtualenv() {
  nos_install "$(python_virtualenv_package)"
}

python_create_env() {
  (cd $(nos_code_dir); nos_run_subprocess "virtualenv env" "virtualenv env")
}

python_pip_install() {
  (cd $(nos_code_dir); nos_run_subprocess "pip install" "env/bin/pip install -r $(nos_code_dir)/requirements.txt")
}

python_has_redis() {
  ( [[ -f $(nos_code_dir)/requirements.txt ]] && grep -i 'redis' $(nos_code_dir)/requirements.txt ) && echo "true" || echo "false"
}
