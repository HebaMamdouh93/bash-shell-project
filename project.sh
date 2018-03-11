#!/bin/bash

# DBMS 
mkdir DBMS

table_menu_fun(){

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
        show_tables
        back_fun
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
 	      sortTable
        ;;
      5)
        #add record
        insert_record
        back_fun
        ;;
      6)
        #edit records
	      update_menu
        ;;
      7)
        #delete records
	      deleteMenu
        ;;
      8)
        #select records
        selectMenu
        ;;
      9)
        #drop table
        drop_table
        back_fun
        ;;
      10) 
        #back to main menu
        cd ../..
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

back_fun(){

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
}

back_create_table(){

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
}

data_type_fun(){

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
}

select_menu_fun(){
  
  read -p "(Select DB) Enter DB name: " name_db
  if [ -e DBMS/$name_db ] && [ -d DBMS/$name_db ]
  then
    cd DBMS/$name_db
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
          #select DB
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

  column_num=1
  sep="|"
  new_line="\n"
  meta_data=""
  data="" 
  check_key=0

  read -p "(Create table) Enter table name: " table_name
  ###############    checktable exist or not   ###################
  if [ ! -f $table_name ]
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
          data_type_fun
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
                    key="default|"$value
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
                  key="notnull"
                  break
                  ;;
                3)
                  key="unique"
                  break
                  ;;
                4)
                  key="-"
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
          if [ $column_num == 1 ]
          then
            meta_data+=$colm_name$sep$data_type$sep$key 
          else
            meta_data+=$new_line$colm_name$sep$data_type$sep$key    
          fi  
            column_num=$(( $column_num+1 ))              
          done
          #################   create table  ###############
          touch $table_name
          echo -e $data >> $table_name
          touch .$table_name
          echo -e $meta_data >> .$table_name
          if [ -f $table_name ] && [ -f .$table_name ]
          then
            echo "$table_name --> Table created successfully"
          else
            echo "$table_name --> Table can't created !"
          fi
          back_fun
        else
          echo "You can't creat table with columns number equal to $cols_num "
          read -p "Enter number of columns: " cols_num
        fi
      done
    else
      echo "$table_name --> table already exist !"
      back_create_table
    fi
}

alter_table_fun(){

  echo 
  echo " _________ Alter menu _________"
  echo "| 1. Add field                 |"
  echo "| 2. Delete field              |"
  echo "| 3. Change datatype of field  |"
  echo "| 4. Change table name         |"
  echo "| 5. Change field name         |"
  echo "| 6. Back to table menu        |"
  echo "| 7. Exit                      |"
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
        #change field name
        ch_field_name
        break
        ;;  
      6)
        table_menu_fun
        ;;
      7)
        exit_fun
        ;;
      *)
        matched_fun
    esac
  done
}

