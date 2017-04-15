# ClamAV

## Install

```bash
$ sudo dnf install -y clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
```

## Configure SELinux

```bash
$ sudo setsebool -P antivirus_can_scan_system 1
```

## Configure `clamd*`

### Config File

#### Copy Config File

```bash
$ sudo cp /usr/share/clamav/template/clamd.conf /etc/clamd.d/clamd.conf
$ sudo sed -i '/^Example/d' /etc/clamd.d/clamd.conf
```

#### Modify Config File

##### `User`

###### Before

```bash
User <USER>
```

###### After

```bash
User clamscan
```

##### `LocalSocket`

###### Before

```bash
#LocalSocket /var/run/clamd.<SERVICE>/clamd.sock
```

###### After

```bash
LocalSocket /var/run/clamd.scan/clamd.sock
```

### Rename `clamd*` Services

```bash
$ cd /usr/lib/systemd/system
$ sudo mv clamd@.service clamd.service
$ sudo mv clamd@scan.service clamdscan.service
```

### Update `clamdscan` Service

**NOTE**: The only change is removing the `@` from the top level include statement.

#### Before

```bash
.include /lib/systemd/system/clamd@.service
```

#### After

```bash
.include /lib/systemd/system/clamd.service
```

### Update `clamd` Service

Replace the contents of `/usr/lib/systemd/system/clamd.service` with:

```bash
[Unit]
Description = clamd scanner daemon
After = syslog.target nss-lookup.target network.target
[Service]
Type = simple
ExecStart = /usr/sbin/clamd -c /etc/clamd.d/clamd.conf --foreground=yes
Restart = on-failure
PrivateTmp = true

[Install]
WantedBy=multi-user.target
```

### Enable and Start `clamd*` Services

```bash
$ sudo systemctl enable clamd.service
$ sudo systemctl start clamd.service
$ sudo systemctl enable clamdscan.service
$ sudo systemctl start clamdscan.service

```

**NOTE**: This is _performance intensive_. It's going to CONSTANTLY scan the whole system. Budgeting hardware resources for this is probably worth it on an exposed production system, but internal systems may be better off with these services installed for convenience, but stopped and disabled most of the time. YMMV.


## Configure `freshclam`

```bash
$ sudo sed -i '/^Example/d' /etc/freshclam.conf
```

### Create `freshclam` Service

Write the following content to `/usr/lib/systemd/system/freshclam.service`:

```bash
# Run the freshclam as daemon
[Unit]
Description = freshclam scanner
After = network.target
[Service]
Type = forking
ExecStart = /usr/bin/freshclam -d -c 4
Restart = on-failure
PrivateTmp = true
[Install]
WantedBy=multi-user.target
```

### Enable and Start `freshclam` Service

```bash
$ sudo systemctl enable freshclam.service
$ sudo systemctl start freshclam.service
```
