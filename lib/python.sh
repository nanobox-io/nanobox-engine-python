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
  
  # add packages that are usually part of the stdlib
  pkgs+=(\
    "$(condensed_runtime)-cElementTree" \
    "$(condensed_runtime)-curses" \
    "$(condensed_runtime)-expat" \
    "$(condensed_runtime)-readline" \
    "$(condensed_runtime)-sqlite3")
  
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
  if [[ `grep -i 'pymssql' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(freetds)
  fi
  # mysql
  if [[ `grep -i 'MySQLdb\|mysqlclient\|MySQL-python' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(mysql-client)
  fi
  # memcache
  if [[ `grep -i 'memcache\|libmc' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(libmemcached)
  fi
  # postgres
  if [[ `grep -i 'psycopg2' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(postgresql94-client)
  fi
  # redis
  if [[ `grep -i 'redis' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(redis)
  fi
  # curl
  if [[ `grep -i 'pycurl' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(curl)
  fi
  # pillow
  if [[ `grep -i 'pillow' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(libjpeg-turbo tiff zlib freetype2 lcms2 libwebp tcl tk)
  fi
  # boto3
  if [[ `grep -i 'boto3' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=("$(condensed_runtime)-cElementTree")
  fi
  # xmlsec
  if [[ `grep -i 'xmlsec' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(libxml2 libxslt xmlsec1 pkgconf)
  fi
  # python3-saml
  if [[ `grep -i 'python3-saml' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(libxml2 libxslt xmlsec1 pkgconf)
  fi
  # pygraphviz
  if [[ `grep -i 'pygraphviz' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(libxshmfence libva libvdpau libLLVM-3.8 graphviz)
  fi
  # scipy
  if [[ `grep -i 'scipy' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(blas lapack)
  fi
  # paypalrestsdk
  if [[ `grep -i 'paypalrestsdk' $(nos_code_dir)/requirements.txt` ]]; then
    deps+=(libffi)
  fi

  echo "${deps[@]}"
}

# set any necessary python environment variables
setup_python_env() {
  # ensure python doesn't buffer even when not attached to a pty
  nos_template_file \
    "env.d/PYTHONUNBUFFERED" \
    "$(nos_etc_dir)/env.d/PYTHONUNBUFFERED"
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
