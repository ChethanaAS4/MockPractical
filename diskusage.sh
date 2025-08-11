#!/bin/bash

diskuse = df -h | head -2 | awk -F " " '{print $(NF-1)}' | sed "s/%//g"
if[ diskuse -ge 90 ]
then
echo "Disk usage is more than 90%" | main -s "Disk Storage alert" -c "chethanakanadmane@gmail.com"
fi
