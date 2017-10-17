set -e

rm -rf /tmp/cout.cpp
./replay.py -a 4 case02_input

cat <<END | diff -w - /tmp/cout.cpp
#include <iostream>

int main()
{
	std::cout.clear();
	std::getline();
}
END

echo "Ok"
