#!/bin/bash 
TOKEN=$(curl -X POST "http://$VIRTUALIZATION_IP:8080/api/v1/login" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"username\": \"$VIRTUALIZATION_LOGIN\", \"password\": \"$VIRTUALIZATION_PASSWORD\"}" |awk -F ":" '{print $2}' |  cut -d '}' -f 1 | cut -d '"' -f 2)
VDB_ID=$(curl -X POST "http://$VIRTUALIZATION_IP:8080/api/v1/vdb" -H "accept: application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{\"startImmidiately\":true,\"createVolumeRequest\":{\"name\":\"QA_VDB\",\"description\":\"\",\"type\":\"CLONE\",\"parentId\":\"$SNAPSHOT_ID\",\"snapshotInterval\":0,\"refreshSchedule\":{\"count\":0,\"interval\":\"MINUTES\",\"startFromDate\":\"2021-12-22 15:16\",\"retentionCount\":14}},\"startVdbRequest\":{\"name\":\"QA_VDB\",\"description\":\"\",\"dstDbHomeId\":\"$TGT_HOME_ID\",\"dbSid\":\"QA\",\"advancedParams\":[{\"name\":\"PostSqlScriptPath\",\"value\":\"\"},{\"name\":\"PreOsScriptPath\",\"value\":\"\"},{\"name\":\"PostOsScriptPath\",\"value\":\"\"}],\"racInstances\":[],\"dbPort\":5560}}" |tee /dev/stderr |awk -F ":" '{print $2}' |  cut -d '}' -f 1 | cut -d '"' -f 2)
sleep 5
vdb_check=$(curl -X GET "http://$VIRTUALIZATION_IP:8080/api/v1/vdb"  -H "accept: application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" | jq -r --arg VDB_ID "$VDB_ID" '.[] | select(.id == $VDB_ID) | .status')
while [[ "$vdb_check" == "IN_PROGRESS"  ]];
do
echo "VDB creation IN_PROGRESS. Sleeping 30 second until next check" && sleep 30;
export vdb_check=$(curl -X GET "http://$VIRTUALIZATION_IP:8080/api/v1/vdb"  -H "accept: application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" | jq -r --arg VDB_ID "$VDB_ID" '.[] | select(.id == $VDB_ID) | .status');
done
if [[ "$vdb_check" == "UP" ]]; then
echo "VDBCreate passed"
else 
echo "VDBCreate failed"
exit 1
fi
curl -X GET "http://$VIRTUALIZATION_IP:8080/api/v1/lvm/info/$VDB_ID" -H "accept: application/json" -H "Authorization: Bearer $TOKEN" 
