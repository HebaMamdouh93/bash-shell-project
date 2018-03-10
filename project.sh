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
        ;;
      4)
        #sort table
 	sortTable
        ;;
      5)
        #add record
        ;;
      6)
        #edit records
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
  meta_data="name|datatype|key|extra"
  data="" 
  check_key=0

  read -p "Enter table name: " table_name
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
                        read -p "Enter default value: " value
                        opt_num="value=$value" 
                        break  
                        ;;
                     2)
                        opt_num="not empty"
                        break
                        ;;
                     3)
                        opt_num="uniqueness"
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
              if [ $column_num == $cols_num ]
              then
                  data+=$colm_name
              else
                  data+=$colm_name$sep
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
  echo "| 5. Back To Select Menu                                |"
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
         #Back To Select Menu
         selectMenu
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
  read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  selectMenu
  fi 
  
  awk 'BEGIN {FS="|"} {print $0}' $tableName 
} 

#Select Specific Column from a Table
function select_col(){

# Ask user to enter the table name  
  read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  selectMenu
  fi

  # Ask to enter the number of field that wanted to reterive data from it
  read -p "Please Enter The Number of Column :" colNum

  awk 'BEGIN {FS="|"} {print $'$colNum'}' $tableName

  selectMenu
}

#Select All Columns Matching a Certain Regex 
function select_all_regex(){

clear 
echo "Select * From [Table] Where [Field] = [Certain regex]"

# Ask user to enter the table name  
  read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  selectMenu
  fi

# Ask user to enter the name of required field
read -p "Please Enter The required Field Name: " fieldName

#get the number of field that the user entered his name 
fieldNum=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$fieldName'") print i}}}' $tableName)

#check if field already existed in table or not
if [[ $fieldNum == "" ]]; then
  echo "Field Not exist in table"
  selectMenu
else

#Ask user to enter the regex that he/she wants to search for data according to it
read -p "Please Enter The required Regex value: " regexPattern

awk 'BEGIN {FS="|"} { if($'$fieldNum' ~ /'$regexPattern'/) print $0; }' $tableName

#Ask user to print the selected records in html format or csv format 
echo -e "Enter Type of format choose 1) HTML  or choose 2) CSV : "
  select fileFormat in "1" "2"
    do
      read -p "Please Enter the Name of file:" fName
      case $fileFormat in

        1 )  
            awk 'BEGIN {FS="|" ; print"<html><head></head><body>"; } {
if(NR==1) print "<h4>" $0 "</h4>";  
if($'$fieldNum' ~ /'$regexPattern'/) print $0  "</br>"; }   

END{print "</body></html>"}
' $tableName > $fName.html
selectMenu
            ;;
        2 )
 awk 'BEGIN {FS="|" ; } {
if(NR==1) {gsub("|",",",$0); print $0} ;  
if($'$fieldNum' ~ /'$regexPattern'/) {gsub("|",",",$0); print $0} ; }   
' $tableName  > $fName.csv
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
  read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  selectMenu
  fi

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
awk 'BEGIN {FS="|";  OFS = "|"} {
if(NR==1) print '$fieldNums';   
if($'$fNum' ~ /'$regexPattern'/) {  print '$fieldNums' }; }' $tableName

#Ask user to print the selected records in html format or csv format 
echo -e "Enter Type of format choose 1) HTML  or choose 2) CSV : "
  select fileFormat in "1" "2"
    do
      read -p "Please Enter the Name of file:" fName
      case $fileFormat in

        1 )  
            awk 'BEGIN {FS="|" ; OFS = "|"; print"<html><head></head><body>"; } {
      if(NR==1) print "<h4>" '$fieldNums' "</h4>";    
      if($'$fNum' ~ /'$regexPattern'/) {  print '$fieldNums' "</br>" ;} 
      END{print "</body></html>"}
      ' $tableName > $fName.html
      selectMenu
            ;;
        2 )
       awk 'BEGIN {FS="|" ; } {
      if(NR==1) print '$fieldNums';   
      if($'$fNum' ~ /'$regexPattern'/) {  print '$fieldNums' }; }   
      ' $tableName > $fName.csv
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
  read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  table_menu_fun
  fi

# Ask to enter the number of field that wanted to sort table according to it
read -p "Please Enter The Name of Column: " colName 
#get the number of field that the user entered his name 
colNum=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' $tableName)

#check if field already existed in table or not
if [[ $colNum == "" ]]; then
  echo "Field Not exist in table"
  table_menu_fun
else
  colSort="-k"$colNum
  colType=$( awk 'BEGIN{FS="|"}{if(NR=='$colNum+1') print $2}' .$tableName)
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
      table_menu_fun
            ;;
        2 ) if [[ $colType == "int" ]];then

         sed '1d' $tableName  | sort -nr -f -t '|' $colSort ;

      else

         sed '1d' $tableName  | sort -r -f -t '|' $colSort ;
      fi  
      table_menu_fun
            ;;
        * ) echo "Wrong Choice" ;;
      esac
    done
fi  
 

}
######################################## Delete Records #####################################
function deleteMenu(){
  echo 
  echo " _________________ Delete menu _________________________"
  echo "| 1. Delete All from Table [Truncate table]             |"
  echo "| 2. Delete records under Condition                     |"
  echo "| 3. Back To Delete Menu                                |"
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
         deleteMenu
         ;;
      4)
         #Back To Main Menu
         cd ../..
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
  read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  deleteMenu
  fi
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
  read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  deleteMenu
  fi

# Ask user to enter the name of required field that deleted its data according to certain regex
read -p "Please Enter The required Field Name: " fName 

#get the number of field that the user entered his name 
fNum=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$fName'") print i}}}' $tableName)

#check if field already existed in table or not
if [[ $fNum == "" ]]; then
  echo "Field Not exist in table"
  deleteMenu
else

  #Ask user to enter the regex that he/she wants to search for data according to it
  read -p "Please Enter The required Regex value: " regexPattern 
  NR=$(awk 'BEGIN {FS="|"} { if($'$fNum' ~ /'$regexPattern'/) print NR"d;"; }' $tableName)

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
clear
main_menu_fun
