# Python

## Advanced Configuration Options
This engine exposes configuration options through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

#### Overview of Boxfile Config Options
```yaml
build:
  # Python Settings
  python_runtime: python27
  
  # Node.js Runtime Settings
  nodejs_runtime: nodejs-0.12
  
  # Gunicorn Settings
  app_module: ''
  gunicorn_backlog: 2048
  gunicorn_workers: 1
  gunicorn_worker_class: sync
  gunicorn_threads: 1
  gunicorn_worker_connections: 1000
  gunicorn_max_requests: 1024
  gunicorn_max_requests_jitter: 128
  gunicorn_timeout: 30
  gunicorn_graceful_timeout: 30
  gunicorn_keepalive: 15
  gunicorn_limit_request_line: 4094
  gunicorn_limit_request_fields: 100
  gunicorn_limit_request_field_size: 8190
  gunicorn_spew: False
  gunicorn_preload_app: True
  gunicorn_sendfile: True
  gunicorn_loglevel: info
```

##### Quick Links
[Python Settings](#python-settings)  
[Node.js Runtime Settings](#nodejs-runtime-settings)  
[Gunicorn Settings](#gunicorn-settings)  

### Python Settings
The following setting allows you to define your Python runtime environment.

---

#### python_runtime
Specifies which Python runtime and version to use. The following runtimes are available:

- python27
- python34

```yaml
build:
  python_runtime: python27
```

---

### Node.js Runtime Settings
Many applications utilize Javascript tools in some way. This engine allows you to specify which Node.js runtime you'd like to use.

---

#### nodejs_runtime
Specifies which Node.js runtime and version to use. The following runtimes are available:

- nodejs-0.8
- nodejs-0.10
- nodejs-0.12
- nodejs-4.2
- iojs-2.3

```yaml
build:
  nodejs_runtime: nodejs-4.2
```

---

### Gunicorn Settings
The following settings allow you to configure Gunicorn.

[app_module](#app_module)  
[gunicorn_backlog](#gunicorn_backlog)  
[gunicorn_workers](#gunicorn_workers)  
[gunicorn_worker_class](#gunicorn_worker_class)  
[gunicorn_threads](#gunicorn_threads)  
[gunicorn_worker_connections](#gunicorn_worker_connections)  
[gunicorn_max_requests](#gunicorn_max_requests)  
[gunicorn_max_requests_jitter](#gunicorn_max_requests_jitter)  
[gunicorn_timeout](#gunicorn_timeout)  
[gunicorn_graceful_timeout](#gunicorn_graceful_timeout)  
[gunicorn_keepalive](#gunicorn_keepalive)  
[gunicorn_limit_request_line](#gunicorn_limit_request_line)  
[gunicorn_limit_request_fields](#gunicorn_limit_request_fields)  
[gunicorn_limit_request_field_size](#gunicorn_limit_request_field_size)  
[gunicorn_spew](#gunicorn_spew)  
[gunicorn_preload_app](#gunicorn_preload_app)  
[gunicorn_sendfile](#gunicorn_sendfile)  
[gunicorn_loglevel](#gunicorn_loglevel)  

---

#### app_module
Of the pattern `$(MODULE_NAME):$(VARIABLE_NAME)`. The module name can be a full dotted path. The variable name refers to a WSGI callable that should be found in the specified module.
```yaml
# Example
build:
  app_module: 'test:app'
```

---

#### gunicorn_backlog
The maximum number of pending connections. More details are available in the [Official Gunicorn `backlog` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#backlog).
```yaml
build:
  gunicorn_backlog: 2048
```

---

#### gunicorn_workers
The number of worker processes for handling requests. More details are available in the [Official Gunicorn `workers` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#workers).
```yaml
build:
  gunicorn_workers: 1
```

---

#### gunicorn_worker_class
The type of workers to use. More details are available in the [Official Gunicorn `worker_class` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#worker-class).
```yaml
build:
  gunicorn_worker_class: sync
```

---

#### gunicorn_threads
The number of worker threads for handling requests. More details are available in the [Official Gunicorn `threads` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#threads).
```yaml
build:
  gunicorn_threads: 1
```

---

#### gunicorn_worker_connections
The maximum number of simultaneous clients. More details are available in the [Official Gunicorn `worker_connections` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#worker-connections).
```yaml
build:
  gunicorn_worker_connections: 1000
```

---

#### gunicorn_max_requests
The maximum number of requests a worker will process before restarting. More details are available in the [Official Gunicorn `max_requests` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#max-requests).
```yaml
build:
  gunicorn_max_requests: 1024
```

---

#### gunicorn_max_requests_jitter
The maximum jitter to add to the max-requests setting. More details are available in the [Official Gunicorn `max_requests_jitter` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#max-requests-jitter). 
```yaml
build:
  gunicorn_max_requests_jitter: 128
```

---

#### gunicorn_timeout
Workers silent for more than this many seconds are killed and restarted. More details are available in the [Official Gunicorn `timeout` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#timeout).
```yaml
build:
  gunicorn_timeout: 30
```

---

#### gunicorn_graceful_timeout
Timeout for graceful workers restart. More details are available in the [Official Gunicorn `graceful_timeout` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#graceful-timeout).
```yaml
build:
  gunicorn_graceful_timeout: 30
```

---

#### gunicorn_keepalive
The number of seconds to wait for requests on a Keep-Alive connection. More details are available in the [Official Gunicorn `keepalive` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#keepalive)
```yaml
build:
  gunicorn_keepalive: 15
```

---

#### gunicorn_limit_request_line
The maximum size of HTTP request line in bytes. More details are available in the [Official Gunicorn `limit_request_line` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#limit-request-line).
```yaml
build:
  gunicorn_limit_request_line: 4094
```

---

#### gunicorn_limit_request_fields
Limit the number of HTTP headers fields in a request. More details are available in the [Official Gunicorn `limit_request_fields` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#limit-request-fields).
```yaml
build:
  gunicorn_limit_request_fields: 100
```

---

#### gunicorn_limit_request_field_size
Limit the allowed size of an HTTP request header field. More details are available in the [Official Gunicorn `limit_request_field_size` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#limit-request-fields).
```yaml
build:
  gunicorn_limit_request_field_size: 8190
```

---

#### gunicorn_spew
Install a trace function that spews every line executed by the server. More details are available in the [Official Gunicorn `spew` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#spew).
```yaml
build:
  gunicorn_spew: False
```

---

#### gunicorn_preload_app
Load application code before the worker processes are forked. More details are available in the [Official Gunicorn `preload_app` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#preload-app)
```yaml
build:
  gunicorn_preload_app: True
```

---

#### gunicorn_sendfile
Enables or disables the use of `sendfile()`. More details are available in the [Official Gunicorn `sendfile` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#sendfile).
```yaml
build:
  gunicorn_sendfile: True
```

---

#### gunicorn_loglevel
The granularity of Error log outputs. More details are available in the [Official Gunicorn `loglevel` Documentation](https://gunicorn-docs.readthedocs.org/en/19.3/settings.html#loglevel).
```yaml
build:
  gunicorn_loglevel: info
```

---

## Help & Support
This is a generic (non-framework-specific) Python engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/pagodabox/nanobox-engine-python/issues/new).
