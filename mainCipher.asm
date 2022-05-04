#CS-2640 FINAL
#Program that can encrypt and decrypt messages using the well known Caesasr Cipher

#Program routine: 1)Prompt user to input a message. 
# 2) Ask the user if they want to encrypt or decrypt the message.
# 3)After printing the result, ask the user if they would like to encrypt/decrypt another message

.data
userInput: .space 256
greetMsg: .asciiz "Please enter the message you would like to encrypt/decrypt: "
cipherPrompt: .asciiz "Would you like to (1: Encrypt) or (2: Decrypt)"
resMsg: .asciiz "Result: "
contMsg: .asciiz "Press '1' to continue or '0' to exit."
iterator: .word 0

.text
la $a0, greetMsg #Prints out the greeting message that prompts the user for input
li $v0, 4
syscall

la $v0, 8
la $a0, userInput #Load 256 bytes of space for the userInput
la $a1, 254 #Read from the first 254 bytes of the string inputted by user
syscall

la $a0, userInput #Stores userInput address into a0
jal getLengthCheck

lw $t6, iterator #Loads the iterator variable into t6

move $t2, $t0	#Move the encrypted value to t2
la $t0, userInput	#Loads the address of userInput into t0
li $v0, 4	#Print a string
sb $t2, ($t0)	#Stores the encrypted value into userInput space
la $a0, userInput #Loads the userInput address into a0
syscall

getLengthCheck:
li $v0, -2
getLength:
lb $t0, ($a0)
addi $a0, $a0, 1
addi $v0, $v0, 1
bne $t0, $zero, getLength
jr $ra

encrypt: 
lb $v0, ($t3) #loads the userInput address into a v0
move $t0, $v0 #t0 now holds value inputted by the user
addi $t0, $t0, 3 #increment the ascii value by 3
addi $a2, $a2, 1
j getLength

decrypt:
subi $t0, $t0, 3

exitLoop:
jr $ra

exit:
li $v0, 10
syscall

