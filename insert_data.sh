#! /bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.

# Empty teams and games tables
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    TEAM_NAME1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    #if team name is not found, insert team
    if [[ -z $TEAM_NAME1 ]]
    then
    #insert team
      INSERT_TEAM_NAME1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #echo inserted message
      if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER
      fi
    fi
  fi

  #exclude column names row
  if [[ $OPPONENT != "opponent" ]]
  then
    TEAM_NAME2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    #if team not found, insert team
    if [[ -z $TEAM_NAME2 ]]
    then
    #insert team
      INSERT_TEAM_NAME2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #echo team inserted
      if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT
      fi
    fi
  fi

# INSERT GAMES TABLE

  # we dont want the column names row so exclude it
  if [[ YEAR != "year" ]]
  then
    # GET WINNER_ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # GET OPPONENT_ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # INSERT GAMES
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    # echo item what was added
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
    fi
  fi

done