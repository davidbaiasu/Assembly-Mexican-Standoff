[bits 16]
[org 0x7c00]

bVar1   db 17
bVar2   db 9
bResult db 0

start:

    mov al, [bVar1]
    add al, [bVar2]
    mov [bResult], al

hang:
    jmp hang

times 510-($-$$) db 0
dw 0xaa55