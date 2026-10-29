[bits 16]
[org 0x7c00]

guyX db 40
guyY db 12

jmp start

clear_screen:
    mov ax, 0x0003
    int 0x10
    ret

move_cursor:
    ; dh = row dl = column
    mov ah, 02h
    mov bh, 0
    int 10h
    ret

draw_guy:

    mov dh, [guyY]
    mov dl, [guyX]
    call move_cursor

    mov ah, 0Eh
    mov al, '@'
    int 10h

    ret

redraw_guy:
    call clear_screen
    call draw_guy
    jmp main_loop

start:
    call clear_screen
    call draw_guy

main_loop:

    mov ah, 0
    int 16h

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
    dec byte [guyY]
    jmp redraw_guy

down:
    inc byte [guyY]
    jmp redraw_guy

left:
    dec byte [guyX]
    jmp redraw_guy

right:
    inc byte [guyX]
    jmp redraw_guy


times 510-($-$$) db 0
dw 0xaa55