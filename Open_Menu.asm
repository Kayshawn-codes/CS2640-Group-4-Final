#CS 2640.02 
#Group 4: Kayshawn W., Jacob L., Jahnvi L., Samuel O.
#12/07/25

#Functions for the main menu of the application

.macro openMenu(%response)
   .data   
   header: .asciiz "-------------------------Main Menu-------------------------\n"
   opening: .asciiz "Welcome to the Cornerstone Financial banking app.\n"
   prompt: .asciiz "What would you like to do?\n"
   option1: .asciiz "1. Log in. \n"
   option2: .asciiz "2. Sign up. \n"
   option3: .asciiz "3. Exit the application. \n"
   inputErr: .asciiz "Invalid input. Please try again.\n"
   .text
   openMenu_menu: #Provide the menu to the user
   printStr(header)
   printStr(opening)
   printStr(prompt)
   printStr(option1)
   printStr(option2)
   printStr(option3)
   openMenu_recieve: #Take their response
   li $v0, 5
   syscall
   
   openMenu_errorCheck: #Ensure valid input
   ble $v0, 0, openMenu_error
   bge $v0, 5, openMenu_error
   j openMenu_exit #If input is valid continue to exit
   openMenu_error:
   printStr(inputErr)
   j openMenu_menu
   openMenu_exit: #If input was valid store it in response and exit
   sb $v0, %response
.end_macro


