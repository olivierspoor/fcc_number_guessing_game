#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username:
read NAME

while [[ -z $NAME ]]
  do
    echo Please enter a valid name.
    read NAME
  done

PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name='$NAME'")

# new player / insert into db
if [[ -z $PLAYER_ID ]]
  then
  echo Welcome, $NAME! It looks like this is your first time here.
fi

SECRET_NUMBER=$((1 + $RANDOM % 1000))
