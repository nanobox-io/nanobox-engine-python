# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_boxfile() {
  nos_template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
  _can_run=$(can_run)
  _app_module=$(app_module)
  if [[ "${_can_run}" = "true" ]]; then
    nos_print_bullet_sub "Using ${_app_module} as Python app module"
  else
    nos_print_bullet_sub "Did not have app_module in Boxfile, not creating web service"
  fi
  cat <<-END
{
  "can_run": ${_can_run},
  "etc_dir": "$(nos_etc_dir)",
  "code_dir": "$(nos_code_dir)",
  "data_dir": "$(nos_data_dir)",
  "app_module": "${_app_module}"
}
END
}

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live code directory..."
  rsync -a $(nos_code_dir)/ $(nos_app_dir)
}

app_name() {
  # payload app
  echo "$(nos_payload app)"
}

can_run() {
  [[ -n "$(app_module)" ]] && echo "true" || echo "false"
}

app_module() {
  echo "$(nos_validate "$(nos_payload 'config_app_module')" "string" "")"
}

runtime() {
  echo "$(nos_validate "$(nos_payload 'config_runtime')" "string" "python27")"
}

install_runtime() {
  nos_install "$(runtime)" "$(virtualenv_package)"
}

virtualenv_package() {
  _runtime=$(runtime)
  [[ "${_runtime}" =~ ^python[0-9]+$ ]] && echo "${_runtime//thon/}-virtualenv"
}

create_env() {
  (cd $(nos_code_dir); nos_run_process "virtualenv env" "virtualenv env")
}

pip_install() {
  (cd $(nos_code_dir); nos_run_process "pip install" "env/bin/pip install -r $(nos_code_dir)/requirements.txt")
}