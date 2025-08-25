for i in 1 2 3
do # as of : in python and {} in other lang
    echo "loop iteration #$i"
done # end of curly braces... } kind of...
# 10's a season sorted 

# while 
COUNTER=0
while [ $COUNTER -lt 3 ]; do
echo "Counter is at $COUNTER"
# increment the counter 
COUNTER=$((COUNTER + 1))
done