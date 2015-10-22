echo running tests for python
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-python sleep 365d

defer docker kill $UUID

pass "unable to create code folder" docker exec $UUID mkdir -p /opt/code

fail "Detected something when there shouldn't be anything" docker exec $UUID bash -c "cd /opt/engines/python/bin; ./sniff /opt/code"

pass "Failed to inject requirements file" docker exec $UUID touch /opt/code/requirements.txt

pass "Failed to detect Python" docker exec $UUID bash -c "cd /opt/engines/python/bin; ./sniff /opt/code"