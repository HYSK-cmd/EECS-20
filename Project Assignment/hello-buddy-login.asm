                .ORIG x3000
; USERNAMES AND PASSWORDS DATABASE
;-----------------------------------;
USERNAME_1      .STRINGZ "panteater"
USERNAME_2      .STRINGZ "qv"
USERNAME_3      .STRINGZ "hoon!@#"
;-----------------------------------;
PASSWORD_1      .STRINGZ "peter"
PASSWORD_2      .STRINGZ "hellothere!"
PASSWORD_3      .STRINGZ "theGoat!"
;-----------------------------------;
HELLO           .STRINGZ "Hello, "
; PRINT PROMPT AFTER A SUCCESSFUL LOGIN
        LEA     R1, HELLO           ; Starting address of HELLO
        
; GET TO END OF HELLO STRING FOR APPENDING INPUT "Hello, <USERNAME>"
AGAIN1   LDR     R2, R1, #0          ; Load char at hello address into R2
        BRz     US_PROMPT           ; If done w/ string (x0000), go to NEXT
        ADD     R1, R1, #1          ; Increment hello address
        BR      AGAIN1               ; Loop until it enounters a null terminator

; PRINT PROMPT FOR USER INPUT   
US_PROMPT       LEA R0, PROMPT_US   ; Get address of prompt for username
                TRAP x22            ; PUTS
                JSR READ_INPUT_US   ; Get an input
                BR  MAIN            ; Go to MAIN
                
; FILL IN USER INPUT BY APPENDING TO WHERE R1 POINTS (AFTER DEFAULT HELLO STRING) 
READ_INPUT_US   LEA R1, INPUT_US    ; Get address of INPUT_US
                LD  R3, NEGENTER    ; Store (through ld) NEGENTER into R3 for termination comparing later
    AGAIN2      TRAP x20            ; GETC (gather user input one char at a time)
                TRAP x21            ; OUT (output char for user on console)
                ADD R2, R0, R3      ; Check if user pressed ENTER key
                BRz EXIT1           ; If they did, we are done - go to CONT
                STR R0, R1, #0      ; Store value in R0 (user input) into memory (wherever end of HELLO string is pointing)
                ADD R1, R1, #1      ; Increment address of R1 so that we can write to the next available spot
                BR  AGAIN2          ; Loop until it encounters an ENTER key
    EXIT1       AND R0, R0, #0      ; Clear R0
                STR R0, R1, #0      ; Store R0
                RET                 ; Return to the Caller
                
; CHECK USERNAME 
MAIN            LEA R1, INPUT_US    ; Get address of INPUT_US
                LEA R2, USERNAME_1  ; Get address of USERNAME_1
                JSR COMPARE_USERNAMES_1; Compare two usernames
                BRz PASSWORD_PROMPT ; If R7=0, prompt a password
ENCRYPTING      JSR ENCRYPT_PW      ; Encrypt the password
                LEA R1, INPUT_PW    ; Get address of INPUT_PW
                LEA R2, PASSWORD_1  ; Get address of PASSWORD_1
                JSR COMPARE_PASSWORDS_1; Compare two passwords
                BRz CORRECT_PW      ; Go to CORRECT_PW
                JSR DECRYPT_PW      ; Decrypt the password
                TRAP x25            ; If login succeeds, terminate the program with a login message

; PRINT PROMPT FOR PASSWORD INPUT                 
PASSWORD_PROMPT LEA R0, PROMPT_PW   ; Get address of prompt for password
                TRAP x22            ; PUTS
                JSR READ_INPUT_PW   ; Get an input
                BR  ENCRYPTING      ; Go to ENCRYPTING
                
; GET A PASSWORD INPUT 
READ_INPUT_PW   LEA R1, INPUT_PW    ; Get address of INPUT_US
                LD  R3, NEGENTER    ; Store (through ld) NEGENTER into R3 for termination comparing later
    AGAIN3      TRAP x20            ; GETC (gather user input one char at a time)
                TRAP x21            ; OUT (output char for user on console)
                ADD R2, R0, R3      ; Check if user pressed ENTER key
                BRz EXIT2           ; If they did, we are done - go to CONT
                STR R0, R1, #0      ; Store value in R0 (user input) into memory (wherever end of HELLO string is pointing)
                ADD R1, R1, #1      ; Increment address of R1 so that we can write to the next available spot
                BR  AGAIN3          ; Loop until it encounters an ENTER key
    EXIT2       AND R0, R0, #0      ; Clear R0
                STR R0, R1, #0      ; Store R0
                RET                 ; Return to the Caller

