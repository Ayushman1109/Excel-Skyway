#!/bin/bash
cd "$(dirname "$0")/.."
source ./scripts/setEnvironment.sh
# Clean the package bin directory to remove stale .class files
rm -rf bin/com/poc/excel/model
mkdir -p bin/com/poc/excel/model
find src -name "*.java" > sources.txt
javac -source 8 -target 8 -d bin -cp .:bin:"$JX_HOME/libs/jxclasses.jar":"$JX_HOME/external_libs/json-20240303.jar":"D:/CData/lib/cdata.jdbc.excel.jar" @sources.txt
if [ $? -eq 0 ]; then
    echo "Compilation completed successfully."
else
    echo "Compilation failed."
    exit 1
fi
