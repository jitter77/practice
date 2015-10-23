#!/bin/bash

int fd = open"/dev/ttyUSB0";
int ret = read(fd, &input, count);


