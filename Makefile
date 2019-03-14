# Copyright (c) 2018-2019 by Thomas A. Early N7TAE
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# locations for the executibles and other files are set here
# NOTE: IF YOU CHANGE THESE, YOU WILL NEED TO UPDATE THE service.* FILES AND
# if you change these locations, make sure the sgs.service file is updated!

BINDIR=/usr/local/bin
CFGDIR=/usr/local/etc
SYSDIR=/lib/systemd/system
IRC=ircddb

# use this if you want debugging help in the case of a crash
#CPPFLAGS=-g -ggdb -W -Wall -std=c++11 -Iircddb -DCFG_DIR=\"$(CFGDIR)\"

# or, you can choose this for a much smaller executable without debugging help
CPPFLAGS=-W -Wall -std=c++11 -Iircddb -DCFG_DIR=\"$(CFGDIR)\"

LDFLAGS=-L/usr/lib -lrt

DSTROBJS = $(IRC)/dstar_dv.o $(IRC)/golay23.o
IRCOBJS = $(IRC)/IRCDDB.o $(IRC)/IRCClient.o $(IRC)/IRCReceiver.o $(IRC)/IRCMessageQueue.o $(IRC)/IRCProtocol.o $(IRC)/IRCMessage.o $(IRC)/IRCDDBApp.o $(IRC)/IRCutils.o $(DSTROBJS)
SRCS = $(wildcard *.cpp) $(wildcard $(IRC)/*.cpp)
OBJS = $(SRCS:.cpp=.o)
DEPS = $(SRCS:.cpp=.d)

PROGRAMS=qngateway qnlink qnremote qnvoice

all : $(PROGRAMS)

qngateway : $(IRCOBJS) QnetGateway.o QnetConfigure.o aprs.o
	g++ $(CPPFLAGS) -o qngateway QnetGateway.o QnetConfigure.o aprs.o $(IRCOBJS) $(LDFLAGS) -pthread

qnlink : QnetLink.o QnetConfigure.o DPlusAuthenticator.o TCPReaderWriterClient.o
	g++ $(CPPFLAGS) -o qnlink QnetLink.o QnetConfigure.o DPlusAuthenticator.o TCPReaderWriterClient.o $(LDFLAGS) -pthread

qnremote : QnetRemote.o QnetConfigure.o
	g++ $(CPPFLAGS) -o qnremote QnetRemote.o QnetConfigure.o $(LDFLAGS)

qnvoice : QnetVoice.o QnetConfigure.o
	g++ $(CPPFLAGS) -o qnvoice QnetVoice.o QnetConfigure.o $(LDFLAGS)

%.o : %.cpp
	g++ $(CPPFLAGS) -MMD -MD -c $< -o $@

.PHONY: clean

clean:
	$(RM) $(OBJS) $(DEPS) $(PROGRAMS) *.gch

-include $(DEPS)

install : $(PROGRAMS) gwys.txt qn.cfg
	######### QnetGateway #########
	/bin/cp -f qngateway $(BINDIR)
	/bin/cp -f qnremote qnvoice $(BINDIR)
	/bin/ln -s $(shell pwd)/qn.cfg $(CFGDIR)
	/bin/cp -f system/qngateway.service $(SYSDIR)
	systemctl enable qngateway.service
	systemctl daemon-reload
	systemctl start qngateway.service
	######### QnetLink #########
	/bin/cp -f qnlink $(BINDIR)
	/bin/cp -f announce/*.dat $(CFGDIR)
	/bin/ln -s $(shell pwd)/gwys.txt $(CFGDIR)
	/bin/cp -f exec_?.sh $(CFGDIR)
	/bin/cp -f system/qnlink.service $(SYSDIR)
	systemctl enable qnlink.service
	systemctl daemon-reload
	systemctl start qnlink.service

installdtmf : qndtmf
	/bin/ln -s $(shell pwd)/qndtmf $(BINDIR)
	/bin/cp -f system/qndtmf.service $(SYSDIR)
	systemctl enable qndtmf.service
	systemctl daemon-reload
	systemctl start qndtmf.service

uninstall :
	######### QnetGateway #########
	systemctl stop qngateway.service
	systemctl disable qngateway.service
	/bin/rm -f $(SYSDIR)/qngateway.service
	/bin/rm -f $(BINDIR)/qngateway
	/bin/rm -f $(BINDIR)/qnremote
	/bin/rm -f $(BINDIR)/qnvoice
	/bin/rm -f $(CFGDIR)/qn.cfg
	######### QnetLink #########
	systemctl stop qnlink.service
	systemctl disable qnlink.service
	/bin/rm -f $(SYSDIR)/qnlink.service
	/bin/rm -f $(BINDIR)/qnlink
	/bin/rm -f $(CFGDIR)/*.dat
	/bin/rm -f $(CFGDIR)/RPT_STATUS.txt
	/bin/rm -f $(CFGDIR)/gwys.txt
	/bin/rm -f $(CFGDIR)/exec_?.sh

uninstalldtmf :
	systemctl stop qndtmf.service
	systemctl disable qndtmf.service
	/bin/rm -f $(SYSDIR)/qndtmf.service
	systemctl daemon-reload
	/bin/rm -f $(BINDIR)/qndtmf
