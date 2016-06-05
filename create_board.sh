#################
# Usage
# create_board.sh <Name of Board> <Theme>
#
#################
MATCH=" "
function FetchFromResponse {
	if [[ $1 =~ $2 ]]; then
		echo MATCH="${BASH_REMATCH[1]}"
		MATCH=${BASH_REMATCH[1]}
	else
		echo Error can not find match: Trello returned the following: "$1"
		exit
	fi
}
if [ ! -d  themes/$2 ]; then
	echo Sorry, theme $2 not available for Othello.
	exit
fi

source token
source themes/$2/config_board

regex='"shortUrl":"https://trello.com/b/([a-z0-9A-Z]*)"'
regex2='"id":"([a-z0-9A-Z]*)"'

RESPONSE=$(curl -X POST -H "Content-Type: application/json" "https://trello.com/1/boards?key=$KEY&token=$TOKEN" -d '{  "name":"'$1'","defaultLists":false }')

BOARDIDURL=''

FetchFromResponse $RESPONSE $regex 
BOARDIDURL=$MATCH


for x in $LABELS 
do
	LABELCOLOR=$(echo $x | cut -f1 -d':')
	LABELTAG=$(echo $x | cut -f2 -d':')
	echo "------------------------"
	echo Creating Label Color "$LABELCOLOR":"$LABELTAG"
	RESPONSE=$(curl -X PUT -H "Content-Type: application/json" "https://trello.com/1/boards/$BOARDIDURL/labelNames/$LABELCOLOR?key=$KEY&token=$TOKEN" -d '{  "value":"'$LABELTAG'" }')
	echo "------------------------"
done


FetchFromResponse $RESPONSE $regex2 
BOARDID=$MATCH

for x in $LISTS
do
	RESPONSE=$(curl -X POST -H "Content-Type: application/json" "https://trello.com/1/lists?key=$KEY&token=$TOKEN" -d '{  "name":"'$x'","idBoard":"'$BOARDID'" }')
	echo $RESPONSE
done
