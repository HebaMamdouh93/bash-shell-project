#!/bin/bash

# DBMS 
mkdir DBMS

table_menu_fun(){
 
    clear
    echo
    echo " ________ Table menu  ________"
    echo "| 1. Show Tables              |"
    echo "| 2. Create table             |"
    echo "| 3. Alter table              |"
    echo "| 4. Sort table               |"
    echo "| 5. Add record               |"
    echo "| 6. Edit records             |"
    echo "| 7. Delete records           |"
    echo "| 8. Select records           |"
    echo "| 9. Drop table               |"
    echo "| 10. Back to main menu       |"
    echo "| 11. Exit                    |"
    echo "|_____________________________|"
    echo
  
    #user insert choose
    read -p "Enter your choose number: " num1
  
    #check user choose
    while true
    do
    	case $num1 in 
        	1) 
        		#show tables
        		;;
        	2)
        		#create table
        		create_table_fun
        		;;
        	3)
        		#alter table
        		alter_table_fun
        		;;
       		4)
        		#sort table
        		;;
        	5)insert_record
        		#add record
        		;;
      		6)update_menu
        		#edit records
        		;;
        	7)
        		#delete records
        		;;
      		8)
        		#select records
        		;;
      		9)
        		#drop table
        		;;
     		10) 
        		#back to main menu
        		main_menu_fun
        		;;
     		11)
        		#exit
        		exit_fun
        		;;
      		*)
        		matched_fun
        		read -p "Enter your choose number: " num1
    	esac
  	done
}

select_menu_fun(){
  
  	clear
  	read -p "(Select DB) Enter DB name: " name_db
  	if [ -e DBMS/$name_db ] && [ -d DBMS/$name_db ]
  	then
    	 #cd DBMS/$name_db
     	table_menu_fun
  	else
    	 echo "$name_db --> DB not exist !"
     	echo 
     	echo " ________ Menu ________"
     	echo "| 1. Select DB         |"
     	echo "| 2. Back to main menu |"
     	echo "|______________________|"
     	echo 
     	read -p "Enter your choose: " sel
     	while true
     	do
      		case $sel in
         		1)
           			select_menu_fun
           			;;
         		2)
           			main_menu_fun
           			;;
         		*)
           			matched_fun
           			read -p "Enter your choose: " sel
       		esac    
     	done
  	fi
}

