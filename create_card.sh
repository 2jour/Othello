# NAME:
#       close_board.sh -b <Release Name> -l
#
######
source common_functions

function fn_create_card_help_echo {
        clear
        echo "------------------------------------------"
        echo "NAME:"
        echo "      create_card.sh  -c <NAME OF CARD> -b \<BOARDNAME\> -l <LIST NAME> -f <FILE NAME WITH CARD INFO>"
        echo ""
        echo "DESCRIPTION:"
        echo "      Closes trello board"
        echo ""
        echo "      -h - Help"
        echo "      -ll - List Board Names"
	echo 
	echo "      -c - Name of Card" 
        echo ""
        echo "      -l - List Name where card will be inserted"
        echo ""
        echo "      -b - Release Name "
        echo "              create_board.sh creates a board on trello with the release name. The board id and list id are stored in  folder board/BOARDNAME/lists "
        echo
        echo "              if there is no folder that matches <Board Name> , then error"
        echo
	echo
	echo " 	    -f - (Optional) Filename which contains card description and checklist items" 
        echo "------------------------------------------"

}


create_card_BOARD_NAME=
create_card_LIST_NAME=
create_card_CARD_NAME=
create_card_FILE_NAME=

# -- FETCHING PARAMETERS

if [[ -z $@ ]]; then
        fn_create_card_help_echo
        exit 1
fi


while [[ $# -gt 0 ]]; do
        parm="$1"
        case $parm in
                -h)
                fn_create_card_help_echo
                exit 0
                shift
                ;;
                -ll)
                fn_common_fns_list_boards
                exit 0
                shift
                ;;
                -b)
                create_card_BOARD_NAME="$2"
                shift
                ;;
                -l)
                create_card_LIST_NAME="$2"
                shift
                ;;
                -c)
                create_card_CARD_NAME="$2"
                shift
                ;;
                -f)
                create_card_FILE_NAME="$2"
                shift
                ;;
                *)
                fn_create_card_help_echo
                ;;
esac
shift
done

if [[ -z $create_card_BOARD_NAME ]] || [[ -z $create_card_LIST_NAME ]] || [[ -z $create_card_CARD_NAME ]]; then
        fn_create_card_help_echo
        exit 1
fi

# --- FETCHING BOARD ID

if [ ! -f boards/$create_card_BOARD_NAME/lists ] ; then
        echo "-E- boards/$arch_card_BOARD_NAME/lists does not exist"
	fn_common_fns_list_boards
        exit 1
fi


source boards/$create_card_BOARD_NAME/lists
source token

echo "-I- Fetching List Id"
echo
create_card_LISTID=$(fn_common_fns_fetch_list_id $create_card_LIST_NAME "$GLOB_LISTS_LISTID")



create_card_RESPONSE=$(curl -i  -X POST -H "Content-Type: application/json" "https://trello.com/1/cards?key=$KEY&token=$TOKEN" -d '{ "name":"'"$create_card_CARD_NAME"'","due":null, "idList":"'$create_card_LISTID'" }')

echo $create_card_RESPONSE
