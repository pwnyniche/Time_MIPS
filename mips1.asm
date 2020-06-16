.data
	#time
	converted: .space 20
	# day
	daysOfWeek: .word t2, t3, t4, t5, t6, t7, cn
	mon: .asciiz " Mon"
	tue: .asciiz " Tue"
	wed: .asciiz " Wed"
	thu: .asciiz " Thu"
	fri: .asciiz " Fri"
	sat: .asciiz " Sat"
	sun: .asciiz " Sun"

	# month
	jan: .asciiz "January"
	feb: .asciiz "February"
	mar: .asciiz "March"
	apr: .asciiz "April"
	may: .asciiz "May"
	jun: .asciiz "June"
	jul: .asciiz "July"
	aug: .asciiz "August"
	sep: .asciiz "September"
	oct: .asciiz "October"
	nov: .asciiz "November"
	dec: .asciiz "December"
	songay: .word 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

	# jump table
	month_name: .word m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12
	menu_list: .word choose1, choose2, choose3, choose4, choose5, choose6, choose7
	#input
	inp_day: .asciiz "\nNhap ngay DAY:"
	inp_month: .asciiz "\nNhap thang MONTH:"
	inp_year: .asciiz "\nNhap nam YEAR:"
	inp_error: .asciiz "Ngay khong hop le\n"
	time1: .space 30
	time2: .space 30
	strlen: .space 30
	#menu
	plz_choose: .asciiz "\n----------Ban hay chon 1 trong cac thao tac duoi day----------\n"
	opt1: .asciiz "1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n"
	opt2: .asciiz "2. Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n"
	opt2a: .asciiz "\tA. MM/DD/YYYY\n"
	opt2b: .asciiz "\tB. Month DD, YYYY\n"
	opt2c: .asciiz "\tC. DD Month, YYYY\n"
	opt3: .asciiz "3. Cho biet ngay vua nhap la ngay thu may trong tuan:\n"
	opt4: .asciiz "4. Kiem tra nam trong chuoi TIME co phai la nam nhuan khong\n"
	opt5: .asciiz "5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2\n"
	opt6: .asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi time\n"
	opt7: .asciiz "Kiem tra bo du lieu dau vao khi nhap, neu du lieu khong hop le thi yeu cau nguoi dung nhap lai.\n"
	ask_again: .asciiz "Ban muon tiep tuc (1) hay thoat (0) ? "
	#convert
	choose_abc: .asciiz "Vui long chon A,B,C: "
	not_abc: .asciiz "Khong phai A,B,C\n"
	
.text
	.globl main
#Ham main
main:
	main_loop:
	la $a0,time1
	jal menu
	
	la $a0,ask_again	# again or exit ?
	or $v0,$0,4		#syscall print string
	syscall			
	
	or $v0,$0,5		#syscall read int
	syscall
	beq $v0,$0, main_exit
	j main_loop
main_exit:
	or $v0,$0,10		#syscall exit
	syscall

#Ham input
#a0:
#v0: a0
input:
	
input_loop:
	
input_exit:
	

#Ham menu
# a0: TIME
menu:
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $t0,4($sp)
	jal input
	
	sw $v0,8($sp)		#luu TIME
	addi $v0, $0, 4		#syscall print string
	la $a0, plz_choose
	syscall
	la $a0, opt1
	syscall
	la $a0, opt2
	syscall
	la $a0, opt2a
	syscall
	la $a0, opt2b
	syscall
	la $a0, opt2c
	syscall
	la $a0, opt3
	syscall
	la $a0, opt4
	syscall
	la $a0, opt5
	syscall
	la $a0, opt6
	syscall
	la $a0, opt7
	syscall
	addi $v0,$0,5		#syscall read int
	syscall
	addi $v0,$v0,-1		# i starts with 0
	sll $v0,$v0,2		
	la $s0,menu_list	#dia chi cua menu_list
	addi $s0,$s0,$v0	#menu_list[i]
	jr $s0
	
