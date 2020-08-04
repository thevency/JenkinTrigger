#!/bin/sh

# Inventory should consist with ADSTYLE
SERVER=http://10.254.194.36:8080/job/Jobs%20Base%20On%20Device/view/LADM/job
JOB_LIST="AOS_10.x_R58MC34H3PE_Note10 iOS_12.x_3cd794dc710325abb8881184106b1eb0fccb2099_XS"
PlanID_VALUE=""
PHASE_VALUE="1"
InventoryKey_list="lb.nYuXlQJ4blY lb.cNcwLKQbbNQ"
ADSTYLE_LIST="Union_Image_1200x628"
ADSTYLE_FILE="/Users/lw11996/.jenkins/adstyle_aos.properties"

#Clean file
echo "" > log_AOS_ManageJobSameListKey.txt

#Only applied for Adstyles that have same inventory key list.
for style in $ADSTYLE_LIST;do
  echo "Trigger Ad style: $style for all keys" >> log_AOS_ManageJobSameListKey.txt
  echo "==== REPORT ===="
  echo "TestPlanID: $PlanID_VALUE" >> dataReport.txt
  echo "AD_STYLE: $style" >> dataReport.txt
  for key in $InventoryKey_list;do
    echo "Trigger for key: $key" >> log_AOS_ManageJobSameListKey.txt
    echo "InventoryKey: $key" >> dataReport.txt
#    PlanID_VALUE=$1
#    STYLE_VALUE=$2
#    InventoryKey=$3
#    PHASE_VALUE=$4
    ./triggerList_AOS.sh $PlanID_VALUE $style $key $PHASE_VALUE "${JOB_LIST[@]}" $SERVER
    sleep 60
  done

  echo "Finish Trigger Ad style $style" >> log_AOS_ManageJobSameListKey.txt

  echo "Check For Ad style finish ..." >> log_AOS_ManageJobSameListKey.txt


#Phase 2: It is required to check if current Adstyle is finished.
  if [[ $PHASE_VALUE == "2" ]]
  then
    STATUS_OF_ADSTYLE=`grep "$style" $ADSTYLE_FILE|sed -E 's/.+'$style'//g'|cut -d "=" -f2`

    while [[ $STATUS_OF_ADSTYLE != "true" ]]
    do
      sleep 900
      echo "Waiting with cycle 15 minutes" >> log_AOS_ManageJobSameListKey.txt
    done

    if [[ $STATUS_OF_ADSTYLE == "true" ]]
    then
      echo "Trigger next style" >> log_AOS_ManageJobSameListKey.txt
      echo "==================" >> log_AOS_ManageJobSameListKey.txt
    else
      echo "May be a problem here - STATUS_OF_ADSTYLE: $STATUS_OF_ADSTYLE" >> log_AOS_ManageJobSameListKey.txt
    fi
  else
    #Phase1: Wait until all job of current style finish
    echo "Phase 1 is trigger ...." >> log_AOS_ManageJobSameListKey.txt
    sleep 60
    # shellcheck disable=SC2039
    ./checkJobListFinish.sh "${JOB_LIST[@]}" $SERVER
    echo "====================="  >> log_AOS_ManageJobSameListKey.txt
  fi
done







