#!/bin/bash

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

INPUT=$1

# Check if input is a number
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  QUERY_CONDITION="atomic_number=$INPUT"
# Check if input is a symbol
elif [[ $INPUT =~ ^[A-Za-z]{1,2}$ ]]
then
  QUERY_CONDITION="symbol='$INPUT'"
# Otherwise treat it as a name
else
  QUERY_CONDITION="name='$INPUT'"
fi

RESULT=$(psql --username=freecodecamp --dbname=periodic_table -t --no-align -c \
"SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius
 FROM elements 
 INNER JOIN properties USING(atomic_number) 
 INNER JOIN types USING(type_id)
 WHERE $QUERY_CONDITION;")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"

echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
