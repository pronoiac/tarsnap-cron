## Usage

1. Copy .sh files into /usr/local/bin
2. `chmod 755 /usr/local/bin/tarsnap-*`
3. cp *.timer *.service /etc/systemd/system
4. run the following on all the timer files

```
systemctl start /etc/systemd/system/{file}.timer
systemctl enable /etc/systemd/system/{file}.timer
```

`systemctl start` begins the timer on this boot, and the `systemctl enable`
will start the timer on a subsequent boot.

## Systemd Timers

A good resource for learning more about systemd timers is
[here](https://wiki.archlinux.org/index.php/Systemd/Timers).

## Testing

Tested on Arch Linux, July 2015

