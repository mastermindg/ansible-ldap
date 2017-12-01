#!/usr/bin/env bash

vagrant destroy -f
rm -rf .vagrant
vagrant up