create_table_fun(){
  
  	clear

  	column_num=1
  	sep="|"
  	new_line="\n"
  	meta_data="field name|datatype|primary key|constraints"
  	data="" 
  	check_key=0

    read -p "(Create table) Enter table name: " table_name
  	###############    checktable exist or not   ###################
  	if [ ! -f DBMS/$name_db/$table_name ]
  	then
     	read -p "Enter number of columns: " cols_num
     	while true
     	do
      		#################   check number of columns   ###############
       		if [ $cols_num -gt 0 ]
       		then
          		##############   find data of each column  ############
          		while [ $column_num -le $cols_num ]
          		do
              		read -p "Enter name of field number ($column_num) : " colm_name
              		echo
              		echo " ___ choose data type ___"
             	 	echo "| 1. Integer             |"
              		echo "| 2. String              |"
              		echo "|________________________|"
              		echo
              		while true
              		do
                		read -p "Enter data type of ($colm_name) column: " data_type
                		case $data_type in
                   			1)
                     			data_type="int"
                    			break
                     			;;
                   			2)
                     			data_type="string"
                     			break
                     			;;
                   			*)
                     			matched_fun
                		esac
              		done
              		while true
              		do
                		if [ $check_key == 0 ]
                		then
                   			read -p "Is this field ($colm_name) primary key? (y/n) : " key
                   			case $key in
                     			y)
                       				key="key"
                       				check_key=1
                       				break
                       				;;
                     			n)
                       				key="-"
                       				break
                       				;;
                     			*)
                       				matched_fun
                   			esac 
                		else
                   			key="-"
                   			break
                		fi 
            		done
            		if [ $key == "-" ]
            		then
                		echo 
                		echo " ____ Options on field ____"   
                		echo "| 1. Have default value    |"
                		echo "| 2. Not empty             |" 
                		echo "| 3. uniqueness field      |"
                		echo "| 4. No options            |"
                		echo "|__________________________|" 
                		echo
                		while true
                		do
                    		read -p "Enter your choose: " opt_num
                    		case $opt_num in
                        		1)
                            		while true
      		                        do	
           			                	read -p "Enter default value ($data_type) : " value
            		                	opt_num="default|"$value
            	                		if [ $data_type == "int" ]
            							then
            	    						d=$(($value+0)) 
            								if [ $d == 0 ]
            								then
            									continue
            								fi	
      						      		fi
            							break
           						 	done		 
            						break 
                            		;;
                       	        2)
                            		opt_num="notnull"
                            		break
                            		;;
                        		3)
                       	        	opt_num="unique"
                            		break
                            		;;
                        		4)
                            		opt_num="-"
                            		break
                            		;;
                        		*)
                            		matched_fun
                    		esac
                		done
            		fi    
            		if [ $column_num == $cols_num ]
            		then
                		data+=$colm_name
            		else
                		data+=$colm_name$sep
            		fi
            		if [ $key == "key" ]
            		then
            			opt_num="-"
            		fi	
            		meta_data+=$new_line$colm_name$sep$data_type$sep$key$sep$opt_num 
            		column_num=$(( $column_num+1 ))              
          		done
          
       		    #################   create table  ###############
          		touch DBMS/$name_db/$table_name
          		echo -e $data >> DBMS/$name_db/$table_name
          		touch DBMS/$name_db/.$table_name
          		echo -e $meta_data >> DBMS/$name_db/.$table_name
          		if [ -f DBMS/$name_db/$table_name ] && [ -f DBMS/$name_db/.$table_name ]
          		then
              		echo "$table_name --> Table created successfully"
          		else
              		echo "$table_name --> Table can't created !"
          		fi
          		echo
          		echo " ________ Choose ________"
          		echo "| 1. Back to table menu  |"
          		echo "| 2. Exit                |"
          		echo "|________________________|"
          		echo
          		while true
          		do
             		read -p "Enter your choose: " num
             		case $num in
                		1)
                   			table_menu_fun
                   			;;
                		2)
                   			exit_fun
                   			;;
                		*)
                   			matched_fun
             		esac
          		done
       		else
          		echo "You can't creat table with columns number equal to $cols_num "
          		read -p "Enter number of columns: " cols_num
       		fi
     	done
  	else
    	echo "$table_name --> table already exist !"
   	 	echo
   		echo " _________ Menu _________"
   		echo "| 1. Create table        |"
   		echo "| 2. Back to table menu  |"
    	echo "|________________________|"
   		echo
   		read -p "Enter your choose: " num
   		while true
    	do
   			case $num in
       			1)
       				create_table_fun
           			;;
         		2)
           			table_menu_fun
          	 		;;
       			*)
       				matched_fun
       	        	read -p "Enter your choose: " num  
      		esac
    	done
  	fi
}

