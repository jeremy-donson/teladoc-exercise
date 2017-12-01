#!/bin/bash

node hello.js &
sleep 5
CONTENT=$(curl http://127.0.0.1:8081/)

echo -e "\nExpected Content: Hello Node App\nActual Content: ${CONTENT}\nResult: "