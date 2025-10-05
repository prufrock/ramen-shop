#!/bin/bash
output=$(curl http://127.0.0.1:8000)

if ! echo "$output" | grep --extended-regexp --quiet "^There are [0-9]+ ramen noodles\.$"; then
    echo "Ramen shop didn't return the expected result got:"
    echo $output
    exit 1
fi
echo "🎉 It works!"
echo $output
