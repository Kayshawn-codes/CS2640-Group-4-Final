#CS 2640.02 
#Group 4: Kayshawn W., Jacob L., Jahnvi L., Samuel O.
#12/07/25

#Basic functions that will be used across multiple files

#String I/O macros
# printStr: Display string to console
# %str - memory location of null-terminated string
.macro printStr(%str)
   li $v0, 4
   la $a0, %str
   syscall
.end_macro

# readStr: Read user input string
# %returnAddress - memory location to store input string
# %size - integer value, maximum characters to read
.macro readStr(%returnAddress, %size)
   li $v0, 8
   la $a0, %returnAddress
   li $a1, %size
   syscall
.end_macro

# readStrW: Read user input with size warning display
# %returnAddress - memory location to store input string
# %size - integer value, maximum characters (displayed to user)
.macro readStrW(%returnAddress, %size)
.data
   part1: .asciiz "(Max characters: "
   part2: .asciiz ")\n"
.text
   printStr(part1)
   li $v0, 1
   li $a0, %size
   syscall
   printStr(part2)
   
   readStr(%returnAddress, %size)   
.end_macro

#Integer I/O macros
# printInt: Display integer to console
# %int - register containing integer value
# %offset - immediate integer value to add to %int
.macro printInt(%int, %offset)
   li $v0, 1
   move $a0, %int
   addi $a0, $a0, %offset
   syscall
.end_macro

#Global data for file operations
.data
spacer: .asciiz "----------------------------------------------------"
linebreak: .asciiz "\n"
fileName2: .asciiz "User_Data.txt"
buffer2: .space 50000

#File operation macros
# openFile: Open file and save descriptor to $s0
# %flag - integer value (0=read, 1=write, 9=append)
.macro openFile(%flag)
   li $v0, 13
   la $a0, fileName
   li $a1, %flag
   li $a2, 0
   syscall
   move $s0, $v0 #Save file descriptor
.end_macro

# readFile: Read data from open file
# %buffer - memory location to store file content
# %size - integer value, maximum bytes to read
# %reg - register to store number of bytes actually read
.macro readFile(%buffer, %size, %reg)
   li $v0, 14
   move $a0, $s0
   la $a1, %buffer
   li $a2, %size
   syscall
   move %reg, $v0
.end_macro

# appendFile: Write data to open file
# %buffer - memory location of data to write
# %reg - register containing number of bytes to write
.macro appendFile(%buffer, %reg)
   li $v0, 15
   move $a0, $s0
   la $a1, %buffer
   move $a2, %reg
   syscall
.end_macro

# closeFile: Close currently open file (uses $s0 descriptor)
# No parameters required
.macro closeFile
   li $v0, 16
   move $a0, $s0
   syscall
.end_macro

#Data conversion and writing macros
# writeStringToFile: Calculate string length and write to file
# %data - memory location of null-terminated string
.macro writeStringToFile(%data)
   la $t0, %data
   li $t1, 0
      
   loop:
   lb $t3, 0($t0)
   beq $t3, $zero, appendToFile
   addi $t0, $t0, 1
   addi $t1, $t1, 1
   b loop	

   appendToFile:
   appendFile(%data, $t1)
.end_macro

# writeIntToFile: Convert integer to string and write to file
# %intValue - memory location containing integer value
# %intBuffer - memory location to store converted string (6+ bytes)
.macro writeIntToFile(%intValue, %intBuffer)
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
   
   writeStringToFile(%intBuffer)
.end_macro



