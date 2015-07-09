bits 16             ; runs in 16 bits real mode
org 7C00h           ; loaded by INT 19h at address 7C00h

start:
    call clear_screen
    mov ax, cs
    mov ds, ax

    mov si, msg     ; loads the address of first byte of string
    call print

print:
    push ax
    cld

next:
    mov al, [si]    ; grab a character
    cmp al, 0       ; is this the end of the string?
    je done         ; if so, exit from loop
    call printchar
    inc si          ; move to the next position in the string
    jmp next        ; repeat

done:
    cli             ; disable external interrupts
    hlt             ; stop the processor

printchar:
    mov ah, 0Eh     ; teletype mode
    int 10h
    ret

clear_screen:
    mov ah, 07h     ; scroll down window function
    mov al, 0       ; lines to scroll: scroll whole window

    mov bh, 0Ah     ; background / foreground colors

    mov cl, 0       ; left column number
    mov ch, 0       ; upper row number
    mov dl, 79      ; right column number
    mov dh, 24      ; lower row number

    int 10h
    ret

msg: db 'Hello World!', 0

; $  is the address of current line
; $$ is the address of first instruction
times 512 - 2 - ($ - $$) db 0

; boot signature 0x55 0xAA in little endian
dw 0AA55h
