awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' $1 >> $2