.macro signUpMenu
   .data
   debug: .asciiz "File descriptor: "
   debug2: .asciiz "\n"
   
   
   .align 2
   fileDescriptor: .word 
   userNamePrompt: .asciiz "Please enter a desired username: \n"
   username: .space 26
   passwordPrompt: .asciiz "Please enter a desired password: \n"
   password: .space 26
   firstNamePrompt: .asciiz "Please enter your first name: \n"
   firstName: .space 51
   lastNamePrompt: .asciiz "Please enter your last name: \n"
   lastName: .space 51

   .text 
   signUp_menuPrompt:
   #Ask the user for each piece of information, then store it in the appropriate space
   printStr(userNamePrompt)
   readStr(username, 26)
   printStr(passwordPrompt)
   readStr(password, 26)
   printStr(firstNamePrompt)
   readStr(firstName, 51)
   printStr(lastNamePrompt)
   readStr(lastName, 51)
   
   #Check Username Availability
   openFile(0, fileDescriptor)
   readFile(buffer2, 50000, $s1, fileDescriptor)
   
   #Calculate end of valid data in buffer
   la $s5, buffer2
   add $s1, $s5, $s1  # $s1 = buffer start + bytes read
   
   #If no data was read, set end to buffer start
   beq $s1, $s5, generateUserNumber 

   #Debug code to check if file descriptor makes sense
   printStr(debug)
   lw $t0, fileDescriptor
   printInt($t0, 0)
   printStr(debug2)
   
   .data
   ampersand:  .byte 38
   newline: .byte 10
   duplicateUsername: .asciiz "\nThis username is already in use. Please select an alternative option."

   .text
   #Initialize file parsing variables
   la $t0, buffer2
   lb $t1, ($t0)
   la $t2, ampersand
   lb $t3, ($t2)
   la $s2, newline
   lb $s3, ($s2)
   li $t9, 0		#ampersand counter

   #Find greatest existing user number for proper incrementing
   jal findGreatestUserNumber

   findAmpersand:
   bge $t0, $s1, generateUserNumber
   
   # Check bounds before accessing memory
   la $s6, buffer2
   addi $s6, $s6, 50000  # Calculate buffer end
   bge $t0, $s6, generateUserNumber
   
   lb $t1, ($t0)
   beq $t1, 0, generateUserNumber   #Check for null terminator
   lb $t3, ($t2) 
   beq $t1, $t3, foundAmpersand     
   addi $t0, $t0, 1  
   j findAmpersand
   
   foundAmpersand:
   addi $t9, $t9, 1
   
   #Skip 4 lines to reach username line
   skipLines:
   li $t3, 0 	#newline counter
   addi $t0, $t0, 1
   
   skipLinesLoop:
   # Check bounds before accessing memory
   bge $t0, $s1, generateUserNumber
   
   lb $t4, ($t0)
   lb $t5, ($s2)
   beq $t4, $t5, foundNewline  
   addi $t0, $t0, 1
   j skipLinesLoop
   
   foundNewline:
   addi $t3, $t3, 1
   addi $t0, $t0, 1
   
   #Check if 4 lines have been skipped
   beq $t3, 4, compareUsername
   
   j skipLines
   
   #Compare input username with file username character by character
   compareUsername:
   # Check bounds before accessing buffer memory
   bge $t0, $s1, nextAmpersand
   
   la $t6, username
   lb $t7, ($t6)
   lb $t8, ($t0)
   
   #Check for end of input username (null terminator or newline)
   beq $t7, 0, usernameEnd
   beq $t7, 10, usernameEnd #Check for newline char
   bne $t7, $t8, nextAmpersand
   
   addi $t6, $t6, 1
   addi $t0, $t0, 1   
   j compareUsername
   
   usernameEnd:
   #Check for file username end(should be newline char)
   lb $s4, ($s2)
   beq $t8, $s4, duplicateUsernameFound  
   j nextAmpersand
   
   duplicateUsernameFound:
   printStr(duplicateUsername)
    j signUp_menuPrompt
   
   #Navigate to next user section in file
   nextAmpersand: 
   # Check bounds before accessing memory
   bge $t0, $s1, generateUserNumber
   
   lb $t7, ($t0)
   beq $t7, 0, generateUserNumber
   lb $t8, ($t2)  # Load ampersand value from correct address
   bne $t7, $t8, gotonextAmpersand
   
   addi $t0, $t0, 1
   bge $t0, $s1, generateUserNumber  # Check bounds after increment
   lb $t7, ($t0)
   beq $t7, $t8, findAmpersand
   
   gotonextAmpersand:
   addi $t0, $t0, 1      
   j nextAmpersand

   findGreatestUserNumber:
   li $t7, 0
   la $t0, buffer2

   searchForUserNumber:
   bge $t0, $s1, endSearch

   #String search: "User No. "
   la $t1, userNumberLabel
   move $t2, $t0
   li $t3, 0

   findMatchLoop:
   lb $t4, ($t1)
   beq $t4, $zero, foundUserNumber
   lb $t5, ($t2)
   bne $t4, $t5, noMatch
   addi $t1, $t1, 1
   addi $t2, $t2, 1
   j findMatchLoop

   noMatch:
   addi $t0, $t0, 1
   j searchForUserNumber

   foundUserNumber:
   move $t0, $t2
   li $t7, 0

   parseNumber:
   lb $t8, ($t0)
   blt $t8, 48, numberEnd
   bgt $t8, 57, numberEnd
   subi $t8, $t8, 48
   mul $t7, $t7, 10
   add $t7, $t7, $t8
   addi $t0, $t0, 1

   numberEnd:
   #Update highest value if current is greater
   ble $t7, $s7, continueSearch
   move $s7, $t7

   continueSearch:
   j searchForUserNumber

   endSearch:
   jr $ra

   #Generate unique user and account numbers
   generateUserNumber:
   closeFile(fileDescriptor)
      .data
      userNumberValue:	.word 1
      baseAccountNumber: .word 1000
      
      .text
      # Calculate next user number: highest found + 1
      addi $t5, $s7, 1                    # $s7 contains highest user number found
      sw $t5, userNumberValue             # Store new user number

      # Generate account number: base + user number
      lw $t6, baseAccountNumber
      add $t6, $t6, $t5                   # Account = 1000 + user number
      sw $t6, accountNumberValue
        
   #Write complete user profile to file
   appendSignUpData:
      .data
      ampersandLabel:	.asciiz "\n&&"
      userNumberLabel: .asciiz "\nUser No. "
      firstNameLabel: .asciiz "\nFirst Name: "
      lastNameLabel: .asciiz "Last Name: "
      usernameLabel: .asciiz "Username: "
      passwordLabel: .asciiz "Password: "
      
      carrotLabel:	.asciiz "^^"
      accountNumberLabel:	.asciiz "\nAccount No. "
      balanceLabel:	.asciiz "\nBalance: "
      frozenLabel:	.asciiz "\nAccount Frozen: "
      frozenN:	.asciiz "N (Y or N)"
      frozenY:	.asciiz "Y (Y or N)"
      accessLabel:	.asciiz "\nAccess: "
      accountNumberValue:	.word 1
      balanceValue:	.word 0
      intBuffer:	.space 6
      
      .text
      
      #convert to String
      openFile(9, fileDescriptor)   # Open file for append
      
      #Debug code to check if file descriptor makes sense
      printStr(debug)
      lw $t0, fileDescriptor
      printInt($t0, 0)
      printStr(debug2)
      
      
      writeStringToFile(ampersandLabel, fileDescriptor)  # Write user section marker
      
      writeStringToFile(userNumberLabel, fileDescriptor)
      writeIntToFile(userNumberValue, intBuffer, fileDescriptor)

      writeStringToFile(firstNameLabel, fileDescriptor)
      writeStringToFile(firstName, fileDescriptor)
      
      writeStringToFile(lastNameLabel, fileDescriptor)
      writeStringToFile(lastName, fileDescriptor)
      
      writeStringToFile(usernameLabel, fileDescriptor)
      writeStringToFile(username, fileDescriptor)
            
      writeStringToFile(passwordLabel, fileDescriptor)
      writeStringToFile(password, fileDescriptor)
      
      writeStringToFile(carrotLabel, fileDescriptor) # Write account section marker

      writeStringToFile(accountNumberLabel, fileDescriptor)
      writeIntToFile(accountNumberValue, intBuffer, fileDescriptor)
      
      writeStringToFile(balanceLabel, fileDescriptor)
      writeIntToFile(balanceValue, intBuffer, fileDescriptor)
      
      writeStringToFile(frozenLabel, fileDescriptor)
      writeStringToFile(frozenN, fileDescriptor)
      
      writeStringToFile(accessLabel, fileDescriptor)
      writeIntToFile(userNumberValue, intBuffer, fileDescriptor)
      
      closeFile(fileDescriptor)
