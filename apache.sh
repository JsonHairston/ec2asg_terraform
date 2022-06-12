#!/bin/bash

yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
amazon-linux-extras install epel -y
yum install stress -y