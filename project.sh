#!/bin/bash

# DBMS 
mkdir DBMS

select_menu_fun(){

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
  case $num1 in 
    1) 
      #show tables
      ;;
    2)
      #create table
      ;;
    3)
      #alter table
      ;;
    4)
	  sortTable
      #sort table
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
      ;;
    *)
      echo "your choose not matched !"
  esac
}
 
create_DB_fun(){
  
  read -p "Enter DB name: " DB_name
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
  
  read -p "Enter DB name: " db_name
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

##################################### Sort #################################################
function sortTable() {

# Ask user to enter the table name that wanted to sort 
  read -p "Please Enter Table Name: " tableName
  if [[ ! -f $tableName ]]; then
  echo "Table not existed "
  tablesMenu
  fi

# Ask to enter the number of field that wanted to sort table according to it
read -p "Please Enter The Name of Column: " colName 
#get the number of field that the user entered his name 
colNum=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' $tableName)

#check if field already existed in table or not
if [[ $colNum == "" ]]; then
  echo "Field Not exist in table"
  tablesMenu
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
      tablesMenu
            ;;
        2 ) if [[ $colType == "int" ]];then

         sed '1d' $tableName  | sort -nr -f -t '|' $colSort ;

      else

         sed '1d' $tableName  | sort -r -f -t '|' $colSort ;
      fi  
      tablesMenu
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
  sed -e -n '1p' $tableName 
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