ch_field_name(){

  while true
  do
    read -p "(Change field name) Enter table name: " table_name
    if [ -f $table_name ]
    then
      first_line=$(sed -n '1p' $table_name)
      echo
      echo " table fields: $first_line"
      echo
      while true
      do
        read -p "(Change field name) Enter field name: " field_name
        check_field=$(sed -n "/^$field_name|/p" .$table_name)

        if [ ! $check_field == "" ]
        then
          while true
          do 
            read -p "Enter new name of field ($field_name): " new_f_name
            check_field=$(sed -n "/$new_f_name/p" .$table_name)
            if [ $check_field ]
            then
              echo "There is a field has the same name !"
            else
              sed -i "s/^$field_name|/$new_f_name|/g" .$table_name
              sed -i "s/$field_name/$new_f_name/" $table_name
              echo
              echo "Field name changed successfully"
              menu_fun
            fi
          done    
        else
          echo "$field_name --> field name not exist"
        fi
      done  
      menu_fun 
    else
      echo "$table_name --> table not exist"
    fi    
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
  strRegex='^[a-zA-Z]+$'
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
                    for (( x = 2; x <= $recordss-1; x++ )); do
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
          if [[ ! $data =~ $intRegex ]];
          then 
             echo "Datatype must to be Int , try later"
             table_menu_fun
          fi
          #check if datatype match string
        elif [ ${dataArr[$count]}  == "string" ]; then
          if [[ ! $data =~ $strRegex ]];
          then 
             echo "Datatype Accept String  only , try later"
             table_menu_fun
          fi
       fi

       queryIns+="$data$sep"

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
strRegex='^[a-zA-Z]+$'
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
    table_menu_fun
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
    # read -p "Enter the Number of fields will Be Update:" countF
    read -p "Enter id of row:" rowId
    ids=$(awk 'BEGIN{FS="|"}{ if($1=='$rowId') print NR}' $tableName)
    # for((count=1 ;count<=$countF;count++));do
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
        checkO=$(awk 'BEGIN{FS="|"}{if($1 =='$rowId') print $'$indexF'}' $tableName)
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
                            update_menu
                         fi
                         if [  $newVal ==  $fs ];
                         then 
                            echo "$fs already exsist , choose another" 
                             update_menu
                         fi
                      done
              elif [[ ${constrainArr[$indexF]} == "notnull"  ]]; then
                if [[ $newVal == "" ]];then
                      echo "Error : field must be not null ,try again"
                      update_menu
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
                             update_menu
                         fi
                      done
              else echo ""
              fi

        #get datatype of field 
          #check if datatype is integer
        if [ ${dataArr[$indexF]}  == "int" ]; 
          then 
          #check if datatype is match integer
             if [[ ! $newVal =~ $intRegex ]];
           then 
             echo "Datatype must to be Int , try later"
             update_menu
          else
            sed -i "${ids}s/$oldVal/$newVal/" $tableName
                  echo "row Successfully Updated"
                  update_menu
             fi
      elif [  ${dataArr[$indexF]}   == "string" ]; then
            if [[ ! $newVal =~ $strRegex ]];
            then 
               echo "Datatype Accept String  only , try later"
               update_menu
            else
              sed -i "${ids}s/$oldVal/$newVal/" $tableName
          echo "row Successfully Updated"
          update_menu
            fi
        fi
        else
      echo "old value not valid"
      fi
   else
     echo "Field Not exsist"
    fi
# done 
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
  echo "Regex Match Updated Successfully"
fi
}
function drop_table(){
read -p "Enter table Name : " tableName
if [ ! -f $tableName ];
then
   echo "Error: Table Not exsist"
 else
  rm $tableName
  rm .$tableName
  echo "$tableName --> table deleted successfully."
 fi

}

function show_tables(){
  echo "+--------Tables---------+" 
       ls -p | grep -v /
  echo "+-----------------------+" 

}
add_field_fun(){
  
    sep="|"
    while true
    do
        read -p "(Add field) Enter table name: " table_name
      if [ -f $table_name ]
      then
          create_field_fun    
          table_data=$( sed -n '1p' $table_name )
          sed -i "s/$table_data/$table_data$sep$colm_name/" $table_name
          touch .q
          sed -n '2,$p' $table_name > .q
          while read new_line
          do
              sed -i "s/$new_line/$new_line$sep$value/" $table_name 
          done < .q
          rm .q  
          table_metadata=$new_line$colm_name$sep$data_type$sep$key
          echo -e $table_metadata >> .$table_name
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
  data_type_fun
  while true
  do
    check_key=$(grep -c '|key' .$table_name)
    if [  $check_key == 0 ]
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
          key="default|"$value
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
        key="notnull"
        break
      elif [ $opt_num == 3 ]
      then  
        key="unique"
        break
      elif [ $opt_num == 4 ]
      then  
        key="-"
        break 
      else       
        matched_fun
      fi
    done
  fi    
} 

delete_field_fun(){

  while true
  do
    read -p "(Delete field) Enter name of table: " table_name
    if [ -f $table_name ]
    then
        line_data=$(sed -n '1p' $table_name)
        echo "Table ($table_name) fields: "$line_data
      while true 
      do
        read -p "(Delete field) Enter name of field: " field_name
        c=$(sed -n "/$field_name/p" $table_name)
        if [ $c ]  
        then
                    lines_num=$(wc -l < .$table_name)
                    sed -i "/$field_name/d" .$table_name
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
                    if [ ! $yy == "" ]
                    then

                        xx=$xx","$yy
                    fi      
                    cut -d'|' -f $xx $table_name > temp && mv temp $table_name
                    
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
   
  while true
  do
    read -p "(Change Metadata) Enter name of table: " table_name
    if [ -f $table_name ]
    then
      #change datatype
      ch_datatype_fun
    else
      echo "This table --> $table_name not exist !"
    fi
  done
}

