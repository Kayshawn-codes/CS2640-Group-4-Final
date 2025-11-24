#CS 2640.02 11/12/25

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
