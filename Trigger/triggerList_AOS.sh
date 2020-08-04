#!/bin/sh

PlanID_VALUE=$1
STYLE_VALUE=$2
InventoryKey=$3
PHASE_VALUE=$4
ListJob=$5
SERVER=$6
BRANCH_VALUE=origin/ladm
OS_VALUE="android"

#SERVER=http://10.254.194.36:8080/job/Jobs%20Base%20On%20Device/view/LADM/job
#ListJob="AOS_10.x_R58MC34H3PE_Note10 "

#Print out data input
echo "=========================="
echo "Input Data For Trigger Job:" "1. PlanID_VALUE: $PlanID_VALUE\n" "2. STYLE_VALUE: $STYLE_VALUE\n"
echo "3. InventoryKey: $InventoryKey\n" "4. PHASE_VALUE: $PHASE_VALUE\n" "5. ListJob: $ListJob\n" "6. SERVER: $SERVER\n"
echo "=========================="

for i in $ListJob;do
  JOB_NAME=$i
  echo "Trigger for $i" >> log.txt
  curl -X POST --user admin:116bbb186c1d12518b67f8030236d8c73a --silent "$SERVER/$JOB_NAME/buildWithParameters?BRANCH=$BRANCH_VALUE&ForTestCases=all&PlanID=$PlanID_VALUE&AD_STYLE=$STYLE_VALUE&Phase=Phase$PHASE_VALUE&InventoryKey=$InventoryKey"
  BUILD_NUMBER=`curl --user admin:116bbb186c1d12518b67f8030236d8c73a --silent $SERVER/$JOB_NAME/lastBuild/api/json|grep -E '#'|sed -E 's/.+\#//g'|cut -d"\"" -f1`
  echo "Report Link: $SERVER/$JOB_NAME/$BUILD_NUMBER/thucydidesReport/" >> dataReport.txt
  echo "==========================="
done


sleep 30

for i in $ListJob;do
  JOB_NAME=$i
  BUILD_NUMBER=`curl --user admin:116bbb186c1d12518b67f8030236d8c73a --silent $SERVER/$JOB_NAME/lastBuild/api/json|grep -E '#'|sed -E 's/.+\#//g'|cut -d"\"" -f1`
  echo "Gonna add comment for $JOB_NAME/$BUILD_NUMBER"
#  RunID=`curl --user admin:116bbb186c1d12518b67f8030236d8c73a --silent $SERVER/$JOB_NAME/lastBuild/consoleText|grep -E "CurrentTestRun"|sed -E 's/CurrentTestRun=//g'`
#  echo "RunID is $RunID"
  description="Test On Plan $PlanID_VALUE - RunID $RunID - os: $OS_VALUE - Style: $STYLE_VALUE- inventory key: $InventoryKey"
  curl -X POST --user admin:116bbb186c1d12518b67f8030236d8c73a --silent --data-urlencode "description=$description" "$SERVER/$JOB_NAME/$BUILD_NUMBER/submitDescription"
done

echo "========================="