alter_table_fun(){

  	clear

    echo 
    echo " _________ Alter menu _________"
  	echo "| 1. Add field                 |"
  	echo "| 2. Delete field              |"
  	echo "| 3. Change datatype of field  |"
  	echo "| 4. Change table name         |"
  	echo "| 5. Back to table menu        |"
  	echo "| 6. Exit                      |"
  	echo "|______________________________|"
  	echo 

  	while true
  	do
    	read -p "Enter your choose: " num
     	case $num in
        	1)
          		#add field
          		add_field_fun
          		;;
        	2)
          		#delete field
          		delete_field_fun
          		break
          		;;
        	3)
          		#change datatype of field
          		ch_datatype_field
          		break
          		;;
        	4)
          		#change table name
          		ch_table_name
          		break
          		;;
        	5)
          		table_menu_fun
          		;;
        	6)
          		exit_fun
          		;;
        	*)
          		matched_fun
     	esac
  	done
}
function insert_record(){
   sep="|"
  declare -i count=2
  declare -i fs=0
  declare -a fieldArr=()
  declare -a dataArr=()
  declare -a constrainArr=()
  declare -a idArr=()
  queryIns=""
  intRegex='^[0-9]+$'
  read -p "Insert Table Name:" tableName
  if [ ! -f $tableName ];
    then
      echo "Error: Table Not exsist"
  else
    colsNum=`awk 'END{print NR}' .$tableName`
    #check and store each field
    for (( i = 1; i <= $colsNum; i++ )); do
        fieldName=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' .$tableName)
        dataType=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$tableName)
        PKey=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$tableName)
        fieldArr[$i]=$fieldName
        dataArr[$i]=$dataType
        constrainArr[$i]=$PKey
     done
    #check constraints , datatype for each field  
    for((count=1 ;count<=$colsNum;count++));do
       read -p "Enter ${fieldArr[$count]}:(${dataArr[$count]})=" data
       #check constrain for each field [PK - not null - defaultValue - unique ]
            if [[ ${constrainArr[$count]} == "key" ]]; then
              recordss=`awk 'END{print NR}' $tableName`
                    for (( x = 1; x <= $recordss; x++ )); do
                      fs=$(awk 'BEGIN{FS="|"}{ if(NR=='$x') print $1}' $tableName)
                       if [[ $data == ""  ]];
                         then
                     
                          echo "Error : field must be not null ,try again"
                          table_menu_fun
                       fi

                       if [[ $data ==  $fs ]];
                       then 
                          echo "$fs already exsist , choose another" 
                          table_menu_fun
                       fi
                    done
            elif [[ ${constrainArr[$count]} == "notnull"  ]]; then
              if [[ $data == "" ]];then
                    echo "Error : field must be not null ,try again"
                    table_menu_fun
                fi
            elif [[ ${constrainArr[$count]} == "default" ]]; then
              defVal=$( awk 'BEGIN{FS="|"}{if(NR=='$count') print $4}' .$tableName)
              if [[  $data == "" ]];then
                   data=$defVal
                
              fi  
            elif [[ $data == "unique" ]]; then
                recorda=`awk 'END{print NR}' $tableName`
                    for (( x = 1; x <= $recorda; x++ )); do
                      fu=$(awk 'BEGIN{FS="|"}{ if(NR=='$x') print $1}' $tableName)
                       if [  $data == $fu ];
                       then 
                          echo "$fu already exsist , choose another" 
                           table_menu_fun
                       fi
                    done
            else echo ""
            fi
       #check if datatype is integer
      if [ ${dataArr[$count]}  == "int" ];
        then 
        #check if datatype is match integer
        if [[  $data =~ $intRegex ]];
            then 
             #check unique id 
            if [ ${fieldArr[$count]} == "id" ];
                then 
                  records=`awk 'END{print NR}' $tableName`
                    for (( x = 1; x <= $records; x++ )); do
                      ids=$(awk 'BEGIN{FS="|"}{ if(NR=='$x') print $1}' $tableName)
                       if [[  $data == $ids ]];
                       then 
                          echo "$ids already exsist , try again" 
                           table_menu_fun
                       fi
                    done
            fi
        else
          # error datatype
           echo "Datatype must to be Int , try later"
           table_menu_fun
          fi
     fi
      

       queryIns+="$data $sep"

    done
    #store record in table
     echo $queryIns
     echo $queryIns >> $tableName
     echo "Data Inserted Successfully"
  fi
}
function update_record(){
  sep="|"
intRegex='^[0-9]+$'
declare -i indexF=0
declare -i ids=0
declare -a fieldArr=()
declare -a dataArr=()
declare -a idArr=()
declare -a constrainArr=()
fields=""
read -p "Enter Table Name:" tableName  
if [ ! -f $tableName ];
then
   echo "Error: Table Not exsist"
   # select_menu_fun
else
  colsNum=`awk 'END{print NR}' .$tableName`
    #get the columns Name and data types
  for (( i = 1; i <= $colsNum; i++ )); do
      fieldName=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' .$tableName)
      dataType=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$tableName)
      PKey=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$tableName)
      fieldArr[$i]=$fieldName
      dataArr[$i]=$dataType
      constrainArr[$i]=$PKey
      fields+="| $fieldName "
  done 
  echo  "|------------------------------|"
    echo  "fields are" $fields
    echo  "|------------------------------|"
    read -p "Enter the Number of fields will Be Update:" countF
    read -p "Enter id of row:" rowId
    ids=$(awk 'BEGIN{FS="|"}{ if($1=='$rowId') print NR}' $tableName)
    for((count=1 ;count<=$countF;count++));do
      read -p "Enter column Name:" colName
    #get the index of field 
      for (( x = 1; x <= $colsNum; x++ )); do
          fieldName=$(awk 'BEGIN{FS="|"}{ if(NR=='$x') print $1}' .$tableName)
            if [[ ${fieldArr[$x]} =~ $colName ]];
             then
              indexF=$x
            fi
        done
        #check if field exsist
        if [[ $indexF != 0 ]]; 
        then
        read -p "Enter old value:" oldVal
        read -p "Enter new value:" newVal

        #------------------ check old value valid
        checkO=$(awk 'BEGIN{FS="|"}{if(NR=='$rowId') print $'$indexF'}' $tableName)
          # exit 0
      if [ $checkO == $oldVal ]
        then
             # check constrain for each field [PK - not null - defaultValue - unique ]
              if [[ ${constrainArr[$indexF]} == "key" ]]; then
                recordss=`awk 'END{print NR}' $tableName`
                      for (( z = 1; z <= $recordss; z++ )); do
                        fs=$(awk 'BEGIN{FS="|"}{ if(NR=='$z') print $1}' $tableName)
                        if [[ $newVal == ""  ]];
                           then 
                            echo "Error : field must be not null ,try again"
                            table_menu_fun
                         fi
                         if [  $newVal ==  $fs ];
                         then 
                            echo "$fs already exsist , choose another" 
                             table_menu_fun
                         fi
                      done
              elif [[ ${constrainArr[$indexF]} == "notnull"  ]]; then
                if [[ $newVal == "" ]];then
                      echo "Error : field must be not null ,try again"
                      table_menu_fun
                  fi
              elif [[ ${constrainArr[$indexF]} == "default" ]]; then
                defVal=$( awk 'BEGIN{FS="|"}{if(NR=='$indexF') print $4}' .$tableName)
                if [[ $newVal == "" ]];then
                     newVal=$defVal
                fi  
              elif [[ ${constrainArr[$indexF]}  == "unique" ]]; then
                  recorda=`awk 'END{print NR}' $tableName`
                      for (( x = 1; x <= $recorda; x++ )); do
                        fu=$(awk 'BEGIN{FS="|"}{ if(NR=='$x') print $1}' $tableName)
                         if [[ $newVal == $fu ]];
                         then 
                            echo "$fu already exsist , choose another" 
                             table_menu_fun
                         fi
                      done
              else echo ""
              fi

        #get datatype of field 
          #check if datatype is integer
        if [ ${dataArr[$indexF]}  == "int" ]; 
          then 
          #check if datatype is match integer
             if [[  $newVal =~ $intRegex ]];
           then 
             #update int here
               #------------------ check constraints here

              sed -i "${ids}s/$oldVal/$newVal/" $tableName
              # awk -F, -v oldV="$oldVal" -v newV="$newVal" '{if(NR==1){gsub(oldV ,newV)}1}' $tableName > xx_tmp && mv xx_tmp $tableName
              echo "row Successfully Updated"
           else
            # error datatype
             echo "Datatype must to be Int , try later"
             exit 0
            fi
        else
          # store string data
          # awk -F, -v oldV="$oldVal" -v newV="$newVal" '{gsub(oldV ,newV)}1' $tableName > xx_tmp && mv xx_tmp $tableName
          # awk -F, -v oldV="$oldVal" -v newV="$newVal" '{if(NR==1){gsub(oldV ,newV)}1}' $tableName > xx_tmp && mv xx_tmp $tableName
          sed -i "${ids}s/$oldVal/$newVal/" $tableName
          echo "row Successfully Updated"
        fi
        else
      echo "old value not valid"
      fi
   else
     echo "Field Not exsist"
    fi
