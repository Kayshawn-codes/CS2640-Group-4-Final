#CS 2640.02 Group 4 11/12/2025

#Functions for the main menu of the application

.macro openMenu(%response)
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

.macro signUpMenu
   .data
   userNamePrompt: .asciiz "Please enter a desired username: \n"
   username: .space 26
   passwordPrompt: .asciiz "Please enter a desired password: \n"
   password: .space 26
   firstNamePrompt: .asciiz "Please enter your first name: \n"
   firstName: .space 51
   lastNamePrompt: .asciiz "Please enter your last name: \n"
   lastName: .space 51
   .text 
   #Ask the user for each piece of information, then store it in the appropriate space
   printStr(userNamePrompt)
   readStr(username, 26)
   printStr(passwordPrompt)
   readStr(password, 26)
   printStr(firstNamePrompt)
   readStr(firstName, 51)
   printStr(lastNamePrompt)
   readStr(lastName, 51)
   
   #Testing address placement
   #printStr(username)
   #printStr(password)
   #printStr(firstName)
   #printStr(lastName)
.end_macro

.macro loginMenu(%user_number) #memory address for a user to login. Zero if failed or invalid.
   .data
   userPrompt: .asciiz "Please enter your username: "
   username: .space 26
   passPrompt: .asciiz "Please enter your password: "
   password: .space 26
   
   .text
   #Get the user's username and password
   printStr(userPrompt)
   readStr(username, 26)
   printStr(passPrompt)
   readStr(password, 26)
   
.end_macro

