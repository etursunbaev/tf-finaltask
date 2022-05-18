#!/bin/bash

test1=${db_host}
test2="${db_host}"
test3=$${db_host}
test4=\${db_host}

echo "test1 $test1 - ${db_host}" >> /tmp/test.txt
echo "test2 $test2 - ${db_host}" >> /tmp/test.txt
echo "test3 $test3 - $${db_host}" >> /tmp/test.txt
echo "test4 $test4 - \${db_host}" >> /tmp/test.txt