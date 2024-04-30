# My tmux plugins collection

This plugin is a collection of simple status-right widgets.
It is a replacement of the standard plugins like netspeed, sysstat.

The motivation to create yet another plugins is a simplicity.

## Installation

Download this repository and call run-shell from the `tmux.conf` configuration file:
```
run-shell /path/to/repo/mycollection.tmux
```

## Usage

Add to `status-right` necessary widgets:

* `#{net}` to show network speed statistics;
* `#{load}` to show the average number of jobs in the run queue over the last 1 minute;
* `#{mem}` to show memory usage statistics.

## Example

Status line in the tmux configuration file:
```
set -g status-right '#{load} #{mem} #{net} | %a %Y-%m-%d %H:%M | #H'
```

The result:
```
0.16 3.5G/15.6G[0.1G] ▼ 1Kib   ▲ 1Kib    | Tue 2024-04-30 13:15 | ginnungagap
```
* `0.16` is a load average for 1 minute.
It supports color ranges green, yellow and red by internal thresholds.
* `3.5G/15.6G[0.1G]` is a memory usage statistic.
It supports colorization by internal thresholds.
    * `3.5G` is a used memory;
    * `15.6G` is a total memory;
    * `[0.1G]` is a swap used memory.
    It has a separated colorization.
* `▼ 1Kib   ▲ 1Kib` is a network speed statistic.
Symbol `▼` denotes a download speed and `▲` is an upload speed.
Speed suffix is assigned automatically.

## Under the hood

The network widget uses `sysfs` to get the current transmitted and received bytes.
To store the previous values the tmux @-variables are used.
The `status-interval` shows the elapsed time between calls and it should not to be a zero.

The memory widget uses `/proc/meminfo` to get free, total and swap memory statistics.

The load widget uses `/proc/loadavg` to get the average number of jobs over the last
1 minute.
