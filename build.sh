##### build #####

echo 'compiling game code'
find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }
echo 'running unit tests'
busted tests/busted-test.lua 
echo 'build passed'