done 
fi
}
update_menu(){
  echo " _______________ Update menu ________________"
  echo "| 1. Update Fields With Certain Value        |"
  echo "| 2. Update Fields with Regex                |" 
  echo "| 3. Back To Table Menu                      |"
  echo "| 4. Back To Main Menu                       |"
  echo "| 5. Exit                                    |"
  echo "|____________________________________________|"

  read -p "Enter your choose number: " num3
  case $num3 in
   1)update_record
       ;;
   2)update_regex
      ;; 
   3)table_menu_fun
      ;;
   4)main_menu_fun
      ;;
   5)exit_fun
      ;;
   *)
     matched_fun
  esac

}
update_regex(){
read -p "Enter Table Name:" tableName  
if [ ! -f $tableName ];
then
   echo "Error: Table Not exsist"
   table_menu_fun
else
  read -p "Enter regex update:" regexUp
  read -p "Enter New Value To Update:" newv
  sed  -i "s/$regexUp/$newv/g" $tableName
fi
}
function drop_table(){
read -p "Enter table Name : " tableName
if [ ! -f $tableName ];
then
   echo "Error: Table Not exsist"
 else
  rm $tableName
 fi

}

function show_tables(){
  echo "+--------Tables---------+" 
       ls -lf
  echo "+-----------------------+" 

}
add_field_fun(){
  
    sep="|"
   	while true
   	do
        read -p "(Add field) Enter table name: " table_name
   		if [ -f DBMS/$name_db/$table_name ]
     	then
        	create_field_fun    
        	table_data=$( sed -n '1p' DBMS/$name_db/$table_name )
        	sed -i "s/$table_data/$table_data$sep$colm_name/" DBMS/$name_db/$table_name
        	touch .q
        	sed -n '2,$p' DBMS/$name_db/$table_name > .q
        	while read new_line
        	do
            	sed -i "s/$new_line/$new_line$sep$value/" DBMS/$name_db/$table_name 
        	done < .q
        	rm .p	
        	if [ $key == "key" ]
        	then
        		opt_num="-"
        	fi	
        	table_metadata=$new_line$colm_name$sep$data_type$sep$key$sep$opt_num
        	echo -e $table_metadata >> DBMS/$name_db/.$table_name
        	echo
        	echo "$colm_name --> column added successfully"
        	menu_fun
     	else
        	echo "$table_name --> table not exist"
     	fi
   	done
}