ch_datatype_fun(){
 
  sep="|"
  line_data=$(sed -n '1p' $table_name)
  echo "Table ($table_name) fields: "$line_data
  while true 
  do
    read -p "(Change datatype) Enter name of field: " field_name  
    c=$(sed -n "/^$field_name|/p" .$table_name)
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
      sed -i "s/$c/$new_c/g" .$table_name
      echo "$field_name --> datatype update successfully"
      menu_fun
    else
      echo " $field_name --> This field not exist !"
    fi  
  done
}

ch_table_name(){
  
  while true
  do
    read -p "Enter name of table: " table_name
    if [ -f $table_name ]
    then
      while true
      do
        read -p "Enter new name of table: " new_name
        if [ ! -f $new_name ]
        then
           mv $table_name $new_name
           mv .$table_name .$new_name
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
################################## SELECT & SORT #############################################
#select Part
function selectMenu(){
  echo 
  echo " _________________ Select menu _________________________"
  echo "| 1. Select All from a Table                            |"
  echo "| 2. Select Specific Column from a Table                |"
  echo "| 3. Select All Columns Matching a Certain Regex        |"
  echo "| 4. Select Specific Column Matching a Certain Regex    |"
  echo "| 5. Back To Options Menu                               |"
  echo "| 6. Back To Main Menu                                  |"
  echo "| 7. Exit                                               |"
  echo "|_______________________________________________________|"
  echo	

  while true
  do
  	#user insert choose
    read -p "Enter your choose number: " num

    #check user input
    case $num in 
      1) 
         #Select All from a Table 
         select_All
         ;;
      2)
         #Select Specific Column from a Table
         select_col
         ;;
      3)
         #Select All Columns Matching a Certain Regex 
         select_all_regex 
         ;;
      4)
         #Select Specific Column Matching a Certain Regex
         select_col_regex
         ;;
      5)
         #Back To options Menu
         table_menu_fun
         ;;
      6)
         #Back To Main Menu
         cd ../..
         main_menu_fun
         ;;
      7)
         #Exit
         exit_fun
         ;;   
      *) 
         # not matched
         matched_fun
    esac
  done
}

#Select All from a Table
function select_All(){
# Ask user to enter the table name  
  ask_user_Tname
  
printed_data=$(awk 'BEGIN {FS="|"} {print $0}' $tableName)
echo $printed_data | tr ' ' '\n'

#Ask user to print the selected records in html format or csv format 
echo -e "Enter Type of format choose 1) HTML  or choose 2) CSV : "
read -p "Please Enter the Name of file:" fName

  select fileFormat in "1" "2"
    do
      
      case $fileFormat in

        1 )
        if [[ -f $fName.html ]]; then
  echo "File already existed "
  selectMenu
  fi  
        awk 'BEGIN{FS="|" ; print"<html><head><style>h1{text-align:center;} span{color:red;font-size:20px;font-weight:bold;} label{font-size:20px}</style></head><body> <h1>'$tableName'</h1>";}
                  {
                  if(NR==1)
                    {
                      for(i=1;i<=NF;i++){ split($0,header,"|") }
                    }
                  else{
                    for(i=1;i<=NF;i++){
          
                   print "<span>" header[i] "</span> : <label>" $i  "</label></br>"
                  }
                   print "<hr>"
                }
                }
                END{print "</body></html>"
              }' $tableName > $fName.html
              echo "File saved successfully"
           read -p "Do You want to open file on browser[y/n]?" ans
            if [[ $ans == "y" ]];then
                xdg-open "$fName.html"
            fi

              selectMenu
            ;;
        2 )
        if [[ -f $fName.csv ]]; then
  echo "File already existed "
  selectMenu
  fi
            echo "$printed_data"  | tr '|' ',' > $fName.csv
            echo "File saved successfully"
            read -p "Do You want to open file on browser[y/n]?" ans
            if [[ $ans == "y" ]];then
                libreoffice "$fName.csv"
            fi
            
            
            selectMenu
            ;; 
        * ) echo "Wrong Choice" ;;
      esac
    done
} 

