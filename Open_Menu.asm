#CS 2640.02 
#Group 4: Kayshawn W., Jacob L., Jahnvi L., Samuel O.
#12/07/25

#Functions for the main menu of the application

.macro openMenu(%response)
   .data
   header: .asciiz "-------------------------Main Menu-------------------------\n"
   opening: .asciiz "Welcome to *Name Pending* banking app.\n"
   prompt: .asciiz "What would you like to do?\n"
   option1: .asciiz "1. Log in. \n"
   option2: .asciiz "2. Sign up. \n"
   option3: .asciiz "3. Exit the application. \n"
   inputErr: .asciiz "Invalid input. Please try again.\n"
   .text
   menu: #Provide the menu to the user
   printStr(header)
   printStr(opening)
   printStr(prompt)
   printStr(option1)
   printStr(option2)
   printStr(option3)
   recieve: #Take their response
   li $v0, 5
   syscall
   
   errorCheck: #Ensure valid input
   ble $v0, 0, error
   bge $v0, 4, error
   j exit #If input is valid continue to exit
   error:
   printStr(inputErr)
   j menu
   exit: #If input was valid store it in response and exit
   sb $v0, %response
.end_macro

signUpMenuLoop:
.macro signUpMenu
   .data
   userNamePrompt: .asciiz "Please enter a desired username: \n"
   username: .space 26
   passwordPrompt: .asciiz "Please enter a desired password: \n"
   password: .space 26
   firstNamePrompt: .asciiz "Please enter your first name: \n"
   firstName: .space 51
   lastNamePrompt: .asciiz "Please enter your last name: \n"
   lastName: .space 51

   .text 
   #Ask the user for each piece of information, then store it in the appropriate space
   printStr(userNamePrompt)
   readStr(username, 26)
   printStr(passwordPrompt)
   readStr(password, 26)
   printStr(firstNamePrompt)
   readStr(firstName, 51)
   printStr(lastNamePrompt)
   readStr(lastName, 51)
   
   #Testing address placement
   #printStr(username)
   #printStr(password)
   #printStr(firstName)
   #printStr(lastName)

   #Check Username Availability
   openFile(0)
   readFile(buffer, 50000, $s1)

   .data
   ampersand:  .byte 38
   newline: .byte 10
   duplicateUsername: .asciiz "\nThis username is already in use. Please select an alternative option."

   .text
   la $t0, buffer
   lb $t1, ($t0)
   la $t2, ampersand
   lb $t3, ($t2)
   la $t8, newline
   lb $t5, ($t8)
   li $t9, 0		#ampersand counter


   findAmpersand:
   bge $t0, $s1, generateUserNumber
   lb $t1, ($t0)
   lb $t3, ($t2) 
   beq $t1, $t3, foundAmpersand     
   addi $t0, $t0, 1  
   j findAmpersand
   
   foundAmpersand:
   addi $t9, $t9, 1
   
   skipLines:
   li $t3, 0 	#newline counter
   addi $t0, $t0, 1
   
   skipLinesLoop:
   lb $t4, ($t0)
   lb $t5, ($t8)
   beq $t4, $t5, foundNewline  
   addi $t0, $t0, 1
   j skipLinesLoop
   
   foundNewline:
   addi $t3, $t3, 1
   addi $t0, $t0, 1
   
   #Check if 4 lines have been skipped
   beq $t3, 4, usernameLine
   
   j skipLines
   
   usernameLine:
   beq $t0, $t8, compareUsername
   addi $t0, $t0, 1
   
   j usernameLine
   
   compareUsername:
   la $t6, username

   lb $t7, ($t6)
   lb $t8, ($t0)
   
   #Check for end of input username end
   beq $t7, 0, usernameEnd
   beq $t7, $t9, usernameEnd
   bne $t7, $t8, nextAmpersand
   
   addi $t6, $t6, 1
   addi $t0, $t0, 1   
   j compareUsername
   
   usernameEnd:
   #Check for file username end
   beq $t8, $t9, duplicateUsernameFound  
   j nextAmpersand
   
   duplicateUsernameFound:
   printStr(duplicateUsername)
   j signUpMenuLoop
   
   nextAmpersand: 
   lb $t7, ($t0)
   beq $t7, 0, generateUserNumber
   lb $t8, ampersand
   bne $t7, $t8, gotonextAmpersand
   
   
   addi $t0, $t0, 1
   lb $t7, ($t0)
   beq $t7, $t8, findAmpersand
   
   gotonextAmpersand:
   addi $t0, $t0, 1      
   j nextAmpersand
   
   closeFile
   
      generateUserNumber:
      .data
      userNumberValue:	.word 1
      
      .text
      lw $t5, userNumberValue
      add $t5, $t5, $t9
      sw $t5, userNumberValue
      
      # Generate account number (keep user number separate)
      move $t6, $t5
      addi $t6, $t6, 1000 
      sw $t6, accountNumberValue
        
      #Append user data to User_Data.txt
      appendSignUpData:
      .data
      ampersandLabel:	.asciiz "\n&&"
      userNumberLabel: .asciiz "\nUser No. "
      firstNameLabel: .asciiz "\nFirst Name: "
      lastNameLabel: .asciiz "\nLast Name: "
      usernameLabel: .asciiz "\nUsername: "
      passwordLabel: .asciiz "\nPassword: "
      
      carrotLabel:	.asciiz "\n^^"
      accountNumberLabel:	.asciiz "\nAccount No. "
      balanceLabel:	.asciiz "\nBalance: "
      frozenLabel:	.asciiz "\nAccount Frozen: "
      frozenN:	.asciiz "\nN"
      frozenY:	.asciiz "\nY"
      accessLabel:	.asciiz "\nAccess: "
      accountNumberValue:	.word 1
      balanceValue:	.word 0
      intBuffer:	.space 6
      
      .text
      #convert to String
      openFile(9)
      
      writeStringToFile(ampersandLabel)
      
      writeStringToFile(userNumberLabel)
      writeIntToFile(userNumberValue, intBuffer)

      writeStringToFile(firstNameLabel)
      writeStringToFile(firstName)
      
      writeStringToFile(lastNameLabel)
      writeStringToFile(lastName)
      
      writeStringToFile(usernameLabel)
      writeStringToFile(username)
            
      writeStringToFile(passwordLabel)
      writeStringToFile(password)
      
      writeStringToFile(carrotLabel)
      
      writeStringToFile(accountNumberLabel)
      writeIntToFile(accountNumberValue, intBuffer)
      
      writeStringToFile(balanceLabel)
      writeIntToFile(balanceValue, intBuffer)
      
      writeStringToFile(frozenLabel)
      writeStringToFile(frozenN)
      
      writeStringToFile(accessLabel)
      writeIntToFile(userNumberValue, intBuffer)
      
      closeFile	
.end_macro

.macro loginMenu(%user_number) #memory address for a user to login. Zero if failed or invalid.
   .data
   userPrompt: .asciiz "Please enter your username: "
   username: .space 26
   passPrompt: .asciiz "Please enter your password: "
   password: .space 26
   
   .text
   #Get the user's username and password
   printStr(userPrompt)
   readStr(username, 26)
   printStr(passPrompt)
   readStr(password, 26)
   
.end_macro


