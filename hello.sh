#!/bin/bash 
# not neccessary ... i see
echo "hello world"

# next up Variables:
NAME="Rajshekhar"
echo " Welcome ${NAME}!"

# time for userInputs
echo " what's your favourite hobby"
read FAV_HOBBY # reads the user input 
echo "${FAV_HOBBY} is ${NAME}'s favourite choice "

# Conditionals
read -p "enter a number.." NUMBER
# use of -p flag is ? prompt the text for line in which user will add input
if [ $NUMBER -gt 10 ];then 
# note -gt is a condition it means greater 
# much alike are.. -eq stands for equal -ne not equal -lt less than
# not ; and then as like an arrow ;then ==  =>
# space in conditional is mandatory by convention ;)
    echo "Clearly Number is Greater than 10"
else echo " no is not greater than 10 " # space between else n echo ain't neccessary
fi # fi to pull an end to this conditional 


