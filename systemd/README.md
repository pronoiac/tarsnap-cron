## Usage

1. Copy .sh files into /usr/local/bin
2. chmod 777 /usr/local/bin/tarnsap-archive*
3. cp *.timer *.service /etc/sysytemd/system
4. run the following on all the timer files

```
systemctl start /etc/systemd/system/{file}.timer
systemctl enable /etc/systemd/system/{file}.timer
```

`systemctl start` begins the timer on this boot, and the `systemctl enable` will start the timer on a subsequent boot.

## Testing

Tested on Arch Linux, July 2015
