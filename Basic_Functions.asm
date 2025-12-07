#CS 2640.02 
#Group 4: Kayshawn W., Jacob L., Jahnvi L., Samuel O.
#12/07/25

#Basic functions that will be used across multiple files

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

.macro openFile(%flag, %fd) #immediate value containing open flag, memorry address for the file descriptor
   li $v0, 13
   la $a0, fileName
   li $a1, %flag
   li $a2, 0
   syscall
   sw $v0, %fd #Save file descriptor
.end_macro

.macro readFile(%buffer, %size, %bytesRead, %fd) #memory address of buffer, immediate size value, \
					   #register to hold num bytes read, memory address holding file descriptor
   li $v0, 14
   lw $a0, %fd
   la $a1, %buffer
   li $a2, %size
   syscall
   move %bytesRead, $v0
.end_macro

.macro appendFile(%buffer, %reg, %fd)
   li $v0, 15
   lw $a0, %fd
   la $a1, %buffer
   move $a2, %reg
   syscall
.end_macro

.macro closeFile(%fd)
   li $v0, 16
   move $a0, $s0
   syscall
.end_macro

.macro writeStringToFile(%data, %fd)
   la $t0, %data
   li $t1, 0
      
   loop:
   lb $t3, 0($t0)
   beq $t3, $zero, appendToFile
   addi $t0, $t0, 1
   addi $t1, $t1, 1
   b loop	

   appendToFile:
   appendFile(%data, $t1, %fd)
.end_macro

.macro writeIntToFile(%intValue, %intBuffer, %fd)
   lw $t0, %intValue
   la $t1, %intBuffer 
   
   li $t2, 100000
   li $t3, 0
   
   conversion:
   div $t0, $t2
   mflo $t4
   addi $t4, $t4, 48
   sb $t4, ($t1)
   addi $t1, $t1, 1
   mfhi $t0
   
   beq $t2, 1, done
   li $t5, 10
   div $t2, $t5
   mflo $t2
   
   done:
   sb $zero, ($t1)
   
   writeStringToFile(%intBuffer, %fd)
.end_macro

.data
spacer: .asciiz "----------------------------------------------------"
linebreak: .asciiz "\n"
fileName2: .asciiz "User_Data.txt"
.align 2
buffer2: .space 50000

