#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

CREATE_PLAYERS_TABLE=$($PSQL "
CREATE TABLE players(
  player_id SERIAL PRIMARY KEY,
  name VARCHAR(22) NOT NULL UNIQUE,
  games_played INT,
  best_game INT
)")

CREATE_GAMES_TABLES=$($PSQL "
CREATE TABLE games(
  game_id SERIAL PRIMARY KEY,
  player_id INT,
  secret_number INT NOT NULL,
  number_of_guesses INT
)")

SET_FOREIGN_KEY_PLAYER=$($PSQL "
ALTER TABLE games
  ADD FOREIGN KEY(player_id) REFERENCES players(player_id)
")