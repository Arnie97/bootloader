bits 16             ; runs in 16 bits real mode
org 7C00h           ; loaded by INT 19h at address 7C00h

main:
    call init

    mov dh, 1       ; the second row
    mov dl, 36      ; column
    mov si, title   ; loads the pointer to string
    call print

print:
    call set_position

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

init:
    cli             ; clear and disable interrupts
    mov ax, cs      ; store data from code segment to
    mov ds, ax      ;   data segment,
    mov es, ax      ;   extra segment, and
    mov ss, ax      ;   stack segment.
    sti             ; then re-enable external interrupts

    mov cl, 0       ; left
    mov ch, 0       ; top
    mov dl, 79      ; right
    mov dh, 24      ; bottom
    mov bh, 0E0h    ; colors
    call set_color

    mov cl, 4       ; left
    mov ch, 3       ; top
    mov dl, 75      ; right
    mov dh, 22      ; bottom
    mov bh, 0Ch     ; colors
    call set_color

    ret

set_color:
    mov ah, 07h     ; scroll down window function
    mov al, 0       ; lines to scroll: scroll whole window
    int 10h
    ret

set_position:
    mov ah, 0Fh     ; Get current video mode and video page.
    int 10h         ; BH will ne the video page currently being displayed

    mov ah, 02h     ; move cursor
    int 10h
    ret

title:  db 'WARNING', 0

; $  is the address of current line
; $$ is the address of first instruction
times 512 - 2 - ($ - $$) db 0

; boot signature 0x55 0xAA in little endian
dw 0AA55h
