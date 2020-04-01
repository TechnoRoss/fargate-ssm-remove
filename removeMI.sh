#!/bin/bash

aws ssm describe-instance-information --query 'InstanceInformationList[*].[InstanceId,PingStatus]' --output text | grep ConnectionLost | awk ' { print $1}' | tee ./terminate.txt

if [ -s terminate.txt ]
then
	while read INSTNCE
	do
	echo "Instance to remove:" ${INSTNCE}
	aws ssm deregister-managed-instance --instance-id ${INSTNCE}
	done < terminate.txt
else
	echo "No instances to remove at this time."
fi
