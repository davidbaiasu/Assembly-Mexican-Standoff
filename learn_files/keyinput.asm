[bits 16]
[org 0x7c00]

jmp start

pressUP      db "You pressed UP",    0
pressDOWN    db "You pressed DOWN",  0
pressLEFT    db "You pressed LEFT",  0
pressRIGHT   db "You pressed RIGHT", 0

start:

main_loop:

    mov ah, 0
    int 0x16

    cmp al, 'w'
    je up

    cmp al, 's'
    je down

    cmp al, 'a'
    je left

    cmp al, 'd'
    je right

    jmp main_loop

up:
    mov si, pressUP
    call print_string
    call print_newline
    jmp main_loop

down:
    mov si, pressDOWN
    call print_string
    call print_newline
    jmp main_loop

left:
    mov si, pressLEFT
    call print_string
    call print_newline
    jmp main_loop

right:
    mov si, pressRIGHT
    call print_string
    call print_newline
    jmp main_loop

print_newline:
    mov ah, 0x0E

    mov al, 13      ; CR = Carriage Return
    int 0x10

    mov al, 10      ; LF = Line Feed
    int 0x10

    ret

print_string:
    .loop:
        lodsb
        cmp al, 0
        je .done

        mov ah, 0x0E
        int 0x10

        jmp .loop

    .done:
        ret

times 510-($-$$) db 0
dw 0xaa55