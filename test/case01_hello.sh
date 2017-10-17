set -e

rm -rf /tmp/test.txt
./replay.py -a 4 case01_input
echo -e "Hello, world!\n" | diff - /tmp/test.txt 
echo "Ok"
