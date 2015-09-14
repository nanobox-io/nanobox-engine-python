# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_boxfile() {
  template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
    cat <<-END
{
  "has_bower": $(has_bower),
  "can_run": $(can_run),
  "etc_dir": "$(etc_dir)",
  "live_dir": "$(live_dir)",
  "deploy_dir": "$(deploy_dir)",
  "app_module": "$(app_module)"
}
END
}

app_name() {
  # payload app
  echo "$(payload app)"
}

live_dir() {
  # payload live_dir
  echo $(payload "live_dir")
}

deploy_dir() {
  # payload deploy_dir
  echo $(payload "deploy_dir")
}

etc_dir() {
  echo $(payload "etc_dir")
}

code_dir() {
  echo $(payload "code_dir")
}

can_run() {
  [[ -n "$(app_module)" ]] && echo "true" || echo "false"
}

app_module() {
  echo "$(validate "$(payload 'boxfile_app_module')" "string" "")"
}

runtime() {
  echo "$(validate "$(payload 'boxfile_runtime')" "string" "python27")"
}

install_runtime() {
  install "$(runtime)"
}

virtualenv_package() {
  python_runtime=$(runtime)
  [[ "${python_runtime}" =~ ^python[0-9]+$ ]] && echo "${python_runtime//thon/}-virtualenv"
}

install_virtualenv() {
  install "$(virtualenv_package)"
}

create_env() {
  (cd $(live_dir); run_subprocess "virtualenv env" "virtualenv env")
}

pip_package() {
  python_runtime=$(runtime)
  [[ "${python_runtime}" =~ ^python[0-9]+$ ]] && echo "${python_runtime//thon/}-pip"
}

install_pip() {
  install "$(pip_package)"
}

pip_install() {
  (cd $(live_dir); run_subprocess "pip install" "env/bin/pip install -r $(code_dir)/requirements.txt")
}

js_runtime() {
  echo $(validate "$(payload "boxfile_js_runtime")" "string" "nodejs-0.12")
}

install_js_runtime() {
  install "$(js_runtime)"
}

set_js_runtime() {
  [[ -d $(code_dir)/node_modules ]] && echo "$(js_runtime)" > $(code_dir)/node_modules/runtime
}

check_js_runtime() {
  [[ ! -d $(code_dir)/node_modules ]] && echo "true" && return
  [[ "$(cat $(code_dir)/node_modules/runtime)" =~ ^$(js_runtime)$ ]] && echo "true" || echo "false"
}

npm_rebuild() {
  [[ "$(check_js_runtime)" = "false" ]] && (cd $(code_dir); run_subprocess "npm rebuild" "npm rebuild")
}