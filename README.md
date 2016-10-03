# Python

This is a Python engine for developing python apps on [Nanobox](http://nanobox.io).

## Usage
To use the Python engine, specify `python` as your `engine` in your boxfile.yml

```yaml
code.build:
  engine: python
```

## Configuration Options
This engine exposes configuration options through the [boxfile.yml](http://docs.nanobox.io/app-config/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

### Python Settings
The following setting allows you to define your Python runtime environment.

#### runtime
Specifies which Python runtime and version to use. The following runtimes are available:

- python-2.7
- python-3.4
- python-3.5

```yaml
code.build:
  config:
    runtime: python-3.5
```

## Help & Support
This is a Python engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/pagodabox/nanobox-engine-python/issues/new).
