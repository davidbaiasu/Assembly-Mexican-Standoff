[bits 16]
[org 0x7c00]

jmp start

add_msg db "Addition result     => ", 0
sub_msg db "Substraction result => ", 0

var1      db    20
var2      db    8
addResult db    0
subResult db    0

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

print_number:
    mov ah, 0
    mov bl, 10
    div bl

    mov dl, ah

    cmp al, 0
    je .units

    add al, '0'
    mov ah, 0x0E
    int 0x10

.units:
    mov al, dl
    add al, '0'
    mov ah, 0x0E
    int 0x10

    ret

start:

    mov al, [var1]
    add al, [var2]
    mov [addResult], al

    mov al, [var1]
    sub al, [var2]
    mov [subResult], al

    mov si, add_msg
    call print_string
    mov al, [addResult]
    call print_number
    call print_newline

    mov si, sub_msg
    call print_string
    mov al, [subResult]
    call print_number
    call print_newline

hang:
    jmp hang

times 510-($-$$) db 0
dw 0xaa55