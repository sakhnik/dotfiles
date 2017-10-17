#!/bin/bash

this_dir=`dirname ${BASH_SOURCE[0]}`
cd $this_dir

test_cases=`find . -name "case*.sh" | sort`
echo "Found `echo "$test_cases" | wc -l` test cases"

failed=
log_failed()
{
    failed="$failed $1"
    echo "FAILED $1"
}

for test_case in `echo $test_cases`; do
    echo "Running $test_case"
    bash $test_case || log_failed $test_case
done

if [[ -z "$failed" ]]; then
    echo "PASSED"
else
    echo "The following test cases failed: $failed"
    exit 1
fi