menu_fun(){
 
  	echo
  	echo " ________ Choose ________"
  	echo "| 1. Back to alter menu  |"
  	echo "| 2. Exit                |"
  	echo "|________________________|"
  	while true
  	do
        read -p "Enter your choose: " num
     	case $num in
       		1) 
         		alter_table_fun
         		;;
       		2)
         		exit_fun
         		;;
       		*)
         		matched_fun
     	esac
  	done
}

create_field_fun(){

    value=""
 	read -p "(Create field) Enter name of field: " colm_name
    echo
    echo " ___ choose data type ___"
    echo "| 1. Integer             |"
    echo "| 2. String              |"
    echo "|________________________|"
    echo
    while true
    do
        read -p "Enter data type of ($colm_name) column: " data_type
        case $data_type in
            1)
            	data_type="int"
            	break
            	;;
            2)
            	data_type="string"
            	break
            	;;
            *)
            	matched_fun
      	esac
    done
    while true
    do
        check_key=$(grep -c '|key|' DBMS/$name_db/.$table_name)
        if [ ! $check_key == 1 ]
        then
        	read -p "Is this field ($colm_name) primary key? (y/n) : " key
            if [  $key == "y" ]
            then
            	key="key"
            	break
            elif [ $key == "n" ]
            then
            	key="-"
            	break
            else
            	matched_fun
            fi  	  
        else
            key="-"
            break
        fi
    done
    if [ $key == "-" ]
    then 
    	echo 
    	echo " ____ Options on field ____"   
    	echo "| 1. Have default value    |"
    	echo "| 2. Not empty             |" 
    	echo "| 3. uniqueness field      |"
    	echo "| 4. No options            |"
    	echo "|__________________________|" 
    	echo
    	while true
    	do
      		read -p "Enter your choose: " opt_num
      		if [ $opt_num == 1 ]
      		then
      		    while true
      		    do	
           			read -p "Enter default value ($data_type) : " value
            		opt_num="default|"$value
            		if [ $data_type == "int" ]
            		then
            	    	d=$(($value+0)) 
            			if [ $d == 0 ]
            			then
            				continue
            			fi	
            		fi
            		break
            	done		 
            	break
            elif [ $opt_num == 2 ]
            then	
            	opt_num="notnull"
            	break
         	elif [ $opt_num == 3 ]
         	then	
            	opt_num="unique"
           		break
        	elif [ $opt_num == 4 ]
        	then	
            	opt_num="-"
            	break 
            else       
           		matched_fun
       		fi
   		done
   	fi    
} 

