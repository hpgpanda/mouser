#!/bin/bash
keyword=1SMB5937BT3G
apikey=4fa17cc0-7c23-4e11-93b1-187896d3a46f
url="https://api.mouser.com/api/v1/search/keyword?apiKey=$apikey"
accept="accept: application/json"
content="Content-Type: application/json"
json="{ \"SearchByKeywordRequest\": { \"keyword\": \"$keyword\", \"records\": 0, \"startingRecord\": 0, \"searchOptions\": \"string\", \"searchWithYourSignUpLanguage\": \"string\" }}"
text=


#echo $keyword

#search manufacturepartnumber, and add partnumber to record: $text. 
function manufacturepartnumber(){
	ManufacturePartNumber=$(jq .SearchResults.Parts[0].ManufacturerPartNumber temp.json | cut -d \" -f2)
	if [ "$keyword" == "$ManufacturePartNumber" ];then 
		text=$text","$ManufacturePartNumber
	else
		text=$text",Error------"$ManufacturePartNumber
	fi
}


#search keyword , and return MOQ to record: $text.
function moq(){
    for i in 0 1 2 3 4 
    do 
	PartType=$(jq .SearchResults.Parts[0].ProductAttributes[$i].AttributeName temp.json | cut -d \" -f2)
	#echo $PartType
	#echo .
	if [ $PartType == "标准包装数量" ];then
		MOQ=$(jq .SearchResults.Parts[0].ProductAttributes[$i].AttributeValue temp.json | cut -d \" -f2)
		#echo $MOQ
		text=$text","$MOQ
	fi
    done
}

function stock(){
    Stock=$(jq .SearchResults.Parts[0].Availability temp.json | cut  -d " " -f1 | cut -d \" -f2)
    text=$text","$Stock
}

function price(){
    for i in 0 1 2 3 4 5 6 7
    do 
	Qty=$(jq .SearchResults.Parts[0].PriceBreaks[$i].Quantity temp.json)
	#echo $Qty
	#echo .
	if [ $Qty == "null" ]; then
		#exit 0
		return 0
	fi

	Price=$(jq .SearchResults.Parts[0].PriceBreaks[$i].Price temp.json | cut -d \" -f2)
	#echo -e $Qty "\t" $Price
	text=$text","$Qty","$Price
    done
}

#function readbom(){
#}



function batchbom(){
    j=0
    cat $file | while read keyword
    do 
	json="{ \"SearchByKeywordRequest\": { \"keyword\": \"$keyword\", \"records\": 0, \"startingRecord\": 0, \"searchOptions\": \"string\", \"searchWithYourSignUpLanguage\": \"string\" }}"
	curl -X POST "$url" -H "$accept" -H "$content" -d "$json" > temp.json 2>/dev/null
	jq .SearchResults.NumberOfResult temp.json
	while true
	do
		if [ $? == "0" ];then break; fi
		echo $?
		curl -X POST "$url" -H "$accept" -H "$content" -d "$json" > temp.json 2>/dev/null
		jq .SearchResults.NumberOfResult temp.json
		
	done 
	#sleep 3
	#echo $keyword
	text=$keyword
	manufacturepartnumber
	stock
        moq
	price
	echo $text
	echo $text >> bom.csv
	sleep 0
	rm temp.json
	text=
	let j++
	#echo j=$j
	if [ $(($j%50)) == 0 ]; then 
	    echo sleep now
	    sleep 3
	fi
    done 
}



function onekeyword(){
	cat bom.csv | grep -v $keyword > bom1.csv
	mv bom1.csv bom.csv
	json="{ \"SearchByKeywordRequest\": { \"keyword\": \"$keyword\", \"records\": 0, \"startingRecord\": 0, \"searchOptions\": \"string\", \"searchWithYourSignUpLanguage\": \"string\" }}"
	curl -X POST "$url" -H "$accept" -H "$content" -d "$json" > temp.json 2>/dev/null
	jq .SearchResults.NumberOfResult temp.json
	while true
	do
		if [ $? == "0" ];then break; fi
		echo $?
		curl -X POST "$url" -H "$accept" -H "$content" -d "$json" > temp.json 2>/dev/null
		jq .SearchResults.NumberOfResult temp.json
	done	
	#sleep 3
	#echo $keyword
	text=$keyword
	manufacturepartnumber
	stock
        moq
	price
	echo $text
	echo $text >> bom.csv
	sleep 0
	rm temp.json
	text=
}


###--------main program----------------####
option=$1
case $option in 
    -f) file=$2
	if [ -f "./bom.csv" ];then
	    rm bom.csv
	fi
	touch bom.csv
	batchbom
	;;
    -s) keyword=$2
	onekeyword
	;;
    *)
	echo "$(basename $0):usage: [-f bomfile] | [-s keyword]"
	exit 1
	;;
esac