#Select Specific Column from a Table
function select_col(){

# Ask user to enter the table name  
ask_user_Tname

# Ask user to enter the name of required field
get_field_num

#check if field already existed in table or not
if [[ $fieldNum == "" ]]; then
  echo "Field Not exist in table"
  selectMenu
else

  printed_data=$(awk 'BEGIN {FS="|"} {print $'$fieldNum'}' $tableName)
echo $printed_data | tr ' ' '\n'
#Ask user to print the selected records in html format or csv format 
echo -e "Enter Type of format choose 1) HTML  or choose 2) CSV : "
read -p "Please Enter the Name of file:" fName

  select fileFormat in "1" "2"
    do
      
      case $fileFormat in

        1 )if [[ -f $fName.html ]]; then
  echo "File already existed "
  selectMenu
  fi  
        awk 'BEGIN{FS="|" ; print"<html><head><style> table {margin:0 auto;} h1{text-align:center;} span{color:red;font-size:30px;font-weight:bold;} label{font-size:20px}</style></head><body> <h1>'$tableName'</h1> <table border=1>";}
                  {
                  if(NR==1)
                    {
                      print "<tr><td><span>" $'$fieldNum' "</span></td></tr></br>"
                    }
                  else{
                   
          
                   print "<tr><td><label>"  $'$fieldNum'  "</label></td></tr></br>"
                  
                  
                }
                }
                END{print "</table></body></html>"
              }' $tableName > $fName.html
           echo "File saved successfully"
           read -p "Do You want to open file on browser[y/n]?" ans
            if [[ $ans == "y" ]];then
                xdg-open "$fName.html"
            fi
              selectMenu
            ;;
        2 )
        if [[ -f $fName.csv ]]; then
  echo "File already existed "
  selectMenu
  fi
echo "$printed_data"  | tr '|' ',' > $fName.csv
echo "File saved successfully"
read -p "Do You want to open file on browser[y/n]?" ans
            if [[ $ans == "y" ]];then
                libreoffice "$fName.csv"
            fi
selectMenu
            ;;
        * ) echo "Wrong Choice" ;;
      esac
    done

  selectMenu
fi
}

#Select All Columns Matching a Certain Regex 
function select_all_regex(){

clear 
echo "Select * From [Table] Where [Field] = [Certain regex]"

# Ask user to enter the table name  
ask_user_Tname

# Ask user to enter the name of required field
get_field_num

#check if field already existed in table or not
if [[ $fieldNum == "" ]]; then
  echo "Field Not exist in table"
  selectMenu
else

#Ask user to enter the regex that he/she wants to search for data according to it
read -p "Please Enter The required Regex value: " regexPattern

printed_data=$(awk 'BEGIN {FS="|" ; } {
if(NR==1) { print $0} ;  
if($'$fieldNum' ~ /'$regexPattern'/) {print $0} ; }   
' $tableName)
echo $printed_data | tr ' ' '\n'
#Ask user to print the selected records in html format or csv format 
echo -e "Enter Type of format choose 1) HTML  or choose 2) CSV : "
read -p "Please Enter the Name of file:" fName

  select fileFormat in "1" "2"
    do
      
      case $fileFormat in

        1 )
                  if [[ -f $fName.html ]]; then
            echo "File already existed "
            selectMenu
            fi  
        awk 'BEGIN{FS="|" ; print"<html><head><style>h1{text-align:center;} span{color:red;font-size:20px;font-weight:bold;} label{font-size:20px}</style></head><body> <h1>'$tableName'</h1>";}
                  {
                  if(NR==1)
                    {
                      for(i=1;i<=NF;i++){ split($0,header,"|") }
                    }
                  else{
                    for(i=1;i<=NF;i++){
          
                  if($'$fieldNum' ~ /'$regexPattern'/) print "<span>" header[i] "</span> : <label>" $i  "</label></br>"
                  }
                  if($'$fieldNum' ~ /'$regexPattern'/) print "<hr>"
                }
                }
                END{print "</body></html>"
              }' $tableName > $fName.html
           echo "File saved successfully"
           read -p "Do You want to open file on browser[y/n]?" ans
            if [[ $ans == "y" ]];then
                xdg-open "$fName.html"
            fi
              selectMenu
            ;;
        2 )
        if [[ -f $fName.csv ]]; then
  echo "File already existed "
  selectMenu
  fi