choose1:
	lw $a0,8($sp)		# load TIME tu stack
	or $v0,$0,4		#syscall print string
	syscall
	j menu_exit
choose2:
	lw $a0,choose_abc	#Chon a,b,c
	or $v0,$0,4		#print string
	syscall
	
	or $v0,$0,12		#syscall read char
	syscall
	or $a1,$0,$v0		# type A/B/C
	lw $a0,8($sp)		#load TIME tu stack
	jal convert		
	or $a0,$v0,$0
	or $v0,$0,4		#print string
	syscall
	j menu_exit
choose3:
	
	j menu_exit
choose4:
	
	j menu_exit
choose5:
	
	j menu_exit
choose6:
	
	j menu_exit
choose7:
	
	j menu_exit
menu_exit:
	lw $ra,0($sp)
	lw $t0,4($sp)
	lw $v0,8($sp)
	addi $sp,$sp,12
	jr $ra

#Ham kiem tra
#a0 TIME
#v0 1:True 0:false
check_valid


# a0:day, a1:month, a2:year, a3:TIME
# v0: chuoi TIME
Date:
	addi $t0,$0,10
	div $a0, $t0
	mfhi $t1		#day/10
	mflo $t2		#day%10
	addi $t1,$t1,48		
	addi $t2,$t2,48
	sb $t1,0($a3)		#TIME[0]
	sb $t2,1($a3)		#TIME[1]
	addi $t4,$0,47		#char '/'
	sb $t4,2($a3)		#TIME[2]
	
	addi $t0,$0,10
	div $a1, $t0
	mfhi $t1		#month/10
	mflo $t2		#month%10
	addi $t1,$t1,48		
	addi $t2,$t2,48
	sb $t1,3($a3)		#TIME[3]
	sb $t2,4($a3)		#TIME[4]
	addi $t4,$0,47		#char '/'
	sb $t4,5($a3)		#TIME[5]
	
	addi $t0,$0,1000
	div $a2, $t0
	mfhi $t1		#year/1000
	mflo $t2		#year%1000
	addi $t1,$t1,48	
	sb $t1,6($a3)		#TIME[6]
	
	addi $t0,$0,100
	div $t2, $t0
	mfhi $t3		#t2/100
	mflo $t4		#t2%100
	addi $t1,$t1,48	
	sb $t1,7($a3)		#TIME[7]
	
	addi $t0,$0,10
	div $t4, $t0
	mfhi $t1		#t4/10
	mflo $t2		#t4%10
	addi $t1,$t1,48		
	addi $t2,$t2,48
	sb $t1,8($a3)		#TIME[8]
	sb $t2,9($a3)		#TIME[9]
	sb $0, 10($a3)		# '\0'
	addi $v0,$0,$a3
	jr $ra
#Ham Convert
# a0:TIME a1:type
# v0: chuoi sau khi chuyen dinh dang
Convert:
	addi $sp,$sp,-16
	sw $ra,0($sp)
	sw $t0,4($sp)
	
	addi $t0,$0,65		#'A'
	beq $t0,$a1,Convert_A	
	addi $t0,$t0,1		#'B'
	beq $t0,$a1,Convert_B	
	addi $t0,$t0,1		#'C'
	beq $t0,$a1,Convert_C
	la $a0,not_abc
	##addi $v0, $0, 4		#??
	#syscall			#??
	j Convert_exit
Convert_A:
	lb $t0,0($a0)		#TIME[0]
	lb $t1,1($a0)		#TIME[1]
	lb $t3,3($a0)		#TIME[3]
	lb $t4,4($a0)		#TIME[4]
	sb $t3,0($a0)		#swap DD and MM
	sb $t4,1($a0)
	sb $t0,3($a0)
	sb $t1,4($a0)
	j Convert_exit
