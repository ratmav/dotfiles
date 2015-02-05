# GNOME Extension Plugin for Firefox

## Use

Normally, GNOME ships with Firefox and this plugin already installed. However, if you use Firefox's developer edition and remove the regular Firefox package, you have to manually install this plugin if you want to use GNOME extensions.

## File Location

This file is meant to be stored at `~/.mozilla/plugins/libgnome-shell-browser-plugin.so`.

## Supported Platforms

This plugin is for Fedora 21 x86_64 using GNOME v.3.14.2.

## Finding the Plugin for Your Platform

You may have the correct file location on your system somewhere, but it could be easier to just find the gnome-shell RPM package for your system (check the processor architecture, Fedora version, and GNOME version t ofind the right package). Once you have the RPM locally, you can extract the files from it like this:

```bash
  rpm2cpio ./gnome-shell-proper.version.fcVersion.arch.rpm | cpio -idmv
```

The above command should extract a `usr` directory, which you can `grep` to find the `libgnome-shell-browser-plugin.so` package.
