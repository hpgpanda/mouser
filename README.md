# mouser
  1. usage: mouser.sh [-f filename] | [-s keyword]  
  	filename: keyword list filename    
	keyword:  keyword for search partnumber  

  2. mouser.sh -f filename   
	read every keyword in filename, and write the result to new bom.csv  

  3. mouser.sh -s keyword  
	search keyword, and append the result into bom.csv .  
	if the keyword is already in the bom.csv , delete it, and append again.  

