#!/bin/bash
num1=100
num2=100
if test $num1 -eq $num2
then
    echo "The two numbers are equal!"
else
    echo "The two numbers are not equual!"
fi

if test -e testfile
then
    echo "The file already exists!"
else
    echo "The file does not exists!"
fi

if test -e testfile -o notestfile
then 
    echo "One file exists at least!"
else
    echo "Both does not exists!"
fi

