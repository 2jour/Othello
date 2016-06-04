#################
# Usage
# create_board.sh <Name of Board> <Theme>
#
#################

if [ ! -d  themes/$2 ]; then
	echo Sorry, theme $2 not available for Othello.
	exit
fi

source token
source themes/$2/config_board

regex='"shortUrl":"https://trello.com/b/([a-z0-9A-Z]*)"'

RESPONSE=$(curl -X POST -H "Content-Type: application/json" "https://trello.com/1/boards?key=$KEY&token=$TOKEN" -d '{  "name":"'$1'" }')

BOARDID=''
if [[ $RESPONSE =~ $regex ]]; then
	echo BOARDID="${BASH_REMATCH[1]}"
	BOARDID=${BASH_REMATCH[1]}
else
	echo Error Creating Board: Trello returned the following: "$RESPONSE"
	exit
fi

for x in $LABELS 
do
	LABELCOLOR=$(echo $x | cut -f1 -d':')
	LABELTAG=$(echo $x | cut -f2 -d':')
	echo "------------------------"
	echo Creating Label Color "$LABELCOLOR":"$LABELTAG"
	RESPONSE=$(curl -X PUT -H "Content-Type: application/json" "https://trello.com/1/boards/$BOARDID/labelNames/$LABELCOLOR?key=$KEY&token=$TOKEN" -d '{  "value":"'$LABELTAG'" }')
	echo "$RESPONSE"
	echo "------------------------"
done
