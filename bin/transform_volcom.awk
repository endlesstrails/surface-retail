#!/usr/bin/awk -f

##########################################################################################
# Transform FC System .csv file to KWI-VOLCOM-ARTICLE-yyMMdd-141002.TXT format
# 

BEGIN {
	FS="\t";
	#OFS="|"; #Not needed for printf
	"date +'%-m/%-d/%Y'"|getline d;
}
{
	if(NR!=1) {  # Don't include the header row.
		if(length($10) > 0) {  # Don't include rows with a blank upc field.
		
		# #################################################################
		# Variables
		# These values are calculated once per line.
		#
		
		# Sub Class
		subClass=$4 substr($5,3)
		
		# Prepack Qty		
		prepackQty="1"

		if(index($14, "P") > 0){
			prepackQty=substr($14, length($14) - 1)
		} 
		if(index($14, "/") > 0){
			#prepackQty=substr($14, 0, length($14) - index($14, "/"))
			prepackQty=substr($14, index($14, "/") + 1, 1)
		}
		
		# Color max length: 30
		color=$7
		if(length($7) > 30){
			color=substr($7, 0, 30)
		}
		
		# Color Code max length: 6
		colorCode=$6
		if(length($6) > 6){
			color=substr($6, 0, 6)
		}
		
		# Size
		size="N/A"
		if(length($14) > 0){
			if(index($14, "EA") > 0){
				#size is already = N/A
			} else {
				if($13=="XX"){
					if(index($14, "P") > 0 || index($14, "/") > 0){
						if(index($14, "P")){
							#size already = N/A
						} else {
							size=$14
						}						
					} else {
						size=$14
					}
				} else {
					size=$14 "x" $13  # The SPACE character is the concatenation operator in awk.
				}
			}
		}
		
		# Wholesale Price
		wPrice=$16
		
		# Retail Price
		rPrice=$17
		
		# Season
		suffix=""
		if(substr($18, 0, 2) == "SU"){
			suffix="U"
		} 
		else if(substr($18, 0, 2) == "SP"){
			suffix="S"
		}
		else if(substr($18, 0, 2) == "SN"){
			suffix="W"
		}
		else if(substr($18, 0, 2) == "FA"){
			suffix="F"
		}	
		else if(substr($18, 0, 2) == "OF"){
			suffix="O"
		}
		else if(substr($18, 0, 2) == "HO"){
			suffix="H"
		}
				
		season=substr($18, length($18) - 1) suffix

		# Labeled Cost
		labledCost=""
		labledCost=$19

		# Calculated Price
		cPrice=""
		cPrice=$16*.55
		
		# ###########
		# Print File
		#
			printf "%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%.2f|%.2f|%s|%s|%s|%.2f|%.2f\r\n", 
			substr($10, 0, length($10) - 1) 	    \
			, "1"									\
			, $3									\
			, $4									\
			, subClass								\
			, $1									\
			, substr($2, 0, 40)						\
			, substr($2, 0, 15) 					\
			, prepackQty							\
			, color									\
			, colorCode								\
			, size									\
			, wPrice   								\
			, rPrice   								\
			, season	                        	\
			, d 									\
			, labledCost							\
			, cPrice								\
			, rPrice   								\
		}
	}
	
}