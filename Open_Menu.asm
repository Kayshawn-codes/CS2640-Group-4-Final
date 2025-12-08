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
   bge $v0, 5, error
   j exit #If input is valid continue to exit
   error:
   printStr(inputErr)
   j menu
   exit: #If input was valid store it in response and exit
   sb $v0, %response
.end_macro


.macro signUpMenu
   .data
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
   menuPrompt:
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
   openFile(0, fileDescriptor)
   readFile(buffer, 50000, $s1, fileDescriptor)

   .data
   ampersand:  .byte 38
   newline: .byte 10
   duplicateUsername: .asciiz "\nThis username is already in use. Please select an alternative option."

   .text
   #Initialize file parsing variables
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
   
   #Skip 4 lines to reach username line
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
   
   #Navigate to start of username in file
   usernameLine:
   beq $t0, $t8, compareUsername
   addi $t0, $t0, 1
   
   j usernameLine
   
   #Compare input username with file username character by character
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
   j menuPrompt
   
   #Navigate to next user section in file
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
   
   closeFile(fileDescriptor)
   
   #Generate unique user and account numbers
   generateUserNumber:
      .data
      userNumberValue:	.word 1
      
      .text
      lw $t5, userNumberValue
      add $t5, $t5, $t9                   # Add existing user count
      sw $t5, userNumberValue             # Store new user number
      
      # Generate account number (keep user number separate)
      move $t6, $t5
      addi $t6, $t6, 1000
      sw $t6, accountNumberValue
        
   #Write complete user profile to file
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
      openFile(9, fileDescriptor)   # Open file for append
      
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
		# File path
		filename: .asciiz "C:/Users/jacob/OneDrive/Desktop/2640 Stuff/2640 Final Project/Actual Final Project/CS2640-Group-4-Final/User_Data.txt"
		buffer: .space 10000
		newLineTest: .asciiz "\nNew line test!!!"
	.text
	

	# Read the file
	li $v0, 13
	la $a0, filename
	li $a1, 0
	li $a2, 0
	syscall
	
	# Saving the file descriptor
	move $s0, $v0

readline:
	# read one line 
	li $v0, 14
	move $a0, $s0
	la $a1, buffer
	li $a2, 150
	syscall
		
	move $t0, $v0
	
	
	# Close file at this point if there is nothing to print
	beq $t0, $zero, closeFile

	printStr(newLineTest)	
	# null-terminating the buffer
	la $t1, buffer
	add $t1, $t1, $t0
	sb $zero, 0($t1)
	
	
	# Print the given line
	printStr(buffer)
	
	j readline
	

	# we're given the line
	# then go from the ampersands, find FirstName
	# compare username to the given username
	# same with password,compare it to given password
	# if not in first number of ampersands, move to next one
	#  can't i just look for phrase first name?
	

closeFile:
	li $v0, 16
	move $a0, $s0
	syscall


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


