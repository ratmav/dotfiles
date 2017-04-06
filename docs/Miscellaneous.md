# Passwordless `sudo`

## Modify the Sudoers File:

```bash
$ sudo visudo
```

>Add the Following Content:

>>```bash
# Passwordless sudo for your-user for all commands.
your-user ALL=(ALL) NOPASSWD: ALL
```

**NOTE**: This is a lax security policy, and should be implemented judiciously. It's more reasonable to observe the principle of least privilege, which would usually be implemented as only whitelisting the exact commands a given user needs to run with escalated permissions.

# VirtualBox

## All SSL Certificates are Expiring

This is probably due to the VM syncing it's clock with host hardware, and running into problems. Time sync is an ongoing virtualization issue. The fix here is to just disable guest sync with the host clock:

```bash
VBoxManage setextradata "VM name" "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled" 1
```