.end_macro

# Read user_data.txt 


.macro readUserData(%givenUsername, %givenPass)
	.data
	.asciiz "C:/Users/jacob/OneDrive/Desktop/2640 Stuff/2640 Final Project/Actual Final Project/CS2640-Group-4-Final/User_Data.txt" 
		buffer2: .space 50000 
		ampersand: .byte 38 # '&' 
		newline: .byte 10 # '\n' 
		loginSuccess: .asciiz "\nSuccesfully Logged in!\n" 
		loginFailure: .asciiz "\nInvalid Login! Please create an account. \n" 

	.text # pointers & constants 
	la $t0, buffer2 # $t0 = current scan pointer 
	la $t2, ampersand 
	lb $t2, 0($t2) # $t2 = '&' 
	la $t3, newline 
	lb $t3, 0($t3) # $t3 = '\n' 
	
	searchNextUser: # scan until we hit '&' or reach end of buffer 
	
	scanToAmp: 
	bge $t0, $s1, invalidLogin # out of data -> done 
	lb $t1, 0($t0) # t1 = *t0 
	beq $t1, $t2, atAmpersand # if '&' -> start of user section 
	addi $t0, $t0, 1 
	
	j scanToAmp 
	
	atAmpersand: # we are at first '&' of a block like "&&" 
	# move to end of this line, then skip 3 more lines to username line 
	# skip lines 
	skipLine0: 
	bge $t0, $s1, invalidLogin 
	lb $t1, 0($t0) 
	beq $t1, $t3, afterSkipLine0 # newline found 
	addi $t0, $t0, 1 
	j skipLine0 
	
	afterSkipLine0: 
	addi $t0, $t0, 1 # move past newline 
	li $t4, 3 # lines to skip 
	skipMoreLines: 
	beq $t4, $zero, atUsername # done skipping 
	bge $t0, $s1, invalidLogin 
	lb $t1, 0($t0) 
	beq $t1, $t3, decLineCount 
	
	# newline 
	addi $t0, $t0, 1 
	j skipMoreLines 
	
	decLineCount: 
	addi $t4, $t4, -1 
	addi $t0, $t0, 1 
	j skipMoreLines 
	
	atUsername: # $t0 now points at start of username in file 
	la $t6, %givenUsername # pointer to input username 
	
	compareUsername: 
	bge $t0, $s1, invalidLogin # safety: out of data 
	lb $t7, 0($t6) # ch from givenUsername 
	lb $t8, 0($t0) # ch from file username # end of given username? (null or newline) 
	
	beq $t7, $zero, usernameEnd 
	beq $t7, $t3, usernameEnd # mismatch -> not this user; go look for next block 
	
	bne $t7, $t8, searchNextUser # chars match → step both and keep going 
	
	addi $t6, $t6, 1 
	addi $t0, $t0, 1 
	j compareUsername 
	
	usernameEnd: # if file username also ends at newline -> exact match 
	beq $t8, $t3, usernameFound # otherwise this was only a prefix match; continue search 
	
	j searchNextUser 
	
	usernameFound: 
	j loginSuccessful
	
	invalidLogin: 
	j exit 
	
	loginSuccessful:
    	printStr(loginSuccess)
    	j    exit   # make sure you actually leave the program    
	
	exit:
.end_macro

.macro loginMenu(%user_number) #memory address for a user to login. Zero if failed or invalid.
   .data
   userPrompt: .asciiz "Please enter your username: "
   username: .space 26
   passPrompt: .asciiz "Please enter your password: "
   password: .space 26
   usernameTest: .asciiz "\nUsername Test: "
   
   .text
   #Get the user's username and password
   printStr(userPrompt)
   readStr(username, 26)
   printStr(passPrompt)
   readStr(password, 26)
   
   readUserData(username, password)  
.end_macro



