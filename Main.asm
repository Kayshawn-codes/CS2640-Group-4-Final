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
buffer: .space 50000
loginFail:  .asciiz "User and Password not found."
.align 2
signInResponse:   .space 4
userNumber: .space 4

.text
main:
   openMenu(signInResponse) #1. login, 2. sign up, 3. exit
   lb $s0, signInResponse
   beq $s0, 1, login
   beq $s0, 2, signUp
   beq $s0, 3, exit
   beq $s0, 4, debug
   j main
signUp:
   signUpMenu
   j main
login:
   loginMenu(userNumber)
   lb $s0, userNumber
   bgt $s0, $zero, user_menu
   
   j main
user_menu: #If user successfully logs in 
   main_menu(userNumber)

exit:
   #Exiting the program
   li $v0, 10
   syscall

.data
   debugIntro: .asciiz "----------Debug Menu----------\n"
   debugMenu1: .asciiz "1. Attempt to open the file for reading\n2. Attempt to open the file for writing\n3. Attempt to oppen for append\n4.Attempt to write to the file\n"
   debugMenu2: .asciiz "5.Attempt to close the file\n6. Check file descriptor.\n7. Return\n"
   openOutput: .asciiz "Attempted to open the file.\n"
   writeOutput: .asciiz "Attempted to write\n"
   writeString: .asciiz "Append data\n"
   closeOutput: .asciiz "Attempted to close the file.\n"
   descIs: .asciiz "File descriptor is: "
   lbr: .asciiz "\n" 
   input: .asciiz "Select an option: "
   .align 2
   desc: .word
.text
debug:
   printStr(debugIntro)
   printStr(debugMenu1)
   printStr(debugMenu2)
   printStr(input)
   
   li $v0, 5
   syscall
   beq $v0, 1, openRead
   beq $v0, 2, openWrite
   beq $v0, 3, openAppend
   beq $v0, 4, write
   beq $v0, 5, close
   beq $v0, 6, showDesc
   beq $v0, 7, main
openRead:
   openFileDebug(0, desc)
   printStr(openOutput)
   j debug
openWrite:
   openFileDebug(1, desc)
   printStr(openOutput)
   j debug
openAppend:
   openFileDebug(9, desc)
   printStr(openOutput)
   j debug

write:
   writeStringToFile(writeString, desc)
   printStr(writeOutput)
   j debug
close:
   closeFile(desc)
   printStr(closeOutput)
   j debug
showDesc:
   printStr(descIs)
   lw $t0, desc
   li $v0, 1
   move $a0, $t0
   syscall
   printStr(lbr)
   j debug
   
   
