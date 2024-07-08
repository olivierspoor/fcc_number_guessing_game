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

  # insert into players table

  #else
  # registered player / welcome back

#   echo Welcome back, $NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

SECRET_NUMBER=$((1 + $RANDOM % 1000))

# while guess != secret_number
  # too low
  # too high

# correct guess / game finished

# insert into games table

# update player table: games_played, best_game
