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
  # echo $INSERT_PLAYER_RESULT

  else
    # registered player / welcome back
    REGISTERED_PLAYER_RESULT=$($PSQL "SELECT username, games_played, best_game FROM players WHERE username='$NAME'")
    echo $REGISTERED_PLAYER_RESULT | while IFS='|' read USERNAME GAMES_PLAYED BEST_GAME
      do
        echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
      done
fi

SECRET_NUMBER=$((1 + $RANDOM % 1000))

# echo $SECRET_NUMBER
NUMBER_OF_GUESSES=0

echo "Guess the secret number between 1 and 1000:"
((NUMBER_OF_GUESSES=NUMBER_OF_GUESSES+1))
read GUESS



while [[ $GUESS != $SECRET_NUMBER ]]
 do
  # check integer
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
    then
    echo That is not an integer, guess again:
    read GUESS
  else

    if [[ $GUESS -lt $SECRET_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    fi

    ((NUMBER_OF_GUESSES=NUMBER_OF_GUESSES+1))
    read GUESS
  fi
done

# correct guess / game finished
echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!

# insert into games table
PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE username='$NAME'")
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(player_id, secret_number, number_of_guesses) VALUES($PLAYER_ID, $SECRET_NUMBER, $NUMBER_OF_GUESSES)")
# echo $INSERT_GAME_RESULT

# update player table: games_played
NUMBER_OF_GAMES=$($PSQL "SELECT COUNT(game_id) FROM players LEFT JOIN games USING(player_id) WHERE player_id=1;")
UPDATE_PLAYER_GAMES=$($PSQL "UPDATE players SET games_played=$NUMBER_OF_GAMES WHERE player_id=$PLAYER_ID")

# update player table: best_game
BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE player_id=$PLAYER_ID")
UPDATE_PLAYER_BEST=$($PSQL "UPDATE players SET best_game=$BEST_GAME WHERE player_id=$PLAYER_ID")

# to do: bugs
# - random users inserted
# - random games inserted