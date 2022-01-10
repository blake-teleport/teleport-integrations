debug=false
ticket_priority=1
reqid=$(sudo tctl requests ls | grep PENDING | grep 'INC\|inc' | awk '{print $1}' | head -n 1)
ticket=$(sudo tctl requests ls | grep "$reqid" | awk '{print $10}' | head -n 1)
ticketsla=$(curl https://dev114475.service-now.com/api/now/table/incident?sysparm_query=task_effective_number%3D"$ticket"%5Epriority%3D"$ticket_priority"      -H ' content_type=application/json; charset=utf-8'      -u '[USER]:[PASSWORD]' | jq -r '.result' | grep made_sla | awk '{print $2}' | sed 's/[^a-zA-Z0-9]//g')
if [ "$ticketsla" = "true" ]
then
  tctl request approve "$reqid" --reason='Elevated Access Request is approved as ticket#'"$ticket"' meets SLA and priority requirements'
else
  tctl request deny "$reqid" --reason='Elevated Access Request is denied as ticket#'"$ticket"' does not meet minimum priority or SLA requirements. Please update ticket or submit request for manual approval.'
  fi
sleep 5
