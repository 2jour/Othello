source token
source lists

curl -i  -X POST -H "Content-Type: application/json" "https://trello.com/1/cards?key=$KEY&token=$TOKEN" -d '{ "name":"moneky","due":null, "idList":"'$LISTID'" }'
