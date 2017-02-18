#################
# Usage
# create_board.sh <Name of Board> <Theme>
#
#################
set -ex
MATCH=" "
function FetchFromResponse {
	local loc_error=$3
	if [[ $1 =~ $2 ]]; then
		echo MATCH="${BASH_REMATCH[1]}"
		MATCH=${BASH_REMATCH[1]}
	else
		echo Error can not find match: Trello returned the following: "$1"
		echo "$loc_error"
		exit 1
	fi
}

THEME=$2
BOARDNAME=$1
if [ ! -d  themes/$THEME ]; then
	echo Sorry, theme $THEME not available for Othello.
	exit 1
fi

source token
source themes/$THEME/config_board



regex='"shortUrl":"https://trello.com/b/([a-z0-9A-Z]*)"'
regex2='"id":"([a-z0-9A-Z]*)"'

RESPONSE=$(curl -X POST -H "Content-Type: application/json" "https://trello.com/1/boards?key=$KEY&token=$TOKEN" -d '{  "name":"'$1'","defaultLists":false }')

BOARDIDURL=''

FetchFromResponse "$RESPONSE" $regex2 "ERROR issue creating BOARD $BOARDNAME" 
BOARDIDURL=$MATCH


echo '--- Creating Labels defined in config_board'
echo ''
echo ''
for x in $LABELS 
do
	LABELCOLOR=$(echo $x | cut -f1 -d':')
	LABELTAG=$(echo $x | cut -f2 -d':')
	echo "------------------------"
	echo Creating Label Color "$LABELCOLOR":"$LABELTAG"
	RESPONSE=$(curl -X PUT -H "Content-Type: application/json" "https://trello.com/1/boards/$BOARDIDURL/labelNames/$LABELCOLOR?key=$KEY&token=$TOKEN" -d '{  "value":"'$LABELTAG'" }')
	echo "------------------------"
done


FetchFromResponse "$RESPONSE" $regex2 "ERROR creating labels for $BOARDNAME" 
BOARDID=$MATCH
echo ''
echo ''

LIST_IDS=""
for x in $LISTS; do
	echo "--- Creating List $x defined in config"

	RESPONSE=$(curl -X POST -H "Content-Type: application/json" "https://trello.com/1/lists?key=$KEY&token=$TOKEN" -d '{  "name":"'$x'","idBoard":"'$BOARDID'" }')
	FetchFromResponse "$RESPONSE" $regex2 "ERROR LIST $x was not created. Please manually create $x for BOARD: $BOARDNAME" 
	ID=$MATCH
	LIST_IDS="$LIST_IDS $x:$ID" 
done

#REMOVE LEADING AND TRAILING SPACE
LIST_IDS=$(echo -e "${LIST_IDS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

echo '---- STORING boardid and list id IN LISTS FILE'
if [ ! -f ./lists ] ; then
	echo ERROR : PLEASE DOWNLOAD lists TEMPLATE FILE FROM https://github.com/2jour/Othello 
	exit 1
fi

mkdir -p boards/$BOARDNAME
cp ./lists boards/$BOARDNAME/lists
sed -i -e 's/<BOARDID>/'$BOARDID'/' ./boards/$BOARDNAME/lists 
sed -i -e "s/<LISTID>/$LIST_IDS/" ./boards/$BOARDNAME/lists 
