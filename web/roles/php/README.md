```
# yum clean all
# yum install wget
# cd /etc/yum.repos.d
# mv public-yum-ol7.repo public-yum-ol7.repo.bak
# wget http://yum.oracle.com/public-yum-ol7.repo
# yum upgrade
# yum install yum-utils
# yum-config-manager --enable ol7_developer_php71
# yum install php
```
