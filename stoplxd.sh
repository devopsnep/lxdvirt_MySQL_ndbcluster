#!/bin/bash
name=$1
for v in `cat $1`;do lxc stop $v; done;
