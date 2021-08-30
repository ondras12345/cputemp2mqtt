# cputemp2mqtt
Periodically report CPU temperature average to a MQTT broker.

## Installation
```
sudo make install
sudo systemctl daemon-reload
sudo systemctl enable --now cputemp2mqtt.service
```

## Configuration
A configuration file can be specified using the `-f` flag. This file is
sourced during the script's startup. See example configuration file in
`cputemp2mqtt.conf`.


## Systemd
You can use the systemd unit file `cputemp2mqtt.service` to make this start
automatically. The default configuration file is `/etc/cputemp2mqtt`.
