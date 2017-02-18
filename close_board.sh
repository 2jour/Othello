#######
# NAME:
# 	close_board.sh -b <Release Name> -l
#
######
function fn_cls_board_help_echo {
	clear
	echo "------------------------------------------"
	echo "NAME:"
	echo "      close_board.sh -b \<BOARDNAME\>"
	echo ""
	echo "DESCRIPTION:"
	echo "      Closes trello board"
	echo ""
	echo "      -h - Help"
	echo ""
	echo "	    -l - List boards created"
	echo ""
	echo "      -b - Release Name "
	echo "              create_board.sh creates a board name folder along with"
	echo "              a file called list that contains the board id for that board."
	echo               
	echo "              if there is no folder that matches <Board Name> , then error"
	echo
	echo "------------------------------------------"

}


cls_board_BOARD_NAME=

# FETCHING PARAMETERS
if [[ -z $@ ]]; then
	fn_cls_board_help_echo
	exit 1
fi

echo $#
while [[ $# -gt 0 ]]; do
	parm="$1"
	echo $1
	case $parm in
		-h) 
		fn_cls_board_help_echo
		exit 0
		shift
		;;
		-b)
		cls_board_BOARD_NAME="$2"
		shift
		;;
		-l)
		echo " -- List of Boards -- "
		ls boards
		echo
		exit 0
		shift
		;;
		*)
		fn_cls_board_help_echo
		;;
esac
shift
done


# --- Fetching Board ID 
if [ ! -f boards/$cls_board_BOARD_NAME/lists ] ; then
	echo "-E- boards/$cls_board_BOARD_NAME/lists does not exist"
	exit 1
fi

source boards/$cls_board_BOARD_NAME/lists
source token
echo $BOARDID

echo "-I- Closing Board: $cls_board_BOARD_NAME"
echo

cls_board_RESPONSE=$(curl -X PUT -H "Content-Type: application/json" "https://trello.com/1/boards/$BOARDID/closed?key=$KEY&token=$TOKEN" -d '{  "value":true }')

echo $cls_board_RESPONSE

mkdir -p closed_boards/$cls_board_BOARD_NAME
cp -f boards/$cls_board_BOARD_NAME/lists closed_boards/$cls_board_BOARD_NAME
rm -rf boards/$cls_board_BOARD_NAME 
