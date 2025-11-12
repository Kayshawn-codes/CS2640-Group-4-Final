#CS 2640.02 Group 4 11/12/25

#This application is a banking app that supports basic functions such as deposits and withdrawls
#Users can sign up as well as log in to accounts. Additonal features include freezing
#accounts and transfering/sharing access.
.include "Basic_Functions.asm"
.include "Main_menu.asm"

.data
file: .asciiz "User_Data.txt"
signInResponse: .space 4
.text
main:
	
   signInMenu(signInResponse) #1. login, 2. sign up, 3. exit
   lb $s0, signInResponse
   beq $s0, 1, exit
   beq $s0, 2, signUp
   beq $s0, 3, exit
signUp:
   signUpMenu
   

exit:
   li $v0, 10
   syscall