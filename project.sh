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

clear
main_menu_fun
