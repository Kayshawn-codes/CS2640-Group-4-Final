#CS 2640.02 
#Group 4: Kayshawn W., Jacob L., Jahnvi L., Samuel O.
#12/07/25

#Basic functions that will be used accross multiple files

.macro printStr(%str)
   li $v0, 4
   la $a0, %str
   syscall
.end_macro

.macro readStr(%returnAddress, %size) #Should be called with a storage location for input and a size
   #Recieve user string
   li $v0, 8
   la $a0, %returnAddress
   li $a1, %size
   syscall
.end_macro

.macro readStrW(%returnAddress, %size) #Read string but give a warning for string size:
   .data
   part1: .asciiz "(Max characters: "
   part2: .asciiz ")\n"
   
   .text
   #Indicate the maximum characters the user can input
   printStr(part1)
   li $v0, 1
   li $a0, %size
   syscall
   printStr(part2)
   
   readStr(%returnAddress, %size)   
.end_macro

.macro printInt(%int, %offset) #Register and immediate offset
   li $v0, 1
   move $a0, %int
   addi $a0, $a0, %offset
   syscall
.end_macro
.data
spacer: .asciiz "----------------------------------------------------"
linebreak: .asciiz "\n"

.macro openFile(%flag)
	li $v0, 13
	la $a0, fileName
	li $a1, %flag
	li $a2, 0
	syscall
	move $s0, $v0 #Save file descriptor
.end_macro

.macro appendFile(%buffer, %reg)
   li $v0, 15
	move $a0, $s0
	la $a1, %buffer
	move $a2, %reg
	syscall
.end_macro

.macro closeFile
	li $v0, 16
	move $a0, $s0
	syscall
.end_macro

.macro generateUserNumber
.end_macro


