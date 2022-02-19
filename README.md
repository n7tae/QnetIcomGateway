QnetIcomGateway for the ICOM Stack
==================================

**This repo has been archived!** Please see new new version, [IcomGateway](https://github.com/n7tae/IcomGateway "A superior IRC gateway for the Icom repeater").

The QnetIcomGateway is an D-Star IRCDDB gateway application that supports the Icom D-Star repeater. It is *incredibly easy* to build and install the system.

The QnetIcomGateway program supports up to three modules: the 23cm, the 70cm and the 2M voice modules. (Sorry, the 23cm data module is not supported). Ideally this will be installed on a Debian-based distribution running on a computer with two Ethernet ports. One port will be connected to the world and the other port will be connected to the Icom Stack. This software will not configure you Stack, you will still need the Icom software for configuration you hardware (frequencies and offsets).

QnetIcomGateway fully supports DTMF and is implemented in a script which can be modified to add new capabilities to your system. QnetIcomGateway also has a very powerful external command interface that can be triggered via RF transmission (access to this feature can be controlled by a "white-list"). Several Example scripts are supplied. QnetGateway allows outbound DCS, DExtra or D-Plus linking. It also supports inbound D-Plus linking, and of course, all linking is fully configurable through a white-list or black-list. Linking to the legacy, closed-source D-Plus network is supported, and this requires a valid USTrust login callsign.

To get started, clone the software to your Linux device:

```bash
git clone git://github.com/n7tae/QnetIcomGateway.git
```

Then look to the CONFIG+INSTALL file for more information. (You'll use ./qnconfig to build your configuration file, and then you'll use ./qnadmin to create your gwys.txt gateway file database, and then install and maintain your QnetGateway system).

QnetIcomGateway includes a "remote control" program, called `qnremote`. After you build and install the system, type `qnremote` for a prompt on how to use it. Using this and cron, it's possible to setup schedules where you system will automatically link up to a reflector, or subscribe to a Routing Group. For More information, see DTMF+REMOTE.README.

For other details of interesting things QnetIcomGateway can do, see the OPERATING file. For example, with QnetIcomGateway, you can execute up to 36 different Linux scripts from you radio. Two scripts are include:

```text
YourCall = "      HX"   will halt your system.
YourCall = "      RX"   will reboot your system.
YourCall - "      GX"   will restart QnetGateway
```

QnetGateway is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation. QnetGateway is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the LICENSE file for more details.

QnetIcomGateway is brought to you by the folks at **QuadNet2 USA IRC Network**, and is fully compatible with all Routing methodologies.

73

Tom

N7TAE (at) arrl (dot) net
