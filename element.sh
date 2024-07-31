#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo -e "Please provide an element as an argument."
else
  # check if number or string then get atomic_number
  if [[ $1 =~ ^[0-9]+$ ]]; then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1';")
  fi

  if [[ -z $ATOMIC_NUMBER ]]; then
    echo -e "I could not find that element in the database."
  else
    # get all element info
    ELEMENT_INFO=$($PSQL "select  name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements left join properties using(atomic_number) left join types using(type_id) where atomic_number = $ATOMIC_NUMBER ")
    echo "$ELEMENT_INFO" | while IFS="|" read NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT; do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi

fi
