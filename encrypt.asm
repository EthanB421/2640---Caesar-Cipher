#Adds 3 to the ascii value of inutted user stirng

.data
userString: .space 256
resString: .space 256


.text
la $a3, resString
li $v0, 8
la $a0, userString
li $a1, 256
syscall   #get string 1

la $a0, userString #Load address of space into a0
jal strLength

la $a0, resString
li $v0, 4                 # print_string
syscall
j exit


strLength:
lb $t0, ($a0)
beq $t0, $zero, endStrLength
move $t1, $t0
addi $t1, $t1, 3 #Increments ascii
sb $t1, 0($a3)
addi $a3, $a3, 1
addi $a0, $a0, 1 #Increments position in the array
j strLength
endStrLength:
jr $ra

exit:
li $v0, 10
syscall