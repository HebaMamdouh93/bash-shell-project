------------------------	
Bash script DBMS Project
------------------------
Team Member:
_______________________________________________________________________

Name: Nada Adel Elsayed --> github username: nadaadel
Name: Heba Mamdouh Ali --> github username: HebaMamdouh93
Name: Ghada Khamis Mohamed --> github username: ghadakhamis

_______________________________________________________________________

1) run file project.sh using command --> bash project.sh

#Main Features for Batabase:
----------------------------
1- user can choose from menu by insert number of his choose

 __________________________________________ Main menue _______________________________________________
|                                                                                                     |
| 1. select database --> Enter name of database exist already to can use the feature of tables        |
| 2. create database --> add database to the system by enter its name but must by not used before     |
| 3. Drop database --> delete database from the system by Enter its name                              |
| 4. show databases --> display all databases in the system                                           |
| 5. exit --> used it to close the program                                                            |
|_____________________________________________________________________________________________________|

#Main Features for Tables:
--------------------------
1-Create table
 - user at first insert name of the table must not used before 
 - asked to enter number of fields
 - then asked to Enter meta data of each field
    - ask about name (unque for the same table)
    - datatype of the field
    - asked if this field primary key or not if there is no primary key created yet
    - asked to Enter constraints (unique, not null, have default value, no options) 
 - after that table created successfully


---------------------------
2-insert record
  user can insert data in table after checks like datatype e.g(int , string) and constraints e.g(unique , not null ,etc)
-------------------------
3-Update record
user can get the update menu for 2 options:
1- user can update a certain field 
2- user can update column by regular expression "Regex" by enter the regex and the new value to update 
---------------------------------------------------------------
4-Alter table
 user can select options from this menu

 __________________________________________ Alter table _________________________________________________________________
|                                                                                                                        |
| 1. add field --> add new field to exist table, ask user to Enter meta data for this field                              |
| 2. delete field --> delete field from exist table, ask user to enter name of this field                                |
| 3. change data type of field --> ask user to enter field name and check if this field exist or not and if empty or not |
| 4. change table name --> ask user to enter name of exist table and the new name(not used before)                       |
| 5. change field name --> ask user to enter table name then name of exist field at last ask to enter the new name       |
| 6. back to main menu -->  back to  the previous menu                                                                   |
| 7. exit --> close program                                                                                              |
|________________________________________________________________________________________________________________________|

---------------------------------------------------------------
5-show tables
user can list all table in a certain database by choose "show tables" option from menu
---------------------------------------------------------------

6-delete from table
user has two optios:
1)truncate table (Delete all records and not delete the structure of the table )
2)delete a certain records that match a certain regex user entered it
----------------------------------------------------------------

7-drop table
user can drop a certain table in a certain database by choose "drop table" and enter the table name
-----------------------------------------------------------------

8-select records from table
user has 4 options :
1) Select all data from  a certain table exist in a certain database
2) Select a certain column from table
3) Select all records from table that match a certain regex user entered it
4) Select certain colums from table that match a certain regex user entered it
------------------------------------------------------------------------ 

9-Sort Table
user can sort a certain table in a certain database by enter the name of column that wants to sort its data and choose if he/she wants to sort table ascend​ingly or descendingly.
------------------------------------------------------------------------
