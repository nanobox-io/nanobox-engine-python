# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live code directory..."
  rsync -a $(nos_code_dir)/ $(nos_app_dir)
}

# Determine the python runtime to install. This will first check
# within the boxfile.yml, then will rely on default_runtime to
# provide a sensible default
runtime() {
  echo $(nos_validate \
    "$(nos_payload "config_runtime")" \
    "string" "$(default_runtime)")
}

# Provide a default python version.
default_runtime() {
  echo "python-2.7"
}

# The pip package will look something like py27-pip so
# we need to fetch the condensed runtime to use for the package
condensed_runtime() {
  version=$(runtime)
  echo "${version//[.thon-]/}"
}

# Install the python runtime along with any dependencies.
install_runtime_packages() {
  pkgs=("$(runtime)" "$(condensed_runtime)-pip")

  # add any client dependencies
  pkgs+=("$(query_dependencies)")

  nos_install ${pkgs[@]}
}

# Uninstall build dependencies
uninstall_build_packages() {
  # currently python doesn't install any build-only deps... I think
  pkgs=()

  # if pkgs isn't empty, let's uninstall what we don't need
  if [[ ${#pkgs[@]} -gt 0 ]]; then
    nos_uninstall ${pkgs[@]}
  fi
}

# compiles a list of dependencies that will need to be installed
query_dependencies() {
  deps=()

  # # mysql
  # if [[ `cat $(nos_code_dir)/Gemfile | grep 'mysql'` ]]; then
  #   deps+=(mysql-client)
  # fi
  # # memcache
  # if [[ `cat $(nos_code_dir)/Gemfile | grep 'memcache'` ]]; then
  #   deps+=(libmemcached)
  # fi
  # # postgres
  # if [[ `cat $(nos_code_dir)/Gemfile | grep 'pg'` ]]; then
  #   deps+=(postgresql94-client)
  # fi

  echo "${deps[@]}"
}

# Install dependencies via pip from requirements.txt
pip_install() {
  if [[ -f $(nos_code_dir)/requirements.txt ]]; then

  cd $(nos_code_dir)
  nos_run_process "Running pip install" \
    "pip install -I -r requirements.txt"
  cd - >/dev/null
fi
}