; COMPARE WITH USERNAMES_1 (Recursive subroutine)
COMPARE_USERNAMES_1
                AND R3, R3, #0      ; Clear R3
                LDR R4, R2, #0      ; Load character from stored username in DATABASE
                LDR R3, R1, #0      ; Load character from INPUT_US
                BRz USERNAME_ENDS_1 ; If matched, go to USERNAME_MATCH
                NOT R3, R3          ; Character comparison
                ADD R3, R3, #1      ; Take Two's Complement
                ADD R5, R4, R3      ; Check if they are the same character
                BRnp COMPARE_USERNAMES_2 ; If not matched, go to COMPARE_USERNAMES_1
                ADD R1, R1, #1      ; Move to next character in INPUT_US
                ADD R2, R2, #1      ; Move to next character in stored username in DATABASE
                BR COMPARE_USERNAMES_1; Loop until it's completed
USERNAME_ENDS_1 LDR R4, R2, #0      ; Load character from stored username in DATABASE
                BRz USERNAME_MATCH1 ; If DATABASE also ends, strings match
                BRnp NOT_MATCHED_USERNAME ; Otherwise, strings do not match
USERNAME_MATCH1 AND R1, R1, #0      ; Clear R1
                AND R2, R2, #0      ; Clear R2
                RET                 ; Return to the caller
; COMPARE WITH USERNAME_2 (Recursive subroutine)
    COMPARE_USERNAMES_2 LEA R2, USERNAME_2  ; Get address of USERNAME_2
            AGAIN4      AND R3, R3, #0      ; Clear R3
                        LDR R4, R2, #0      ; Load character from stored username in DATABASE
                        LDR R3, R1, #0      ; Load character from INPUT_US
                        BRz USERNAME_ENDS_2 ; If matched, go to USERNAME_MATCH
                        NOT R3, R3          ; Character comparison
                        ADD R3, R3, #1      ; Take Two's Complement
                        ADD R5, R4, R3      ; Check if they are the same character
                        BRnp COMPARE_USERNAMES_3 ; If not matched, go to COMPARE_USERNAMES_2
                        ADD R1, R1, #1      ; Move to next character in INPUT_US
                        ADD R2, R2, #1      ; Move to next character in stored username in DATABASE
                        BR  AGAIN4          ; Loop until it's completed
            USERNAME_ENDS_2 LDR R4, R2, #0      ; Load character from stored username in DATABASE
                            BRz USERNAME_MATCH2 ; If DATABASE also ends, strings match
                            BRnp NOT_MATCHED_USERNAME ; Otherwise, strings do not match
            USERNAME_MATCH2 AND R1, R1, #0  ; Clear R1
                            AND R2, R2, #0  ; Clear R2
                            RET             ; Return to the caller
; COMPARE WITH USERNAME_3 (Recursive subroutine) 
        COMPARE_USERNAMES_3 LEA R2, USERNAME_3  ; Get address of USERNAME_2
            AGAIN5          AND R3, R3, #0      ; Clear R3
                            LDR R4, R2, #0      ; Load character from stored username in DATABASE
                            LDR R3, R1, #0      ; Load character from INPUT_US
                            BRz USERNAME_ENDS_3 ; If matched, go to USERNAME_MATCH
                            NOT R3, R3          ; Character comparison
                            ADD R3, R3, #1      ; Take Two's Complement
                            ADD R5, R4, R3      ; Check if they are the same character
                            BRnp NOT_MATCHED_USERNAME ; If not matched, go to NOT_MATCHED_USERNAME
                            ADD R1, R1, #1      ; Move to next character in INPUT_US
                            ADD R2, R2, #1      ; Move to next character in stored username in DATABASE
                            BR  AGAIN5          ; Loop until it's completed
                USERNAME_ENDS_3 LDR R4, R2, #0  ; Load character from stored username in DATABASE
                                BRz USERNAME_MATCH3 ; If DATABASE also ends, strings match
                                BRnp NOT_MATCHED_USERNAME ; Otherwise, strings do not match
                USERNAME_MATCH3 AND R1, R1, #0  ; Clear R1
                                AND R2, R2, #0  ; Clear R2
                                RET             ; Return to the caller
                                
; COMPARE WITH PASSWORDS_1 (Recursive subroutine)                                 
COMPARE_PASSWORDS_1
                AND R3, R3, #0      ; Clear R3
                LDR R4, R2, #0      ; Load character from stored username in DATABASE
                LDR R3, R1, #0      ; Load character from INPUT_PW
                BRz PASSWORD_ENDS_1 ; If matched, go to PASSWORD_ENDS_1
                NOT R3, R3          ; Character comparison
                ADD R3, R3, #1      ; Take Two's Complement
                ADD R5, R4, R3      ; Check if they are the same character
                BRnp COMPARE_PASSWORDS_2 ; If not matched, go to COMPARE_PASSWORDS_2
                ADD R1, R1, #1      ; Move to next character in INPUT_US
                ADD R2, R2, #1      ; Move to next character in stored username in DATABASE
                BR COMPARE_PASSWORDS_1; Loop until it's completed
