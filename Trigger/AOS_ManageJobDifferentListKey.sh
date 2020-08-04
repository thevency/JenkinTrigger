#!/bin/sh

# Inventory should consist with ADSTYLE
# Log of shell script is log_AOS_ManageJobDifferentListKey.txt
# Report Data is dataReport.txt

SERVER=http://10.254.194.36:8080/job/Jobs%20Base%20On%20Device/view/LADM/job
JOB_LIST="AOS_10.x_R58MC34H3PE_Note10 iOS_12.x_3cd794dc710325abb8881184106b1eb0fccb2099_XS"
PlanID_VALUE=""
PHASE_VALUE="1"
ADSTYLE_FILE="/Users/lw11996/.jenkins/adstyle_aos.properties"

#List key 1 + Adstyle 1
InventoryKey_list_1="lb.3JR3g_Z3yoU"
ADSTYLE_LIST_1="BannerView2_Image_600x314"
#List key 2 + Adstyle 2
InventoryKey_list_2="lb.oLFjKT8kJDo"
ADSTYLE_LIST_2="IconView_Image_600x314-540x540"


#Clean file
echo "" > log_AOS_ManageJobDifferentListKey.txt
name_of_report=`date +"%Y-%m-%d-%H:%M"`

for style in $ADSTYLE_LIST_1;do
  echo "Trigger Ad style: $style for all keys" >> log_AOS_ManageJobDifferentListKey.txt
  echo "TestPlanID: $PlanID_VALUE" >> dataReport_$name_of_report.txt
  echo "AD_STYLE: $style" >> dataReport_$name_of_report.txt
  for key in $InventoryKey_list_1;do
    echo "Trigger for key: $key" >> log_AOS_ManageJobDifferentListKey.txt
    echo "InventoryKey: $key" >> dataReport_$name_of_report.txt
#    PlanID_VALUE=$1
#    STYLE_VALUE=$2
#    InventoryKey=$3
#    PHASE_VALUE=$4
    ./triggerList_AOS.sh $PlanID_VALUE $style $key $PHASE_VALUE "${JOB_LIST[@]}" $SERVER
    sleep 60
  done

  echo "Finish Trigger Ad style $style" >> log_AOS_ManageJobDifferentListKey.txt

  STATUS_OF_ADSTYLE=`grep "$style" $ADSTYLE_FILE|sed -E 's/.+'$style'//g'|cut -d "=" -f2`

  echo "Check For Ad style $style finish ? $STATUS_OF_ADSTYLE" >> log_AOS_ManageJobDifferentListKey.txt

  while [[ $STATUS_OF_ADSTYLE != "true" ]]
  do
    sleep 600
    echo "Waiting with cycle 15 minutes" >> log_AOS_ManageJobDifferentListKey.txt
  done

  echo "Ad style $style is finished !\n ==================="  >> log_AOS_ManageJobDifferentListKey.txt

done

sleep 60

for style in $ADSTYLE_LIST_2;do
  echo "Trigger Ad style: $style for all keys" >> log_AOS_ManageJobDifferentListKey.txt
   echo "==== REPORT ===="
  echo "TestPlanID: $PlanID_VALUE" >> dataReport_$name_of_report.txt
  echo "AD_STYLE: $style" >> dataReport_$name_of_report.txt
  for key in $InventoryKey_list_2;do
    echo "Trigger for key: $key" >> log_AOS_ManageJobDifferentListKey.txt
    echo "InventoryKey: $key" >> dataReport_$name_of_report.txt
#    PlanID_VALUE=$1
#    STYLE_VALUE=$2
#    InventoryKey=$3
#    PHASE_VALUE=$4
    ./triggerList_AOS.sh $PlanID_VALUE $style $key $PHASE_VALUE "${JOB_LIST[@]}" $SERVER
    sleep 60
  done

  echo "Finish Trigger Ad style $style" >> log_AOS_ManageJobDifferentListKey.txt

  echo "Check For Ad style finish ..." >> log_AOS_ManageJobDifferentListKey.txt
done