Convert_B:
	sw $a0,8($sp)
	sw $t1,12($sp)
	jal month_string	#truyen vao TIME -> duoc chuoi thang ("March")
	add $a0,$0,$v0
	jal length		#lay do dai chuoi thang 
	add $t0,$0,$v0		#luu vao t0
	add $a1,$0,$a0
	la $a0,converted
	jal strcpy		#copy chuoi thang vao converted
	add $a0,$v0,$0		#truyen lai vao a0
	add $a0,$a0,$t0		#truyen dia chi cuoi chuoi thang vao a0
	
	addi $t1,$0,32		# ki tu khoang trang  ' '
	sb $t1,0($a0)		#them ki tu ' ' vao
	
	lw $s0,8($sp)		#Gan lai TIME vao s0
	lb $t1,0($s0)		#So dau tien trong DD
	sb $t1,1($a0)		#Gan vao
	lb $t1,1($s0)		#So thu 2 trong DD
	sb $t1,2($a0)		#Gan vao
	
	addi $t1,$0,44		#Ki tu ','
	sb $t1,3($a0)
	addi $t1,$0,32		#Ki tu ' '
	sb $t1,4($a0)
	
	addi $a0,$a0,5		#dia chi dau tien sau 'DD, '
	addi $a1,$s0,6		#dia chi ki tu dau trong YYYY
	jal strcpy
	
	addi $a0,$a0,-5		# chuyen dia chi len lai 5 
	sub $a0,$a0,$t0		# chuyen dia chi len t0=do dai chuoi thang
	lw $t1,12($sp)
	j Convert_exit
Convert_C:
	la $s0,$a0		#Luu dia chi TIME vao $s0
	sw $a0,8($sp)		# luu TIME vao stack
	la $a0,converted	# luu dia chi converted vao $a0
	lb $t1,0($s0)		#So dau tien trong DD
	sb $t1,0($a0)		#Gan vao
	lb $t1,1($s0)		#So thu 2 trong DD
	sb $t1,1($a0)		#Gan vao
	addi $t1,$0,32		# ki tu khoang trang  ' '
	sb $t1,2($a0)		#them ki tu ' ' vao
	sw $a0,12($sp)		# luu 'DD ' vao stack
	
	lw $a0,8($sp)		#Gan lai TIME vao a0
	jal month_string	#truyen vao TIME -> duoc chuoi thang ("March")
	add $a0,$0,$v0		#chuoi thang
	jal length		#lay do dai chuoi thang 
	add $t0,$0,$v0		#luu vao t0
	
	add $a1,$0,$a0		#chuoi thang
	lw $a0,12($sp)		# lay 'DD ' ra
	la $a0,3($a0)		#dua ve vi tri sau 'DD '
	jal strcpy		#copy chuoi thang vao sau 'DD '
	la $a0,-3($v0)		# dua lai vi tri dau tien trong 'DD '
	addi $a0,$a0,3		#truyen dia chi sau 'DD ' vao a0
	add $a0,$a0,$t0		#truyen dia chi cuoi chuoi thang vao a0
	
	addi $t1,$0,44		#Ki tu ','
	sb $t1,0($a0)		#Duoc 'DD Month,'
	addi $t1,$0,32		#Ki tu ' '
	sb $t1,1($a0)		#Duoc 'DD Month, '
	
	lw $a1,8($sp)		#Gan lai TIME vao a1
	addi $a0,$a0,2		#dia chi dau tien sau 'DD Month, '
	addi $a1,$a1,6		#dia chi ki tu dau trong YYYY
	jal strcpy		#duoc 'DD Month, YYYY'
	add $a0,$0,$v0		#luu ket qua vao a0
	
	addi $a0,$a0,-5		# chuyen dia chi len lai 5 
	sub $a0,$a0,$t0		# chuyen dia chi len t0=do dai chuoi thang
	j Convert_exit
Convert_exit:
	add $v0,$0,$a0
	lw $t0,4($sp)
	lw $ra,0($sp)
	addi $sp,$sp,16
	jr $ra
	
