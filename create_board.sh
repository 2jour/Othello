#################
# Usage
# create_board.sh <Name of Board>
#
#################
source token

regex='"shortUrl":"https://trello.com/b/([a-z0-9A-Z]*)"'
RESPONSE=$(curl -X POST -H "Content-Type: application/json" "https://trello.com/1/boards?key=$KEY&token=$TOKEN" -d '{  "name":"'$1'" }')

if [[ $RESPONSE =~ $regex ]]; then
	echo BOARDID="${BASH_REMATCH[1]}"
fi
