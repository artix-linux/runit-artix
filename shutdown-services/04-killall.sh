status "Sending TERM signal to processes..." pkill --inverse -s0,1 -TERM
sleep 1
status "Sending KILL signal to processes..." pkill --inverse -s0,1 -KILL
