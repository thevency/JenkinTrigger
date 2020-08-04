#!/bin/sh


job_list=$1
SERVER=$2

for job in $job_list;do
  STATUS=`curl --silent $SERVER/$job/lastBuild/api/json|grep -E "result"|sed -E 's/.+result\"://g'|cut -d "," -f1`
  echo "Status of Job $job is $STATUS" >> log.txt
  while [[ $STATUS == "null" ]]
  do
    echo "Waiting for cycle 10 minutes" >> log.txt
    sleep 600
  done

done

echo "All jobs are DONE" >> log.txt