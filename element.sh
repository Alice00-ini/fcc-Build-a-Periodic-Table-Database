#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0 ## 没有这个的话会出错。没有exit0且不给变量时， 比如./element.sh， 输出不仅有这条请求提供变量的信息，还有结尾那个"I could not find..."的信息也会出来，就不对了
fi

# the input argument could be atomic_number, symbol, or name
GET_ATOMIC_NUMBER() {
  ATOMIC_RESULT=$($PSQL "SELECT name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements 
  JOIN properties ON elements.atomic_number = properties.atomic_number
  JOIN types ON properties.type_id = types.type_id
  WHERE elements.atomic_number=$ATOMIC_NUMBER")
  echo $ATOMIC_RESULT | while IFS="|" read NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

GET_SYMBOL() {
  SYMBOL_RESULT=$($PSQL "SELECT elements.atomic_number, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements 
  JOIN properties ON elements.atomic_number = properties.atomic_number
  JOIN types ON properties.type_id = types.type_id
  WHERE symbol='$SYMBOL'")
  echo $SYMBOL_RESULT | while IFS="|" read ATOMIC_NUMBER NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

GET_NAME() {
  NAME_RESULT=$($PSQL "SELECT elements.atomic_number, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements 
  JOIN properties ON elements.atomic_number = properties.atomic_number
  JOIN types ON properties.type_id = types.type_id
  WHERE name = '$NAME'")
  echo $NAME_RESULT | while IFS="|" read ATOMIC_NUMBER SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do 
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

ATOMIC_NUMBER_LIST=$($PSQL "SELECT atomic_number FROM elements")
for i in $ATOMIC_NUMBER_LIST=$($PSQL "SELECT atomic_number FROM elements"); 
do
  if [[ $i = $1 ]];
  then
    ATOMIC_NUMBER=$1
    GET_ATOMIC_NUMBER
  fi
done

if [[ -z $ATOMIC_NUMBER ]];
  then
    SYMBOL_LIST=$($PSQL "SELECT symbol FROM elements");

  for i in $SYMBOL_LIST;
  do
    if [[ $i = $1 ]];
    then
      SYMBOL=$1
      GET_SYMBOL
    fi
  done
fi

if [[ -z $SYMBOL ]];
  then
    NAME_LIST=$($PSQL "SELECT name FROM elements");

  for i in $NAME_LIST;
  do
    if [[ $i = $1 ]];
    then
      NAME=$1
      GET_NAME
    fi
  done
fi

if [[ -z $ATOMIC_NUMBER && -z $SYMBOL && -z $NAME ]]; then
  echo "I could not find that element in the database."
fi



