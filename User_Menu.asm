#CS 2640.02 
#Group 4: Kayshawn W., Jacob L., Jahnvi L., Samuel O.
#12/07/25

.macro main_menu(%userNumber)
   .data 
      userName:   .space 26
      password:   .space 26
      firstName:  .space 51
      lastName:   .space 51
      accountsDisplay:  .asciiz "---Open Accounts---"
      menuOptions1:  .asciiz "\n What would you like to do?\n"
      menuOptions2:  .asciiz "1. Deposit\n2. Withdraw.\n3. Exit"
      errMsg:  .asciiz "Invalid input. Please try again"

   .text
   mainMenu_menu:
      greeting(firstName)
      printStr(accountsDisplay)
      showAccounts(%userNumber) #Will dynamically read file to determine the number of accounts
      printStr(menuOptions1)
      printStr(menuOptions2) #Prompt the user
      
      li $v0, 5
      syscall #Take the input and respond
      beq $v0, 1, deposit_
      beq $v0, 2, withdraw_
      beq $v0, 3, mainMenu_exit
      j inputErr  # Default case for invalid input
      
      inputErr:
         printStr(errMsg)
         j mainMenu_menu
         
      deposit_:
         deposit(%userNumber)
         j mainMenu_menu  # Return to menu after deposit
         
      withdraw_:
         withdraw(%userNumber)
         j mainMenu_menu  # Return to menu after withdraw
         
      mainMenu_exit:
       
.end_macro

.macro greeting(%name)
   .data
      greeting1: .asciiz "Hello, "
      greeting2: .asciiz "!"
   .text
      printStr(greeting1)
      li $v0, 4
      la $a0, %name
      syscall
      printStr(greeting2)      
.end_macro

.macro showAccounts(%userNumber)
   .data
   display1: .asciiz "Account "
   display2: .asciiz " : "
   hasMore: .word 1 #If hasMore is set to 0 then stop looping
   
   .text
   showAccounts_start:
      li $t0, 1 #Loop counter, use to know which account you're searching for
      showAccounts_loop:
         printStr(display1)
         printInt($t0, 0)
         printStr(display2)
         printStr(linebreak)
         
         #findAccount(%userNumber, $t0, hasMore) #Should print out the account info and update hasMore
                                                #if there are no more accounts
         lw $t2, hasMore
         bne $t2, 0, showAccounts_loop 
.end_macro

.macro deposit(%userNumber)
.end_macro

.macro withdraw(%userNumber)
   .data
      prompt1: .asciiz "Withdraw from which account?(0 to exit)\n"
      prompt2_1: .asciiz "How much to withdraw from account " 
      prompt2_2: .asciiz "? \n"
      feedback: .asciiz "Withdrawl successful."
      err1: .asciiz "Negative input for withdrawl is invalid.\n"
      err2_1: .asciiz "Account " 
      err2_2: .asciiz "not found."
      err3: .asciiz "Insufficient funds.\n"
      
      accountSelection: .space 4
      ammountSelection: .space 4
      errorCode: .space 4
   .text
   withdraw_start:
      printStr(prompt1) # prompt the user for an account and take input
      li $v0, 5
      syscall
      beq $v0, $zero, withdraw_end #exit if given zero
      sw $v0, accountSelection
      
      printStr(prompt2_1) #Prompt the user for an amount of money and store the input
      printInt($v0, 0)
      printStr(prompt2_2)
      
      li $v0, 6 #Note this is a double value
      syscall
      blt $v0, $zero, err1_
      
      #attemptToWithdraw(%userNumber,accountSelection,ammountSelection,errorCode)#Will need to work with the file
      lw $t0, errorCode #Check for error reports
      beq $t0, 1, err2_
      beq $t0, 2, err3_
      j success_
      err1_:
         printStr(err1)
         j withdraw_start
      err2_:
         printStr(err2_1)
         lw $t0, accountSelection
         printInt($t0, 0)
         printStr(err2_2)
         j withdraw_start
      err3_:
         printStr(err3)
         j withdraw_start
      success_:
         printStr(feedback)
   withdraw_end:
.end_macro

