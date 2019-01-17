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

## Autoload Virtualenv from Script

*NOTE*: Works on 2.7 and 3.6

```python
#!/usr/bin/env python


# Force virtualenv.
import os
directory = os.path.dirname(os.path.abspath(__file__))
activate = os.path.join(directory, '../.your-project_env/bin/activate_this.py')
execfile(activate, dict(__file__=activate))


# Your code here...
```
