# Othello - Magical QA themed Trello Tools 

Use these tools to create a QA themed Trello board automagically to keep track of features or bugs

* Each board represents a release or milestone

* Lists categorizes test plans and can be customized here https://github.com/2jour/Othello/blob/master/themes/testboard/config_board

* Card describes a test plan

* Labels determine state of the test plan and can be customized https://github.com/2jour/Othello/blob/master/themes/testboard/config_board




## Instructions

1. git clone https://github.com/2jour/Othello 
2. Create an account on trello and login
2. Fetch your spiffy Application key at https://trello.com/app-key and add it here https://github.com/2jour/Othello/blob/master/token
3. Click on the token url on the trello page in step 2 to generate your token manually and add it here.
4. Call ```create_board.sh <Release Name> themes/testboard```
5. Go to your trello release board and use your QA magic  :) as you play Xanadu in the background




## Tools

* ``` close_board.sh -b <Release Name> ``` - Closes a board based on a Release Name created by create_board.sh
* ``` archive_all_cards.sh -b <Release Name> -l <List Name``` - Archives cards for all cards of a given release for a give list name

