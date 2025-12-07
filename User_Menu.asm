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
      menuOptions2:  .asciiz "1. Deposit\n2. Withdraw.\n3.Freeze and account.\n4.Change user access.\n5. Exit"
      errMsg:  .asciiz "Invalid input. Please try again"

   .text
   menu:
      greeting(firstName)
      printStr(accountsDisplay)
      showAccounts(%userNumber) #Will dynamically read file to determine the number of accounts
      printStr(menuOptions1)
      printStr(menuOptions2) #Prompt the user
      
      li $v0, 5
      syscall #Take the input and respond
      beq $v0, 1, deposit_
      beq $v0, 2, withdraw_
      beq $v0, 3, freeze_
      beq $v0, 4, changeAccess_
      beq $v0, 5, exit
      inputErr:
         printStr(errMsg)
         j main
      deposit_:
         deposit(%userNumber)
      withdraw_:
         withdraw(%userNumber)
      freeze_:
         freeze(%userNumber)
      changeAccess_:
         changeAccess(%userNumber)
      exit:
      
      
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
   main:
      
      li $t0, 1 #Loop counter, use to know which account you're searching for
      loop:
         printStr(display1)
         printInt($t0, 0)
         printStr(display2)
         printStr(linebreak)
         
         #findAccount(%userNumber, $t0, hasMore) #Should print out the account info and update hasMore
                                                #if there are no more accounts
         lw $t2, hasMore
         bne $t2, 0, loop 
.end_macro

.macro deposit(%userNumber)
.end_macro

.macro withdraw(%userNumber)
   .data
      prompt1: .asciiz "Withdraw from which account?(0 to exit)\n"
      prompt2.1: .asciiz "How much to withdraw from account " 
      prompt2.2: .asciiz "? \n"
      feedback: .asciiz "Withdrawl successful."
      err1: .asciiz "Negative input for withdrawl is invalid.\n"
      err2.1: .asciiz "Account " 
      err2.2: .asciiz "not found."
      err3: .asciiz "Insufficient funds.\n"
      
      accountSelection: .space 4
      ammountSelection: .space 4
      errorCode: .space 4
   .text
   main:
      printStr(prompt1) # prompt the user for an account and take input
      li $v0, 5
      syscall
      beq $v0, $zero, end #exit if given zero
      sw $v0, accountSelection
      
      printStr(prompt2.1) #Prompt the user for an amount of money and store the input
      printInt($v0, 0)
      printStr(prompt2.2)
      
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
         j main
      err2_:
         printStr(err2.1)
         lw $t0, accountSelection
         printInt($t0, 0)
         printStr(err2.2)
         j main
      err3_:
         printStr(err3)
         j main
      success_:
         printStr(feedback)
   end:
.end_macro

.macro freeze(%userNumber)
.end_macro

.macro changeAccess(%userNumber)
.end_macro

