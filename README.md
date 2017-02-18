# Othello - Magical QA themed Trello Tools 

Use these tools to create a QA themed Trello board automagically to keep track of features or bugs

* Each board represents a release or milestone

* Labels determine states of bugs and features and can be customized https://github.com/2jour/Othello/blob/master/themes/testboard/config_board

* Lists group testing strategies and can be customized here https://github.com/2jour/Othello/blob/master/themes/testboard/config_board



## Instructions

1. git clone https://github.com/2jour/Othello 
2. Create an account on trello and login
2. Fetch your spiffy Application key at https://trello.com/app-key and add it here https://github.com/2jour/Othello/blob/master/token
3. Click on the token url on the trello page in step 2 to generate your token manually and add it here.
4. Call ```create_board.sh <Release Name> themes/testboard```
5. Go to your trello release board and use your QA magic  :) as you play Xanadu in the background




## Tools

* ``` close_board.sh -b <BOARDNAME> ``` - Closes a board based on a BOARDNAME created by create_board.sh

