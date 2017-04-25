*NOTE*: For more information, take a look at [The Hitchhiker's Guide to Python](http://docs.python-guide.org/en/latest/)

# Install

## macOS

```bash
$ brew install python
$ pip install virtualenv virtualenvwrapper pep8
```

# Notes

## Reload Classes in the Interpreter

### 2.7

```bash
$ python
>>> import module.submodule
>>> foo = module.submodule.YourClass()
>>> foo.version()
v1
>>> reload(module.submodule)
>>> foo = module.submodule.YourClass()
>>> foo.version()
v2
```