PASSWORD_ENDS_1 LDR R4, R2, #0      ; Load character from stored password in DATABASE
                BRz PASSWORD_MATCH1 ; If DATABASE also ends, strings match
                BRnp INCORRECT_PW   ; Otherwise, strings do not match. Go to INCORRECT_PW
PASSWORD_MATCH1 AND R1, R1, #0      ; Clear R1
                AND R2, R2, #0      ; Clear R2
                RET                 ; Return to the caller
; COMPARE WITH PASSWORD_2 (Recursive subroutine) 
    COMPARE_PASSWORDS_2 LEA R2, PASSWORD_2
            AGAIN6      AND R3, R3, #0      ; Clear R3
                        LDR R4, R2, #0      ; Load character from stored username in DATABASE
                        LDR R3, R1, #0      ; Load character from INPUT_US
                        BRz PASSWORD_ENDS_2 ; If matched, go to USERNAME_MATCH
                        NOT R3, R3          ; Character comparison
                        ADD R3, R3, #1      ; Take Two's Complement
                        ADD R5, R4, R3      ; Check if they are the same character
                        BRnp COMPARE_PASSWORDS_3 ; If not matched, go to COMPARE_PASSWORDS_3
                        ADD R1, R1, #1      ; Move to next character in INPUT_US
                        ADD R2, R2, #1      ; Move to next character in stored username in DATABASE
                        BR  AGAIN6          ; Loop until it's completed
            PASSWORD_ENDS_2 LDR R4, R2, #0      ; Load character from stored password in DATABASE
                            BRz PASSWORD_MATCH2 ; If DATABASE also ends, strings match
                            BRnp INCORRECT_PW   ; Otherwise, strings do not match. Go to INCORRECT_PW
            PASSWORD_MATCH2 AND R1, R1, #0  ; Clear R1
                            AND R2, R2, #0  ; Clear R2
                            RET             ; Return to the caller
                            
; COMPARE WITH PASSWORD_3 (Recursive subroutine) 
        COMPARE_PASSWORDS_3 LEA R2, PASSWORD_3
            AGAIN7          AND R3, R3, #0      ; Clear R3
                            LDR R4, R2, #0      ; Load character from stored username in DATABASE
                            LDR R3, R1, #0      ; Load character from INPUT_US
                            BRz PASSWORD_ENDS_3 ; If matched, go to USERNAME_MATCH
                            NOT R3, R3          ; Character comparison
                            ADD R3, R3, #1      ; Take Two's Complement
                            ADD R5, R4, R3      ; Check if they are the same character
                            BRnp INCORRECT_PW   ; If not matched, go to NOT_MATCHED_USERNAME
                            ADD R1, R1, #1      ; Move to next character in INPUT_US
                            ADD R2, R2, #1      ; Move to next character in stored username in DATABASE
                            BR  AGAIN7          ; Loop until it's completed
                PASSWORD_ENDS_3 LDR R4, R2, #0      ; Load character from stored password in DATABASE
                                BRz PASSWORD_MATCH3 ; If DATABASE also ends, strings match
                                BRnp INCORRECT_PW   ; Otherwise, strings do not match. Go to INCORRECT_PW
                PASSWORD_MATCH3 AND R1, R1, #0  ; Clear R1
                                AND R2, R2, #0  ; Clear R2
                                RET             ; Return to the caller
                
; ENCRYPT THE PASSWORD (subroutine)
ENCRYPT_PW      LEA R0, INPUT_PW    ; Get address of USER_INPUT
                LEA R1, PASSWORD    ; Get address of PASSWORD
                LD  R2, ENCRYPT_KEY ; Load ASCII difference
LOOP_ENCRYPT    LDR R3, R0, #0      ; Load a character from USER_INPUT
                BRz EXIT3           ; Test for terminating
                ADD R3, R3, R2      ; Encrypt character
                STR R3, R1, #0      ; Store encrypted character in PASSWORD
                ADD R0, R0, #1      ; Move to the next character
                ADD R1, R1, #1      ; Move to the next encrypted storage location
                BR  LOOP_ENCRYPT    ; Loop until it completes encrypting
EXIT3           RET                 ; Return to caller
  
; DECRYPT THE PASSWORD (subroutine) 
DECRYPT_PW      LEA R0, INPUT_PW    ; Get address of USER_INPUT
                LEA R1, PASSWORD    ; Get address of PASSWORD
                LD  R2, DECRYPT_KEY ; Load ASCII difference
