# Python

This is a generic Python engine used to launch Python web and worker services when using [Nanobox](http://nanobox.io).

```yaml
build:
  runtime: python27
  js_runtime: nodejs-0.12
  app_module: ""
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