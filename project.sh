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
  echo "| 1. Select Specific Column from a Table                |"
  echo "| 2. Select All Columns Matching a Certain Regex        |"
  echo "| 3. Select Specific Column Matching a Certain Regex    |"
  echo "| 4. Back To Select Menu                                |"
  echo "| 5. Back To Main Menu                                  |"
  echo "| 6. Exit                                               |"
  echo "|_______________________________________________________|"
  echo	

  while true
  do
  	#user insert choose
    read -p "Enter your choose number: " num

    #check user input
    case $num in 
      1)
         #Select Specific Column from a Table
         select_col
         ;;
      2)
         #Select All Columns Matching a Certain Regex 
         select_all_regex 
         ;;
      3)
         #Select Specific Column Matching a Certain Regex
         select_col_regex
         ;;
      4)
         #Back To Select Menu
         selectMenu
         ;;
      5)
         #Back To Main Menu
         cd ../..
         main_menu_fun
         ;;
      6)
         #Exit
         exit_fun
         ;;   
      *) 
         # not matched
         matched_fun
    esac
  done
}

#Select Specific Column from a Table
function select_col(){
echo "select_col"
}

#Select All Columns Matching a Certain Regex 
function select_all_regex(){
echo "select_all_regex"
}

#Select Specific Column Matching a Certain Regex
function select_col_regex(){
echo "select_col_regex"
} 

function sortTable() {

echo "sort"	

}



##############################################################################################
clear
main_menu_fun
