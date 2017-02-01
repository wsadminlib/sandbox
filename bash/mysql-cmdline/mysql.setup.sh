#!/bin/bash
#-----------------------------------------------------------------------
# Copyright IBM Corp. 2017
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-----------------------------------------------------------------------
# Demonstrates how to issue a mysql commands atomically from cmdline.
#
# @Author Andy Dingsor 2017-0201-1423
#-----------------------------------------------------------------------
echo "Entry"

export MY_HOST="localhost"
export MY_USER="root"

# Define the mysql commands to be executed.
COMMANDS=( \
    "create user 'sippilot'@'%' identified by 'sip123';commit;" \
    "create user 'sippilot'@'localhost' identified by 'sip123';commit;" \
    "select User,Host from mysql.user;" \
    "GRANT ALL PRIVILEGES ON *.* TO 'sippilot'@'%';commit;FLUSH PRIVILEGES;" \
    "GRANT ALL PRIVILEGES ON *.* TO 'sippilot'@'localhost';commit;FLUSH PRIVILEGES;" \
    "SHOW GRANTS FOR 'sippilot'@'%'" \
    "SHOW GRANTS FOR 'sippilot'@'localhost'"
)

# Execute each command.
for CMD in "${COMMANDS[@]}"
do
    echo "Issuing command: ${CMD}"
    mysql -h ${MY_HOST} -u${MY_USER} -e "${CMD}"
    RC=$?
    echo "RC=${RC}"
    if [ "0" -ne ${RC} ] ; then
        echo "FAIL: ${CMD}"
        exit 99
    fi
done

echo "Exit"
