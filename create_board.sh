#################
# Usage
# create_board.sh -b <RELEASE Name> <Theme>
#
#################
set -e

function fn_create_board_help_echo {
        clear
        echo "------------------------------------------"
        echo "NAME:"
        echo "      create_board.sh -b \<RELEASE NAME\> -t \<THEME\>"
        echo ""
        echo "DESCRIPTION:"
        echo "      Creates trello board"
        echo ""
        echo "      -h - Help"
        echo ""
        echo "      -t - a theme for the board. It is defined by ./<THEME>/config"
        echo "		 if THEME does not exist, you will get an error"
        echo ""
        echo "      -b - Release Name "
        echo
        echo "------------------------------------------"

}


create_board_BOARDNAME=
create_board_THEME=

# -- FETCHING PARAMETERS

if [[ -z $@ ]]; then
        fn_create_board_help_echo
        exit 1
fi

while [[ $# -gt 0 ]]; do
        parm="$1"
        case $parm in
                -h)
                fn_create_board_help_echo
                exit 0
                shift
                ;;
                -b)
                create_board_BOARDNAME="$2"
                shift
                ;;
                -t)
                create_board_THEME="$2"
                shift
                ;;
                *)
                fn_create_board_help_echo
                ;;
esac
shift
done

if [[ -z $create_board_BOARDNAME ]] || [[ -z $create_board_THEME ]] then ;
	fn_create_board_help_echo
	exit 1
fi


if [ ! -e  themes/$create_board_THEME ]; then
	echo Sorry, theme $create_board_THEME not available for Othello.
	exit 1
fi

source common_functions
source token
source themes/$create_board_THEME/config_board



regex='"shortUrl":"https://trello.com/b/([a-z0-9A-Z]*)"'
regex2='"id":"([a-z0-9A-Z]*)"'

RESPONSE=$(curl -X POST -H "Content-Type: application/json" "https://trello.com/1/boards?key=$KEY&token=$TOKEN" -d '{  "name":"'$create_board_BOARDNAME'","defaultLists":false }')

BOARDIDURL=''

create_board_MATCH=$(fn_common_fns_fetch_from_response "$RESPONSE" $regex2 "ERROR issue creating BOARD $create_board_BOARDNAME") 

BOARDIDURL=$create_board_MATCH


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


create_board_MATCH=$(fn_common_fns_fetch_from_response "$RESPONSE" $regex2 "ERROR creating labels for $create_board_BOARDNAME") 

BOARDID=$create_board_MATCH

echo ''
echo ''

LIST_IDS=""
for x in $LISTS; do
	echo "--- Creating List $x defined in config"

	RESPONSE=$(curl -X POST -H "Content-Type: application/json" "https://trello.com/1/lists?key=$KEY&token=$TOKEN" -d '{  "name":"'$x'","idBoard":"'$BOARDID'" }')

	create_board_MATCH=$(fn_common_fns_fetch_from_response "$RESPONSE" $regex2 "ERROR LIST $x was not created. Please manually create $x for BOARD: $create_board_BOARDNAME") 

	ID=$create_board_MATCH
	LIST_IDS="$LIST_IDS $x:$ID" 
done

#REMOVE LEADING AND TRAILING SPACE
LIST_IDS=$(echo -e "${LIST_IDS}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

echo '---- STORING boardid and list id IN LISTS FILE'
if [ ! -f ./lists ] ; then
	echo ERROR : PLEASE DOWNLOAD lists TEMPLATE FILE FROM https://github.com/2jour/Othello 
	exit 1
fi

mkdir -p boards/$create_board_BOARDNAME
cp ./lists boards/$create_board_BOARDNAME/lists
sed -i -e 's/<BOARDID>/'$BOARDID'/' ./boards/$create_board_BOARDNAME/lists 
sed -i -e "s/<LISTID>/\"$LIST_IDS\"/" ./boards/$create_board_BOARDNAME/lists 
