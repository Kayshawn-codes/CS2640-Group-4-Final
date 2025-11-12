#CS 2640.02 Group 4 11/12/2025

#Functions for the main menu of the application
.include "Basic_Functions.asm"

.macro signInMenu(%response)
   .data
   header: .asciiz "-------------------------Main Menu-------------------------\n"
   opening: .asciiz "Welcome to *Name Pending* banking app.\n"
   prompt: .asciiz "What would you like to do?\n"
   option1: .asciiz "1. Log in. \n"
   option2: .asciiz "2. Sign up. \n"
   option3: .asciiz "3. Exit the application. \n"
   inputErr: .asciiz "Invalid input. Please try again.\n"
   .text
   menu: #Provide the menu to the user
   printStr(header)
   printStr(opening)
   printStr(prompt)
   printStr(option1)
   printStr(option2)
   printStr(option3)
   recieve: #tTake their response
   li $v0, 5
   syscall
   
   errorCheck: #Ensure valid input
   ble $v0, 0, error
   bge $v0, 4, error
   j exit #If input is valid continue to exit
   error:
   printStr(inputErr)
   j menu
   exit: #If input was valid store it in response and exit
   sb $v0, %response
.end_macro
.data
spacer: .asciiz "----------------------------------------------------"
.text