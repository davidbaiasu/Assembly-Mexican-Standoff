[bits 16]
[org 0x7c00]

msg db "Hello, World!", 0

start:
    mov si, msg

print_loop:
    lodsb
    cmp al, 0
    je hang

    mov ah, 0x0E
    int 0x10

    jmp print_loop

hang:
    jmp hang

times 510-($-$$) db 0
dw 0xaa55