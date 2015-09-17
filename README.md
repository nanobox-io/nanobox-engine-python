# Python

This is a generic Python engine used to launch Python web and worker services when using [Nanobox](http://nanobox.io).

## App Detection
To detect a Python app, this engine looks for a `requirements.txt`.

## Build Process
- Installs `virtualenv` to create an isolated Python environment in which to build code.
- In the Python environment, the engine installs requirements by running `pip install -r requirements.txt`. Requirements are installed in the project rather than globally.

## Important Things to Know
- In order for the enine to know how to start the app, you must provide the [`app_module`](#app_module) or a [`exec` in your web config](http://docs.nanobox.io/boxfile/code-services/#exec).
- This engine uses the Gunicorn web server. Granular Gunicorn config settings are available in the [Advance Config Options](https://github.com/pagodabox/nanobox-engine-python/blob/master/doc/advanced-python-config.md#gunicorn-settings).

## Basic Configuration Options
This engine exposes configuration options through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

##### *Advanced Configuration Options*
This Readme outlines only the most basic and commonly used settings. For the full list of available configuration options, view the **[Advanced Python Configuration options](https://github.com/pagodabox/nanobox-engine-python/blob/master/doc/advanced-python-config.md)**.

#### Overview of Basic Boxfile Config Options
```yaml
build:
  runtime: python27
  js_runtime: nodejs-0.12
  app_module: ''
```

##### Quick Links
[Pyton Settings](#python-settings)  
[JS Runtime Settings](#js-runtime-settings)  
[Gunicorn Settings](#gunicorn-settings)  

### Python Settings
The following setting allows you to define your Python runtime environment.

---

##### `runtime`
Specifies which Python runtime and version to use. The following runtimes are available:

- python27
- python 34

```yaml
build:
  runtime: python27
```

---

### JS Runtime Settings
Many applications utilize Javascript tools in some way. This engine allows you to specify which JS runtime you'd like to use.

---

##### `js_runtime`
Specifies which JS runtime and version to use. The following runtimes are available:

- nodejs-0.8
- nodejs-0.10
- nodejs-0.12
- iojs-2.3

```yaml
build:
  js_runtime: nodejs-0.12
```

---

### Gunicorn Settings
The following settings allow you to configure Gunicorn.

---

##### `app_module`
Of the pattern `$(MODULE_NAME):$(VARIABLE_NAME)`. The module name can be a full dotted path. The variable name refers to a WSGI callable that should be found in the specified module.
```yaml
# Example
build:
  app_module: 'test:app'
```

---

## Help & Support
This is a generic (non-framework-specific) Python engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/pagodabox/nanobox-engine-python/issues/new).
