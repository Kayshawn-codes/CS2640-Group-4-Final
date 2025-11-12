#CS 2640.02 Group 4 11/12/25

#This application is a banking app that supports basic functions such as deposits and withdrawls
#Users can sign up as well as log in to accounts. Additonal features include freezing
#accounts and transfering/sharing access.
.includ "Basic_Functions.asm"
.include "Main_menu.asm"

.data
signInResponse: .space 4
userInput: .asciiz "User input value: "
.text
main:
	
   signInMenu(signInResponse)
   printStr(userInput)
   li $v0, 1
   lb $a0, signInResponse
   syscall

exit:
   li $v0, 10
   syscall