# Installation

## Verify the CPU and BIOS KVM Support

```bash
$ sudo egrep -c '(vmx|svm)' /proc/cpuinfo
```

**NOTE**:Output should be “1” or greater.

## Install Packages

```bash
$ sudo yum install -y qemu-kvm libvirt libvirt-python libguestfs-tools virt-install
```

## Enable and Start `libvirt`

```bash
$ sudo systemctl enable libvirtd && systemctl start libvirtd
```

## Verify Kernel Modules

```bash
$ sudo lsmod | grep kvm
```

**NOTE**: Should see results for `kvm` and `kvm_intel` (on Intel hardware).

## Network Bridge

### Host-Only Bridge

**TODO**

### Bridge to LAN

#### Bridge Ethernet Interface

**NOTE**: Assumes wired interface's identifier is `em1`. Verify the identifier for the interface being bridged via `ip addr show`.

Add `BRIDGE=br0` to the end of `/etc/sysconfig/network-scripts/ifcfg-em1`.

#### Add Bridge to Network Scripts

Add the following to `/etc/sysconfig/network-scripts/ifcfg-br0`:

```bash
DEVICE="br0"
BOOTPROTO="dhcp"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
ONBOOT="yes"
TYPE="Bridge"
DELAY="0"
```

### Enable Network Forwarding

Add `net.ipv4.ip_forward = 1` to `/etc/sysctl.conf`, then read the configuration:

```bash
$ sudo sysctl -p /etc/sysctl.conf
```

### Restart Network Manager

```bash
$ sudo systemctl restart NetworkManager
```
**NOTE**: For the bridge to be usable by guests, a reboot may be required.

## Storage Pools

### Create Pool Directories

```bash
$ mkdir /home/deployment-user/kvm_storage
$ sudo virsh pool-build isos # Bootable OS ISO images go here.
$ sudo virsh pool-build images # Guest disk images, including "golden" images go here.
```

**NOTE**: Any files moved into the `kvm_storage/images` or `kvm_storage/isos` directories will be automagically chwon'd by root.

### Define Storage Pools

```bash
$ sudo virsh pool-define-as isos dir - - - - "/home/deployment-user/kvm_storage/isos"
$ sudo virsh pool-define-as images dir - - - - "/home/deployment-user/kvm_storage/images"
```

### Autostart Storage Pools

```bash
$ sudo virsh pool-autostart isos
$ sudo virsh pool-autostart images
```

### Start Storage Pools

```bash
$ sudo virsh pool-start isos
$ sudo virsh pool-start images
```