#Ham Day
# a0: chuoi TIME
# v0: day (1-31)
Day:
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	
	lb $t0,0($a0)		#TIME[0]
	addi $t0,$t0,-48	#TIME[0]-'0'
	addi $t1,$0,10
	mult $t0,$t1
	mflo $t1
	
	lb $t0,1($a0)		#TIME[1]
	addi $t0,$t0,-48	#TIME[1]-'0'
	add $v0,$t0,$t1
	
	lw $ra,0($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	addi $sp,$sp,12
	jr $ra
	
#Ham Month
# a0: chuoi TIME
# v0: month (1-12)
Month:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	la $a0,3($a0)		#dia chi TIME[3] gan vao $a0
	jal Day			#v0 cua Day cung la v0 cua Month ??
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

#Ham Year
# a0: chuoi TIME
# v0: year (>=1900)
Year:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $t0,4($sp)
	
	la $a0,6($a0)		#dia chi TIME[6] gan vao $a0
	jal Day			#lay ra 2 so dau trong YYYY
	addi $t0,0,100
	mult $v0,$t0
	mflo $t0
	la $a0,2($a0)		#dia chi (a0+2) TIME[8] gan vao $a0
	jal Day			#lay ra 2 so sau trong YYYY
	add $v0,$v0,$t0
	
	lw $ra,0($sp)
	lw $t0,4($sp)
	addi $sp,$sp,4
	jr $ra

#Ham tra ve chuoi thang tu TIME
# a0: TIME
# v0: chuoi thang ("January" ..)
month_string:
	addi $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	sw $s0,0($sp)
	
	jal month		#lay TIME truyen vao
	addi $a0,$v0,-1		#duoc thang (int), -1 de truyen vao mang
	la $s0 month_string	#lay dia chi month_string
	sll $a0,$a0,2		#i*4
	addi $a0,$a0,$s0	#month_string[i]
	#lw $a0,$a0	??????????????????????????
	jr $a0
m1:
	la $v0 jan
	j month_string_exit
m2:
	la $v0 feb
	j month_string_exit
m3:
	la $v0 mar
	j month_string_exit
m4:
	la $v0 apr
	j month_string_exit
m5:
	la $v0 may
	j month_string_exit
m6:
	la $v0 jun
	j month_string_exit
m7:
	la $v0 jul
	j month_string_exit
m8:
	la $v0 aug
	j month_string_exit
m9:
	la $v0 sep
	j month_string_exit
m10:
	la $v0 oct
	j month_string_exit
m11:
	la $v0 nov
	j month_string_exit
m12:
	la $v0 dec
	j month_string_exit
month_string_exit:
	lw $ra,8($sp)
	lw $a0,4($sp)
	lw $s0,0($sp)
	addi $sp,$sp,12
	jr $ra

#Ham copy chuoi
# a0:destination ,a1:source
# v0: a0
strcpy:
	addi $sp,$sp,-16
	sw $ra,0($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	
	or $t0,$a0,$0		# t0=a0
	or $t1,$a1,$0		# t1=a1
strcpy_loop:
	lb $t2,0($t1)
	beq $t2,$0,strcpy_exit
	addi $t1,$t1,1
	sb $t2,0($t0)
	addi $t0,$t0,1
	j strcpy_loop
strcpy_exit:
	or $v0,$t0,$0
	lw $ra,0($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	addi $sp,$sp,8
	jr $ra

#Ham do dai chuoi
# a0: chuoi
# v0: int
length:
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $t0,4($sp)
	sw $t1,8($sp)
	or $t1,$0,$0		#count=0
length_loop:
	lb $t0,($a0)		#load byte into t0	
	beq $t0,$0,length_exit	#t0=null thi exit
	addi $t1,$t1,1		#count++
	addi $a0,$a0,1		#go to next byte
	j length_loop
length_exit:
	or $v0,$t1,$0
	lw $ra,0($sp)
	lw $t0,4($sp)
	lw $t1,8($sp)
	addi $sp,$sp,12
	jr $ra



