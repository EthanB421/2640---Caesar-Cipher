#Adds 3 to the ascii value of inutted user stirng

.data
msgKey: .asciiz "Please input your desired key length: "
msgString: .asciiz "Please input your plaintext: "
msgResult: .asciiz "The result is: "
userString: .space 256
resString: .space 256
key: .word 0

.text
la $a0, msgKey
li $v0, 4 #Prints the message to prompt the user for desired key length
syscall

li $v0, 5 #Read key length from the user
syscall

move $s1, $v0 #$s1, holds the key length

la $a0, msgString
li $v0, 4	#Prints the message to input plaintext
syscall

la $a3, resString
li $v0, 8
la $a0, userString
li $a1, 256
syscall   #get string 1

la $a0, userString #Load address of space into a0
jal strLength


j exit


strLength:
lb $t0, ($a0)
beq $t0, $zero, endStrLength
move $t1, $t0
add $t1, $t1, $s1 #Increments ascii
sb $t1, 0($a3)
addi $a3, $a3, 1
addi $a0, $a0, 1 #Increments position in the array
j strLength
endStrLength:
jr $ra

exit:
la $a0, msgResult
li $v0, 4 #Prits the result message
syscall

la $a0, resString
li $v0, 4                 # print_string
syscall

li $v0, 10
syscall
