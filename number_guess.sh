#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username:
read NAME

while [[ -z $NAME ]]
  do
    echo Please enter a valid name.
    read NAME
  done

PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE username='$NAME'")

# new player / insert into db
if [[ -z $PLAYER_ID ]]
  then
  echo Welcome, $NAME! It looks like this is your first time here.

  # insert into players table
  INSERT_PLAYER_RESULT=$($PSQL "INSERT INTO players(username, games_played) VALUES('$NAME', 0)")

  else
    # registered player / welcome back
    REGISTERED_PLAYER_RESULT=$($PSQL "SELECT username, games_played, best_game FROM players WHERE username='$NAME'")
    echo $REGISTERED_PLAYER_RESULT | while IFS='|' read USERNAME GAMES_PLAYED BEST_GAME
      do
        echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
      done
fi

SECRET_NUMBER=$((1 + $RANDOM % 1000))

echo $SECRET_NUMBER
GUESSES=0

echo "Guess the secret number between 1 and 1000:"
((GUESSES=GUESSES+1))
read GUESS



while [[ $GUESS != $SECRET_NUMBER ]]
 do
  # check integer
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
    then
    echo That is not an integer, guess again:
    read GUESS
  else

    if [[ $GUESS < $SECRET_NUMBER ]] 
    then
      echo "It's higher than that, guess again:"
    elif [[ $GUESS > $SECRET_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    fi

    ((GUESSES=GUESSES+1))
    read GUESS
  fi
done

echo Well done.
echo $GUESSES

# correct guess / game finished

# insert into games table

# update player table: games_played, best_game
