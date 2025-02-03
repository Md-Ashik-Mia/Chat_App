INCLUDE "EMU8086.INC"           ; To use built-in function (PRINT, PRINTN)
; ORG 100h                      ; Set the starting address for the code, 100h = 256

.MODEL SMALL                    ; Memory model small, 64KB, max 128KB
.STACK 100H   
                  ; Reserve 256 bytes for stack (return address, variables, function calls)

.DATA
    input        DB 'Enter a digit: $'
    searchMsg    DB 'Enter digit to search:$'
    
    largestMsg   DB 'Largest value is: $'
    smallestMsg  DB 'Smallest value is: $'
    avgMsg       DB 'Average is: ',0 
    
    ; smallestMsg  DB 10, 13, 'Smallest value is: $'     ; To print newline before the string message
    newline      DB 0DH, 0AH, '$'
    
    array        DB 5 DUP(0)    ; Array to hold 5 digits
    searchValue  DB ?           ; Search number in the array
    
    avgerage     DB 0
    largeValue   DB 0
    smallValue   DB 0
    
    
.CODE
main PROC 
    MOV AX, @DATA               ; Initializing data segment by indicating the first memory address
    MOV DS, AX
    
    
    MOV CX, 5                   ; For loop condition
    MOV SI, 0                   ; For array indexing
    ; MOV SI, OFFSET array
    ; LEA SI, array
    
inputLevel:
    LEA DX, input
    MOV AH, 09H                 ; To print a string message
    INT 21H  
    
    MOV AH, 01H                 ; To take single digit input
    INT 21H                                                
    SUB AL, 30H                 ; Converting ACII to decimal/integer
    ; SUB AL, 48
    ; SUB AL, "0"
    
    MOV array[SI], AL           ; Storing input digit into array's first index
    ; MOV [SI], AL
    INC SI   
    
    LEA DX, newline 
    MOV AH, 09H
    INT 21H
    
    LOOP inputLevel 
    
    
    
    CALL smallest
    
;Displaying the smallest value in the array

    ; For newline
    MOV AH, 02H
    MOV DL, 10                  ; ASCII value for newline
    INT 21H
    MOV DL, 13                  ; ASCII value for cursor return
    INT 21H                                                    
    
    MOV DX, OFFSET smallestMsg
    ; LEA MOV DX, smallestMSG
    MOV AH, 09H
    INT 21H
    
    MOV AL, smallValue
    ADD AL, 48                  ; Converting decimal to ASCII
    ; ADD AL, 30H
    MOV DL, AL
    MOV AH, 02H
    INT 21H 
    
    
    
    CALL searching 
    
        
exit:
    MOV AH, 4CH
    INT 21H
    ; RET  

main ENDP  


     
     
smallest PROC
    MOV SI, 0
    MOV AL, array[SI]
    MOV smallValue, AL               ; Initializing small variabe with first digit of the array
               
    MOV CX, 4
    INC SI 
    
checkLevel:
    MOV AL, array[SI]
    CMP AL, smallValue
    JGE skipLoop
    MOV smallValue, AL 
    
skipLoop:
    INC SI
    LOOP checkLevel
    
    RET
    
smallest ENDP
    



searching PROC
    
    LEA DX, newline 
    MOV AH, 09H
    INT 21H
    
    LEA DX, searchMsg
    MOV AH, 09H
    INT 21H
    
    MOV AH, 01H
    INT 21H
    SUB AL, 48
    MOV searchValue, AL 
    
    
    MOV CX, 5
    MOV SI, OFFSET array
    
searchLevel:
    MOV BL, [SI]
    CMP BL, searchValue
    
    JZ valueFound
    INC SI
    LOOP searchLevel
    
    PRINTN 'Value not found in the array.'
    
    JMP exit
    
valueFound:
    PRINT 'Value Found in the aray.'
    RET

searching ENDP
    
    


; RET
END MAIN


















.MODEL SMALL
.STACK 100H
    
.DATA
    input DW ? 
    message DB 'Enter number: $'
    even DB 'Even Number$'
    odd DB 'Odd Number$'
    
.CODE  
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX  
    
    LEA DX, message
    MOV AH, 09H 
    INT 21H 
    
    
    MOV AH, 01H               ; Taking input from user
    INT 21H
    MOV input, AX
    
    
; Testing if entered number's LSB is 0 or 1
    TEST AX, 1                ; Bitwise AND operation
    JE PRINT_EVEN 
    JNE PRINT_ODD
    
PRINT_EVEN:
    MOV DX, OFFSET even
    MOV AH, 09H
    INT 21H 
    JMP EXIT
    
    
PRINT_ODD:
    MOV DX, OFFSET odd
    MOV AH, 09H
    INT 21H  
        
        
EXIT:

    MOV AH, 4CH
    INT 21H


MAIN ENDP
END MAIN
    




    