delete_field_fun(){

	clear
	while true
	do
		read -p "(Delete field) Enter name of table: " table_name
		if [ -f DBMS/$name_db/$table_name ]
		then
		    line_data=$(sed -n '1p' DBMS/$name_db/$table_name)
		    echo "Table ($table_name) fields: "$line_data
			while true 
			do
				read -p "(Delete field) Enter name of field: " field_name
				c=$(sed -n "/$field_name/p" DBMS/$name_db/$table_name)
				if [ $c ]  
				then
                    sed -i "/$field_name/d" DBMS/$name_db/.$table_name
                    lines_num=$(wc -l < DBMS/$name_db/$table_name)
                    count=1
                    while [ $count -le $lines_num ]
                    do
                    	var=$(echo $line_data | cut -d'|' -f $count)
                    	if [ $var == $field_name ]
                    	then
                    	    break
                    	fi
                    	count=$((count+1))    
                    done
                    x=$((count-1))
                    xx=1"-"$x
                    y=$((count+1))
                    if [ $y -lt $lines_num ]
                    then
                       yy=$y"-"$lines_num
                    elif [ $y -eq $lines_num ]
                    then	
                       yy=$y
                    else   
                       yy=""
                    fi	
                    xx=$xx","$yy	
                    cut -d'|' -f $xx DBMS/$name_db/$table_name > temp && mv temp DBMS/$name_db/$table_name
                    
                    echo "$field_name --> field deleted successfully"
                    menu_fun
				else
					echo " $field_name --> This field not exist !"
				fi	
			done    
		else
			echo "This table --> $table_name not exist !"
		fi	
	done	
}

