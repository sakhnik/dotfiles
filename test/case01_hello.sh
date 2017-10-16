set -e

rm -rf ftmp/test.txt
./replay.py -qa 4 case01_input
echo -e "Hello, world!\n" | diff - /tmp/test.txt 
echo "Ok"
