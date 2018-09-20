macOS
=====

# Keep Network Interfaces Up When Locked

Of course, taken from [Stack Overflow](https://apple.stackexchange.com/questions/71884/wi-fi-disconnects-when-i-lock-the-mac#97047)....

```bash
# after getting the mac of the wifi interface, get the name of the interface.
$ ifconfig

# set "DisconnectOnLogout" to "NO".
sudo ./airport $INTERFACE_NAME_PROBABLY_en0 prefs DisconnectOnLogout=NO
```
