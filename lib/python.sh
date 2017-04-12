# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live app directory..."
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
  pkgs=("$(runtime)" "$(condensed_runtime)-setuptools" "$(condensed_runtime)-pip")
  
  # readline and sqlite are needed for most projects
  pkgs+=("$(condensed_runtime)-readline" "$(condensed_runtime)-sqlite3")

  # add any client dependencies
  pkgs+=("$(query_dependencies)")

  nos_install ${pkgs[@]}
}

# Uninstall build dependencies
uninstall_build_packages() {
  pkgs=("$(condensed_runtime)-pip")

  # if pkgs isn't empty, let's uninstall what we don't need
  if [[ ${#pkgs[@]} -gt 0 ]]; then
    nos_uninstall ${pkgs[@]}
  fi
}

# compiles a list of dependencies that will need to be installed
query_dependencies() {
  deps=()

  # mssql
  if [[ `grep -Pa 'p\00?y\00?m\00?s\00?s\00?q\00?l' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(freetds)
  fi
  # mysql
  if [[ `grep -Pa 'M\00?y\00?S\00?Q\00?L\00?d\00?b\|m\00?y\00?s\00?q\00?l\00?c\00?l\00?i\00?e\00?n\00?t' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(mysql-client)
  fi
  # memcache
  if [[ `grep -Pa 'm\00?e\00?m\00?c\00?a\00?c\00?h\00?e\|l\00?i\00?b\00?m\00?c' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(libmemcached)
  fi
  # postgres
  if [[ `grep -Pa 'p\00?s\00?y\00?c\00?o\00?p\00?g\00?2' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(postgresql94-client)
  fi
  # redis
  if [[ `grep -Pa 'r\00?e\00?d\00?i\00?s' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(redis)
  fi
  
  echo "${deps[@]}"
}

# fetch the user-specified pip install command or use a default
pip_install_cmd() {
  echo $(nos_validate \
    "$(nos_payload "config_pip_install")" \
    "string" "$(default_pip_install)")
}

# the default pip install cmd when a user-specified cmd is not present
default_pip_install() {
  echo "pip install -I -r requirements.txt"
}

# Install dependencies via pip from requirements.txt
pip_install() {
  if [[ -f $(nos_code_dir)/requirements.txt ]]; then
    cd $(nos_code_dir)
    nos_run_process "Running pip install" \
      "$(pip_install_cmd)"
    cd - >/dev/null
  fi
}
