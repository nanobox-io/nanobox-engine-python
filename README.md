# Python

This is a Python engine used to launch Python web and worker services when using [Nanobox](http://nanobox.io).

## Usage
To use the Python engine, specify `python` as your `engine` in your boxfile.yml

```yaml
code.build:
  engine: python
```

## Build Process
When [running a build](https://docs.nanboox.io/cli/build/), this engine compiles code by doing the following:

- Installs `virtualenv` to create an isolated Python environment in which to build code.
- In the Python environment, the engine installs requirements by running `pip install -r requirements.txt`. Requirements are installed in the project rather than globally.

## Configuration Options
This engine exposes configuration options through the [boxfile.yml](http://docs.nanobox.io/app-config/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

#### Overview of Boxfile Config Options
```yaml
code.build:
  config:
    runtime: python27
    nodejs_runtime: nodejs-4.4
```

##### Quick Links
[Python Settings](#python-settings)  
[Node.js Settings](#nodejs-settings)  

### Python Settings
The following setting allows you to define your Python runtime environment.

---

#### runtime
Specifies which Python runtime and version to use. The following runtimes are available:

- python27
- python34
- python35

```yaml
code.build:
  config:
    runtime: python27
```

---

### Node.js Settings
Many applications utilize Javascript tools in some way. This engine allows you to specify which Node.js runtime you'd like to use.

---

#### nodejs_runtime
Specifies which Node.js runtime and version to use. You can view the available Node.js runtimes in the [Node.js engine documentation](https://github.com/nanobox-io/nanobox-engine-nodejs#runtime).

```yaml
code.build:
  config:
    nodejs_runtime: 'nodejs-4.4'
```

---

## Help & Support
This is a Python engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/pagodabox/nanobox-engine-python/issues/new).
