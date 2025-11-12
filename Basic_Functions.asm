#CS 2640.02 11/12/25

#Basic functions that will be used accross multiple files

.macro printStr(%str)
   li $v0, 4
   la $a0, %str
   syscall
.end_macro