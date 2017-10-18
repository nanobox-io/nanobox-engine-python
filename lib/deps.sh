# compiles a list of dependencies that will need to be installed
query_dependencies() {
  
  # break early if there isn't a requirements.txt
  if [[ ! -f $(nos_code_dir)/requirements.txt ]]; then
    echo ""
    return
  fi
  
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

  echo "${deps[@]}"
}