LOOP_DECRYPT    LDR R3, R0, #0      ; Load a character from USER_INPUT
                BRz EXIT4           ; Test for terminating
                ADD R3, R3, R2      ; Encrypt character
                STR R3, R1, #0      ; Store encrypted character in PASSWORD
                ADD R0, R0, #1      ; Move to the next character
                ADD R1, R1, #1      ; Move to the next encrypted storage location
                BR  LOOP_DECRYPT    ; Loop until it completes decrypting
EXIT4           RET                 ; Return to the caller

; IF USERNAME NOT MATCHED (subroutine) 
NOT_MATCHED_USERNAME
                LDI R7, LOGIN_MAX_TRIES   ; Load indirect the address of MAX_TRIES
                ADD R7, R7, #-1     ; Decrement the number of tries left
                STI R7, LOGIN_MAX_TRIES   ; Store the number of tries left
                BRz NO_MORE_TRIES_FOR_USERNAME ; If R7=0, go to the terminator subroutine
                LEA R0, USER_NOT_EXIST_MSG; Get address of USER_NOT_EXIST_MSG
                TRAP x22            ; Prompt the message
                LD R0, NEWLINE      ; Feed a newline
                TRAP x21            ; OUT
                BR  US_PROMPT       ; Go back to Login Program
    ; IF THERE'S NO MORE TRIES LEFT (subroutine) 
    NO_MORE_TRIES_FOR_USERNAME
                    LEA R0, NO_MORE_TRIES_MSG ; Get address of NO_MORE_TRIES_MSG
                    TRAP x22        ; Prompt the message
                    TRAP x25        ; HALT
                    
; If THE USER ENTERS A CORRECT PASSWORD (subroutine)
CORRECT_PW      LEA R0, HELLO       ; Get address of "Hello, "
                TRAP x22            ; Prompt the hello message
                LEA R0, INPUT_US    ; Get address of USERNAME
                TRAP x22            ; Prompt the message
                LD R0, NEWLINE      ; Feed a newline
                TRAP x21            ; OUT
                LEA R0,LOGIN_SUCCESS; Get address of LOGIN_SUCCESS
                TRAP x22            ; Prompt the message
                TRAP x25            ; HALT

; If THE USER ENTERS AN INCORRECT PASSWORD (subroutine) 
INCORRECT_PW    LDI R6, PW_MAX_TRIES; Load indirect the address of MAX_TRIES
                ADD R6, R6, #-1     ; Decrement the number of tries left
                STI R6, PW_MAX_TRIES; Store the number of tries left
                BRz NO_MORE_TRIES_FOR_PASSWORD ; If R7=0, go to the terminator subroutine
                LEA R0, PW_NOT_EXIST_MSG; Get address of PW_NOT_EXIST_MSG
                TRAP x22            ; Prompt the message
                LD R0, NEWLINE      ; Feed a newline
                TRAP x21            ; OUT
                BR  US_PROMPT       ; Go back to Login Program
; IF THERE'S NO MORE TRIES LEFT (subroutine)
    NO_MORE_TRIES_FOR_PASSWORD
                    LEA R0, NO_MORE_TRIES_MSG ; Get address of NO_MORE_TRIES_MSG
                    TRAP x22        ; Prompt the message
                    TRAP x25
                    
; CONSTANTS                         
NEGENTER        .FILL   xFFF6       ; -x0A
ENCRYPT_KEY     .FILL   x-1234      ; Key to encrypt the password
DECRYPT_KEY     .FILL   x1234       ; Key to decrypt the password
NEWLINE         .FILL   x0D         ; x0D
LOGIN_MAX_TRIES .FILL   LOGIN_TRIES_LEFT; # of Tries
LOGIN_TRIES_LEFT .FILL  #3          ; # of Tries
PW_MAX_TRIES    .FILL   PW_TRIES_LEFT; # of Tries
PW_TRIES_LEFT   .FILL   #3          ; # of Tries

; DATA SECTIONS
LDI_USER_NOT_EXIST_MSG  .FILL   USER_NOT_EXIST_MSG
INPUT_US        .BLKW   #13         ; BUFFER TO STORE A USERNAME INPUT
PASSWORD        .BLKW   #13         ; PASSWORD STORAGE
INPUT_PW        .BLKW   #13         ; BUFFER TO STORE A PASSWORD INPUT

; STRINGS
PROMPT_US           .STRINGZ    "Enter username: "
PROMPT_PW           .STRINGZ    "Enter password: "
LOGIN_SUCCESS       .STRINGZ    "Congratulations! You have logged in."
NO_MORE_TRIES_MSG   .STRINGZ    "No more tries left. Terminating program..."
USER_NOT_EXIST_MSG  .STRINGZ    "The username you entered does not exist. Please try again."
PW_NOT_EXIST_MSG    .STRINGZ    "The password you entered does not exist. Please try again."
INCORRECT_PW_MSG    .STRINGZ    "Incorrect Password. Please enter the password again: "
.END