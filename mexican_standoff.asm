[bits 16]
[org 0x7c00]

; Variables

redX db 
redY db
blueX db
blueY db
redBulletX db
redBulletY db
blueBulletX db
blueBulletY db

; Helper functions

clear_screen:
    mov ax, 0x0003
    int 0x10
    ret

hide_cursor:
    mov ah, 01h
    mov ch, 20h
    mov cl, 0
    int 10h
    ret

move_cursor:
    ; dh = row dl = column
    mov ah, 02h
    mov bh, 0
    int 10h
    ret

; Main game loop
game_loop

    jmp game_loop


%assign CODE_SIZE ($ - $$)
%warning Code size = CODE_SIZE bytes

times 510-($-$$) db 0
dw 0xaa55