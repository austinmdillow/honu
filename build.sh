##### build #####

find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }
busted tests/busted-test.lua 
echo 'build passed'
