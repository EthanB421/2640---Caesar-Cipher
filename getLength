#Return the lenght of the inputted string from user

.data
userString: .space 256


.text
li $v0,8
la $a0, userString
li $a1, 254
syscall   #get string 1

la $a0, userString #Load address of space into a0
jal strLenCheck


move $a0, $v0
li $v0, 1
syscall
j exit

strLenCheck:
li $v0, -2
strLength: 
lb $t0, ($a0)
addi $a0, $a0, 1
addi $v0, $v0, 1
bne $t0, $zero, strLength
jr $ra


exit:
li $v0, 10
syscall