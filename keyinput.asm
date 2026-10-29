[bits 16]
[org 0x7c00]

start:

hang:

    mov ah, 0
    int 0x16

    mov ah, 0x0E
    int 0x10
    
    jmp hang

times 510-($-$$) db 0
dw 0xaa55