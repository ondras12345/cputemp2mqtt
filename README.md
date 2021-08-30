# cputemp2mqtt
Periodically report CPU temperature average to a MQTT broker.

This is a very simple shell script that I use to report my Raspberry Pi's CPU
temperature to my Home Assistant instance.

It takes CPU temperature samples at a given rate and reports the average to a
MQTT broker every n-th sample. This should help smooth out random spikes,
because it allows you to sample the CPU temperature more frequently while
keeping a relatively long period between reports.


## Usage
The script is started by systemd in normal use. However, it can also be
started manually:
```console
$ ./cputemp2mqtt -h
Usage: ./cputemp2mqtt [-v] {-f config_file |
                            {SAMPLING_PERIOD REPORT_PERIOD
                             [args_for_mosquitto_pub]}
                           }

-v : verbose mode -- echo debug messages to stderr
-f config_file : read configuration from file
SAMPLING_PERIOD : how often (in seconds) should CPU temperature be read
REPORT_PERIOD : report average temperature every n-th sample
args_for_mosquitto_pub (examples):
    -h hostname
    -p port-number
    -t message-topic
    -u username
    -P password
    ... (see man mosquitto_pub)
    Avoid using the -u and -P arguments because it leaks secrets through the
    process name. Use ~/.config/mosquitto_pub instead.
```

Script running with verbose mode on:
```console
$ cputemp2mqtt -v 1 5 -t rpi/cpu_temperature
Verbose mode is on
SAMPLING_PERIOD: 1
REPORT_PERIOD: 5
MOSQUITTO_PARAMS: -t rpi/cpu_temperature
New sample: 45'C; array:  457
New sample: 46'C; array:  457 462
New sample: 46'C; array:  457 462 462
New sample: 46'C; array:  457 462 462 467
New sample: 44'C; array:  457 462 462 467 447
New average: 45.9
New sample: 45'C; array:  457
New sample: 44'C; array:  457 447
New sample: 45'C; array:  457 447 457
New sample: 45'C; array:  457 447 457 452
New sample: 46'C; array:  457 447 457 452 462
New average: 45.5
...
```
The verbose mode output is only helpful for debugging purposes.

The `New sample: xx'C` message only shows the integer part of the sample,
but it is in fact a decimal number. This can be seen in the `array`, where the
sample multiplied by 10 is stored. This could use some improvement...


## Installation
```sh
# install the script, it's config file and systemd unit file
sudo make install
# reload systemd units
sudo systemctl daemon-reload

# Edit /etc/cputemp2mqtt

# enable and start the systemd service
sudo systemctl enable --now cputemp2mqtt.service
```

## Configuration
A configuration file can be specified using the `-f` flag. This file is
sourced during the script's startup. See example configuration file
[`cputemp2mqtt.conf`](./cputemp2mqtt.conf).


## Systemd
You can use the systemd unit file
[`cputemp2mqtt.service`](./cputemp2mqtt.service) to make this start
automatically. The default configuration file is `/etc/cputemp2mqtt`.