ch_datatype_field(){
   
   	clear
   	while true
   	do
    	read -p "(Change Metadata) Enter name of table: " table_name
     	if [ -f DBMS/$name_db/$table_name ]
     	then
        	echo
        	echo " ________ choose ________"
        	echo "| 1. Change datatype     |"
        	echo "| 2. Change primary key  |"
        	echo "| 3. Change options      |"
        	echo "| 4. Back to alter menu  |"
        	echo "| 5. Exit                |"
        	echo "|________________________|"
        	echo
       		while true
       		do
         		read -p "Enter your choose: " num
         		if [ $num == 1 ]
         		then
              		#change datatype
              		ch_datatype_fun
                elif [ $num == 2 ]
                then	 
              		# change key
              		ch_key_fun
                elif [ $num == 3 ]
                then	 
              		#change option
              		ch_option_fun
                elif [ $num == 4 ]
                then	  
              		alter_table_fun
                elif [ $num == 5 ]
                then	
              		exit_fun
                else
              		matched_fun
                fi
       		done
     	else
        	echo "This table --> $table_name not exist !"
     	fi
   	done
}

ch_datatype_fun(){
 
 	clear

 	sep="|"
 	line_data=$(sed -n '1p' DBMS/$name_db/$table_name)
    echo "Table ($table_name) fields: "$line_data
	while true 
	do
 		read -p "(Change datatype) Enter name of field: " field_name	
 		c=$(sed -n "/^$field_name|/p" DBMS/$name_db/.$table_name)
		if [ $c ]  
		then
			new_c=$(echo $c | cut -d'|' -f 1)
			new_c=$new_c$sep
			echo
			echo " ________ Choose ________"
            echo "| 1. Integer             |"
            echo "| 2. String              |"
            echo "|________________________|"
            echo
            while true
            do 
                read -p "(Change datatype) Enter your choose: " num
                if [ $num == 1 ]
                then	
                	num="int"
                	break
                elif [ $num == 2 ]
                then     
                	num="string"
                	break         
                else
                   	matched_fun
                fi	
            done
            new_c=$new_c$num$sep$(echo $c | cut -d'|' -f 3-)
            sed -i "s/$c/$new_c/g" DBMS/$name_db/.$table_name
            echo "$field_name --> datatype update successfully"
            menu_fun
        else
	 		echo " $field_name --> This field not exist !"
		fi	
    done
}

ch_key_fun(){

	clear
	
	sep="|"
	line_data=$(sed -n '1p' DBMS/$name_db/$table_name)
    echo "Table ($table_name) fields: "$line_data
	while true 
	do
 		read -p "(Change primary key) Enter name of field: " field_name	
        c=$(sed -n "/^$field_name|/p" DBMS/$name_db/.$table_name)
		if [ $c ]  
		then
		    key="key"
			new_c=$(echo $c | cut -d'|' -f 1-2)
			new_c=$new_c$sep$key$sep"-"
            z=$(sed -n "/|key|/p" DBMS/$name_db/.$table_name)
            zz=$(echo $z | cut -d'|' -f 1-2)$sep"-"$sep"-"
            sed -i "s/$z/$zz/g" DBMS/$name_db/.$table_name
			sed -i "s/$c/$new_c/g" DBMS/$name_db/.$table_name
			echo "$field_name --> been primary key successfully"
            menu_fun

        else
	 		echo " $field_name --> This field not exist !"
		fi	
    done
}

