#######
# NAME:
#       archive_all_cards.sh -b <Release Name> -l <list name>
#
######
set -e
source common_functions

function fn_arch_card_help_echo {
        clear
        echo "------------------------------------------"
        echo "NAME:"
        echo "      archive_all_cards.sh -b \<Release Name\> -l <list name>"
        echo ""
        echo "DESCRIPTION:"
        echo "      Archives all cards cards for a given list"
        echo ""
        echo "      -h - Help"
        echo "      -ll - List Board Names"
        echo ""
        echo "      -l - List Name where cards are to be archived"
        echo ""
        echo "      -b - Release Name "
        echo
        echo "              if there is no folder that matches <Release Name> , then error"
        echo
        echo "------------------------------------------"

}

arch_card_BOARD_NAME=
arch_card_LIST_NAME=

if [[ -z $@ ]]; then
        fn_arch_card_help_echo
        exit 1
fi


while [[ $# -gt 0 ]]; do
        parm="$1"
        case $parm in
                -h)
                fn_arch_card_help_echo
                exit 0
                shift
                ;;
                -ll)
		fn_common_fns_list_boards
                exit 0
                shift
                ;;
                -b)
                arch_card_BOARD_NAME="$2"
                shift
                ;;
                -l)
                arch_card_LIST_NAME="$2"
                shift
                ;;
                *)
                fn_arch_card_help_echo
                ;;
esac
shift
done

if [[ -z $arch_card_BOARD_NAME ]] || [[ -z $arch_card_LIST_NAME ]] ; then
	fn_arch_card_help_echo
	exit 1
fi

# --- FETCHING BOARD ID

if [ ! -f boards/$arch_card_BOARD_NAME/lists ] ; then
        echo "-E- boards/$arch_card_BOARD_NAME/lists does not exist"
        exit 1
fi


source boards/$arch_card_BOARD_NAME/lists
source token

echo "-I- Fetching List Id"
echo 
arch_card_LISTID=$(fn_common_fns_fetch_list_id $arch_card_LIST_NAME "$GLOB_LISTS_LISTID") 


echo "-I- Archiving cards for LIST $arch_card_LIST_NAME : $arch_card_LISTID"
echo 

arch_card_RESPONSE=$(curl -i  -X POST -H "Content-Type: application/json" "https://trello.com/1/lists/"$arch_card_LISTID"/archiveAllCards?key=$KEY&token=$TOKEN")

echo "-I- Response from Trello:"
echo
echo $arch_card_RESPONSE
