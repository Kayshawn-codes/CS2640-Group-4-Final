#CS 2640.02 
#Group 4: Kayshawn W., Jacob L., Jahnvi L., Samuel O.
#12/07/25

#This application is a banking app that supports basic functions such as deposits and withdrawls
#Users can sign up as well as log in to accounts. Additonal features include freezing
#accounts and transfering/sharing access.
.include "Basic_Functions.asm"
.include "Open_menu.asm"
.include "User_Menu.asm"

.data
fileName:   .asciiz "User_Data.txt"
loginFail:  .asciiz "User and Password not found."
signInResponse:   .space 4
userNumber: .space 4

.text
main:
   openMenu(signInResponse) #1. login, 2. sign up, 3. exit
   main_menu(userNumber)
   lb $s0, signInResponse
   beq $s0, 1, login
   beq $s0, 2, signUp
   beq $s0, 3, exit
signUp:
   signUpMenu
   j main
login:
   loginMenu(userNumber)
   lb $s0, userNumber
   bgt $s0, $zero, user_menu
   loginFailure:
   printStr(loginFail) 
   j main
user_menu: #If user successfully logs in 
   main_menu(userNumber)

exit:
   #Exiting the program
   li $v0, 10
   syscall