ch_option_fun(){

	clear

 	sep="|"
 	line_data=$(sed -n '1p' DBMS/$name_db/$table_name)
    echo "Table ($table_name) fields: "$line_data
	while true 
	do
 		read -p "(Change constraints) Enter name of field: " field_name	
 		c=$(sed -n "/^$field_name|/p" DBMS/$name_db/.$table_name)
		if [ $c ]  
		then
		    new_c=$(echo $c | cut -d'|' -f 1-3)
			new_c=$new_c$sep
 			echo 
	    	echo " ____ Options on field ____"   
    		echo "| 1. Have default value    |"
    		echo "| 2. Not empty             |" 
    		echo "| 3. uniqueness field      |"
    		echo "| 4. No options            |"
    		echo "|__________________________|" 
    		echo
    		while true
    		do
      			read -p "(Change constraints) Enter your choose: " opt_num
      			if [ $opt_num == 1 ]
      			then
      		    	while true
      		    	do	
      		    	    data_type=$(echo $c | cut -d'|' -f 2) 
           				read -p "(Change constraints) Enter default value ($data_type) : " value
            			opt_num="default"$sep$value
            			if [ $data_type == "int" ]
            			then
            	    		d=$(($value+0)) 
            				if [ $d == 0 ]
            				then
            					continue
            				fi	
            			fi
            			break
            		done		 
            		break
            	elif [ $opt_num == 2 ]
            	then	
            		opt_num="notnull"
            		break
         		elif [ $opt_num == 3 ]
         		then	
            		opt_num="unique"
           			break
        		elif [ $opt_num == 4 ]
        		then	
            		opt_num="-"
            		break 
            	else       
           			matched_fun
       			fi
   			done
            new_c=$new_c$opt_num$sep$(echo $c | cut -d'|' -f 5-)
            sed -i "s/$c/$new_c/g" DBMS/$name_db/.$table_name
            echo "$field_name --> datatype update successfully"
            menu_fun
        else
	 		echo " $field_name --> This field not exist !"
		fi	
    done
}

ch_table_name(){
  
  clear 
  while true
  do
    read -p "Enter name of table: " table_name
    if [ -f DBMS/$name_db/$table_name ]
    then
      while true
      do
        read -p "Enter new name of table: " new_name
        if [ ! -f DBMS/$namw_db/$new_name ]
        then
           mv DBMS/$name_db/$table_name DBMS/$name_db/$new_name
           mv DBMS/$name_db/.$table_name DBMS/$name_db/.$new_name
           menu_fun
        else
           echo "table with this name ($new_name) already exist !"
         fi
      done
    else
       echo "$table_name --> not exist !"
    fi
  done
}

create_DB_fun(){
  
  read -p "(Create DB) Enter DB name: " DB_name
  if [ ! -e DBMS/$DB_name ] 
  then
     mkdir DBMS/$DB_name
     echo " $DB_name --> DB created successfully."
  else
     echo  " $DB_name --> DB already exist !"
  fi
  echo
}

drop_DB_fun(){
  
  read -p "(Drop DB) Enter DB name: " db_name
  if [ -e DBMS/$db_name ] && [ -d DBMS/$db_name ]
  then
     rm -r DBMS/$db_name
     echo " $db_name --> DB deleted successfully."
  else
     echo  " $db_name --> DB not exist !"
  fi
  echo
}

show_DB_fun(){

  arr_DB=$( ls DBMS )
  echo
  echo " ________ Databases  ________"
  for DB in $arr_DB
  do
    if [ -d DBMS/$DB ]
    then
        echo "| $DB"     
    fi
  done
  echo "|____________________________|"
  echo
}

exit_fun(){
  
  echo "Exit ...."
  echo
  exit
}

matched_fun(){
 
  echo
  echo " ______________________________"
  echo "| your choose not matched !    |"
  echo "|______________________________|"
  echo 

}

main_menu_fun(){

  echo 
  echo " ________ Main menu ________"
  echo "| 1. Select Database        |"
  echo "| 2. Create Database        |"
  echo "| 3. Drop Database          |"
  echo "| 4. Show Database          |"
  echo "| 5. Exit                   |"
  echo "|___________________________|"
  echo

  #user insert choose
  read -p "Enter your choose number: " num
  
  #check user input
  while true
  do
    case $num in 
      1)
         #select DB
         select_menu_fun
         ;;
      2)
         #create DB
         create_DB_fun 
         read -p "Enter your choose number: " num
         ;;
      3)
         #drop DB
         drop_DB_fun
         read -p "Enter your choose number: " num
         ;;
      4)
         #show DB
         show_DB_fun
         read -p "Enter your choose number: " num
         ;;
      5)
         #exit
         exit_fun
         ;;
      *) 
         # not matched
         matched_fun
         read -p "Enter your choose number: " num
    esac
  done
}

clear
main_menu_fun
