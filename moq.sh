#!/bin/bash
for i in 0 1 2 3 4 
do 
	PartType=$(jq .SearchResults.Parts[0].ProductAttributes[$i].AttributeName temp.json | cut -d \" -f2)
	#echo $PartType
	#echo .
	if [ $PartType == "标准包装数量" ];then
		MOQ=$(jq .SearchResults.Parts[0].ProductAttributes[$i].AttributeValue temp.json | cut -d \" -f2)
		echo $MOQ
	fi
done
PartType=
