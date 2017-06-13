#!/bin/bash
tar -zxf /usr/local/app-agent.tar.gz -C /usr/local
rm /usr/local/app-agent.tar.gz
cd /usr/local/app-agent
./install.sh
