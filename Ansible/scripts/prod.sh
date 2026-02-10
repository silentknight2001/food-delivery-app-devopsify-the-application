#!/usr/bin/env bash

sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt update
sudo apt install -y openjdk-21-jdk

java --version
