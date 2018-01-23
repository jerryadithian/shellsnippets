#!/bin/bash -x

rm -rf failed_http_hosts.txt 
rm -rf failed_https_hosts.txt 
rm -rf success_https_hosts.txt
rm -rf success_http_hosts.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
  host=$(echo "$line" | cut -d ':' -f1)
  port=$(echo "$line" | cut -d ':' -f2)
  echo "Running test for $host:$port"
  if [ "$port" -eq 443 ]
    then
      response=$(curl -sL -w "%{http_code}\\n" "https://$host" -o /dev/null)
      if [ "$response" -eq 200 ]
        then
          echo "$host" >> success_https_hosts.txt
        else
          echo "$host" >> failed_https_hosts.txt
      fi
  else
    response=$(curl -sL -w "%{http_code}\\n" "http://$host" -o /dev/null)
      if [ "$response" -eq 200 ]
       then
         echo "$host" >> success_http_hosts.txt
       else
        echo "$host" >> failed_http_hosts.txt
        fi
  fi
done <"$1"