echo "$printed_data"  | tr '|' ',' > $fName.csv
echo "File saved successfully"
read -p "Do You want to open file on browser[y/n]?" ans
            if [[ $ans == "y" ]];then
                libreoffice "$fName.csv"
            fi
selectMenu
            ;;
        * ) echo "Wrong Choice" ;;
      esac
    done

selectMenu  
fi

}

#Select Specific Column Matching a Certain Regex
function select_col_regex(){
clear 
echo "Select [specific field] From [Table] Where [Field] = [Certain regex]"

# Ask user to enter the table name  
ask_user_Tname

# Ask user to enter the name of required field
read -p "Please Enter The Fields Name that wanted to select data from it: " fieldName
#split the fields name into array
IFS=' ' read -r -a array <<< "$fieldName"
#get the number of each field that the user entered his name  and store them into array
for element in "${array[@]}"
do
fieldNum=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$element'") print i}}}' $tableName)
if [[ $fieldNum == "" ]]; then
  echo "Field [ $element ] Not exist in table"
  selectMenu
else
  fieldNums+='$'$fieldNum','
fi
done
fieldNums=${fieldNums::-1}

# Ask user to enter the name of required field that searched for data according to certain regex
read -p "Please Enter The required Field Name to search for data: " fName 
#get the number of field that the user entered his name 
fNum=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$fName'") print i}}}' $tableName)

#check if field already existed in table or not
if [[ $fNum == "" ]]; then
  echo "Field Not exist in table"
  selectMenu
else

#Ask user to enter the regex that he/she wants to search for data according to it
read -p "Please Enter The required Regex value: " regexPattern
printed_data=$(awk 'BEGIN {FS="|";  OFS = "|"} {
if(NR==1) print '$fieldNums';   
if($'$fNum' ~ /'$regexPattern'/) {  print '$fieldNums' }; }' $tableName)

echo $printed_data | tr ' ' '\n'  

#Ask user to print the selected records in html format or csv format 
echo -e "Enter Type of format choose 1) HTML  or choose 2) CSV : "
read -p "Please Enter the Name of file:" fName

  select fileFormat in "1" "2"
    do
      
      case $fileFormat in

      1 ) 
          if [[ -f $fName.html ]]; then
      echo "File already existed "
      selectMenu
      fi 
      awk -v var="$fieldName" 'BEGIN{FS="|" ; print"<html><head><style>h1{text-align:center;} span{color:red;font-size:20px;font-weight:bold;} label{font-size:20px}</style></head><body><h1>'$tableName'</h1>";}
                  {
                    
                  if(NR!=1)
                    {
                       
                       split("'$fieldNums'",fNums,",")
                       split(var,header," ")

                    for(i in fNums){
                     
                  if($'$fNum' ~ /'$regexPattern'/) print "<span>" header[i] "</span> : <label>" $i "</label></br>"
                
                  
                  }
                  if($'$fNum' ~ /'$regexPattern'/) print "<hr>"
                
                }}
                END{print "</body></html>"
            
              }' $tableName > $fName.html
              echo "File saved successfully"
           read -p "Do You want to open file on browser[y/n]?" ans
            if [[ $ans == "y" ]];then
                xdg-open "$fName.html"
            fi
      selectMenu
            ;;
      2 )
      if [[ -f $fName.csv ]]; then
  echo "File already existed "
  selectMenu
  fi
      echo "$printed_data" | tr '|' ',' > $fName.csv
      echo "File saved successfully"
read -p "Do You want to open file on browser[y/n]?" ans
            if [[ $ans == "y" ]];then
                libreoffice "$fName.csv"
            fi
        selectMenu
                  ;;
        * ) echo "Wrong Choice" ;;
      esac
    done

selectMenu  
fi
} 

