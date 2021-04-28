#!/bin/bash

function check_tools_available() {
   which gc-info 
   if [ $? -ne 0 ];then
      printf "Can't find gc-info in cur $PATH, please import poplar sdk\n"
      exit 1
   fi	   
}

function run_basic_device_tests() {
   ipu_num=$1
   for dev_id in $(seq 0 $((ipu_num-1)));do
      gc-hosttraffictest -d $dev_id
      if [ $? -ne 0 ];then
        printf "Run gc-hosttraffictest -d ${dev_id} failed, you need to check the environment\n"
	printf "Possible Reason:\n"
	printf "    1) this ipu is occupied by other process\n"
	printf "    2) problem with 100G Network"
	exit 1
      fi 
   done 
}

function get_dev_num() { 
   num=$(gc-inventory | grep "id:" | wc -l)	
   if [ ${num} -eq 0 ];then
     printf "No IPU device found, please check\n"   
     exit 1
   else 
     printf "${num} IPU device found\n"   
   fi
   echo $num
}
