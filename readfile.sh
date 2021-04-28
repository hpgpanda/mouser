#!/bin/bash
keyword=1SMB5937BT3G
apikey=4fa17cc0-7c23-4e11-93b1-187896d3a46f
url="https://api.mouser.com/api/v1/search/keyword?apiKey=$apikey"
accept="accept: application/json"
content="Content-Type: application/json"
json="{ \"SearchByKeywordRequest\": { \"keyword\": \"$keyword\", \"records\": 0, \"startingRecord\": 0, \"searchOptions\": \"string\", \"searchWithYourSignUpLanguage\": \"string\" }}"

echo keyword=$keyword
echo apikey=$apikey
echo url=$url
echo accept=$accept
echo content=$content
echo json=$json

for keyword in $(cat bom)
do
	echo $keyword
	echo .
done

#curl -X POST "$url" -H "$accept" -H "$content" -d "$json" > $1
