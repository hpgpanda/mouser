#!/bin/bash
for i in 0 1 2 3 4 5 6 7
do 
	Qty=$(jq .SearchResults.Parts[0].PriceBreaks[$i].Quantity temp.json)
	#echo $Qty
	#echo .
	if [ $Qty == "null" ]; then
		exit 0
	fi

	Price=$(jq .SearchResults.Parts[0].PriceBreaks[$i].Price temp.json | cut -d \" -f2)
	echo -e $Qty "\t" $Price
done