##################################### Sort #################################################
function sortTable() {

# Ask user to enter the table name that wanted to sort 
ask_user_Tname

# Ask to enter the number of field that wanted to sort table according to it
get_field_num

#check if field already existed in table or not
if [[ $fieldNum == "" ]]; then
  echo "Field Not exist in table"
  table_menu_fun
else
  colSort="-k"$fieldNum
  colType=$( awk 'BEGIN{FS="|"}{if(NR=='$fieldNum') print $2}' .$tableName)
  echo -e "Enter Type of Sort choose 1) sort ascend​ing or choose 2) sort descending : "
  select sortType in "1" "2"
    do
      head -1 $tableName;
      case $sortType in

        1 )  
       
             if [[ $colType == "int" ]];then
             
         sed '1d' $tableName  | sort -n -f -t '|' $colSort ;

      else

         sed '1d' $tableName  | sort -f -t '|' $colSort ;
      fi  
      break
      #table_menu_fun
            ;;
        2 ) if [[ $colType == "int" ]];then
           
         sed '1d' $tableName  | sort -nr -f -t '|' $colSort ;

      else
          
         sed '1d' $tableName  | sort -r -f -t '|' $colSort ;
      fi  
      #table_menu_fun
      break
            ;;
        * ) echo "Wrong Choice" ;;
      esac
      
    done
    table_menu_fun
fi  
 

}
######################################## Delete Records #####################################
function deleteMenu(){
  echo 
  echo " _________________ Delete menu _________________________"
  echo "| 1. Delete All from Table [Truncate table]             |"
  echo "| 2. Delete records under Condition                     |"
  echo "| 3. Back To Options Menu                               |"
  echo "| 4. Back To Main Menu                                  |"
  echo "| 5. Exit                                               |"
  echo "|_______________________________________________________|"
  echo  

  while true
  do
    #user insert choose
    read -p "Enter your choose number: " num

    #check user input
    case $num in 
      1)
         #Delete All from Table [Truncate table]
         truncate_table
         ;;
      2)
         #Delete records under Condition 
         delete_records
         ;;
      3)
         #Back To Delete Menu 
         table_menu_fun
         ;;
      4)
         #Back To Main Menu
         #cd ../..
         main_menu_fun
         ;;
      5)
         #Exit
         exit_fun
         ;;   
      *) 
         # not matched
         matched_fun
    esac
  done
}

function truncate_table(){
# Ask user to enter the table name  
ask_user_Tname

 #truncate table 
  
  sed -n '1p' $tableName > temp && mv temp $tableName
 #check if table truncated successfully or not 
  if [[ $? == 0 ]]
  then
    echo "Table [$tableName] truncated successfully"
  else
    echo "Error Truncate Table $tableName"
  fi
}

function delete_records(){
#delete from [tableName] where [fieldName]==[certain_Pattern]
# Ask user to enter the table name  
ask_user_Tname

# Ask user to enter the name of required field that deleted its data according to certain regex
get_field_num

#check if field already existed in table or not
if [[ $fieldNum == "" ]]; then
  echo "Field Not exist in table"
  deleteMenu
else

  #Ask user to enter the regex that he/she wants to search for data according to it
  read -p "Please Enter The required Regex value: " regexPattern 
  NR=$(awk 'BEGIN {FS="|"} { if($'$fieldNum' ~ /'$regexPattern'/) print NR"d;"; }' $tableName)

  if [[ $NR == "" ]]; then
    echo "Regex Not matched in table"
    deleteMenu
  else
    sed -i -e "${NR}" $tableName
    if [[ $? == 0 ]]
      then
        echo "data deleted successfully"
      else
        echo "Error delete data from Table $tableName"
      fi

  fi 
fi
}


##############################################################################################
##################################### Helper Functions ######################################
# Function to Ask user to enter the table name 
function ask_user_Tname(){
 read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  table_menu_fun
  fi  
}

function get_field_num(){
echo "The Table [$tableName] has Fields :"
awk 'BEGIN{FS="|"}{if(NR==1){ print $0 }}' $tableName
# Ask user to enter the name of required field
read -p "Please Enter The required Field Name: " fieldName

#get the number of field that the user entered his name 
fieldNum=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$fieldName'") print i}}}' $tableName)
}

clear
main_menu_fun
