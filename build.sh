##### build #####

find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }
echo 'build passed'
