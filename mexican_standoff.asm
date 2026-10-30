[bits 16]
[org 0x7c00]

; Variables

VARS    equ 0x0FA0
redY    equ VARS    ; players positions  
blueY   equ VARS+1  
wallK   equ VARS+2  ; wall positions
frames  equ VARS+3  ; frame counter
redBX   equ VARS+4  ; bullet coordinates
redBY   equ VARS+5
blueBX  equ VARS+6
blueBY  equ VARS+7

; Start of BIOS

start:
    cld
    mov ax, 3
    int 0x10
    mov ah, 1
    mov ch, 0x20
    int 0x10
    mov ax, 0xB800
    mov ds, ax
    mov es, ax
    mov di, VARS
    mov cx, 8
    xor ax, ax
    rep stosb
    mov word [redY], 0x0B0B

; Game loop

frame:
    xor di, di
    mov cx, 2000
    mov ax, 0x0720
    rep stosw       ; clear screen

    mov dx, 0x7720
    mov bh, 24

.draw_wall_row:

    mov bl, [wallK]
    call plot
    mov bl, 79
    sub bl, [wallK]
    call plot
    dec bh
    jns .draw_wall_row

    mov bl, [wallK]
    inc bl
    mov bh, [redY]
    mov dx, 0x4420
    call draw_player
    mov bl, 78
    sub bl, [wallK]
    mov bh, [blueY]
    mov dx, 0x1120
    call draw_player

    mov bl, [redBX]
    test bl, bl
    jz .skip_red_bullet
    mov bh, [redBY]
    mov dx, 0x0C2A
    call plot

.skip_red_bullet:

    mov bl, [blueBX]
    test bl, bl
    jz .skip_blue_bullet
    mov bh, [blueBY]
    mov dx, 0x092A
    call plot

.skip_blue_bullet:

    mov ah, 0x86
    xor cx, cx
    mov dx, 30000
    int 0x15

.input:

    mov ah, 1
    int 0x16
    jz .update_bullets
    xor ah, ah
    int 0x16
    or al, 0x20
    mov bx, redY
    cmp al, 'w'
    je .move_up
    cmp al, 's'
    je .move_down
    inc bx
    cmp al, 'i'
    je .move_up
    cmp al, 'k'
    je .move_down
    cmp al, 'd'
    je .red_shoot
    cmp al, 'j'
    je .blue_shoot
    jmp .input

.move_up:
    cmp byte [bx], 0
    je .input
    dec byte [bx]
    jmp .input

.move_down:

    cmp byte [bx], 22
    je .input
    inc byte [bx]
    jmp .input

.red_shoot:

    cmp byte [redBX], 0
    jne .input
    mov al, [wallK]
    add al, 2
    mov [redBX], al
    mov al, [redY]
    inc al
    mov [redBY], al
    jmp .input

.blue_shoot:
    cmp byte [blueBX], 0
    jne .input
    mov al, 77
    sub al, [wallK]
    mov [blueBX], al
    mov al, [blueY]
    inc al
    mov [blueBY], al
    jmp .input

.update_bullets:
    mov al, [redBX]
    test al, al
    jz .red_bullet_done
    inc al
    mov [redBX], al
    mov ah, 78
    sub ah, [wallK]
    cmp al, ah
    jb .red_bullet_done
    mov byte [redBX], 0
    mov al, [redBY]
    sub al, [blueY]
    cmp al, 3
    jae .red_bullet_done
    jmp win_red

.red_bullet_done:
    mov al, [blueBX]
    test al, al
    jz .end_blue_bullet
    dec al
    mov [blueBX], al
    mov ah, [wallK]
    inc ah
    cmp al, ah
    ja .end_blue_bullet
    mov byte [blueBX], 0
    mov al, [blueBY]
    sub al, [redY]
    cmp al, 3
    jae .end_blue_bullet
    jmp win_blue

.end_blue_bullet:

    inc byte [frames]
    test byte [frames], 63
    jnz .new_frame
    inc byte [wallK]
    cmp byte [wallK], 38
    je tie

.new_frame:

    jmp frame

; Game Over Screens

tie:      mov ax, 0x7720
          jmp over
win_red:  mov ax, 0x4420
          jmp over
win_blue: mov ax, 0x1120

over:

    xor di, di
    mov cx, 2000
    rep stosw
    mov ah, 0x86
    mov cx, 0x0F
    mov dx, 0x4240
    int 0x15

.flush_keyboard:

    mov ah, 1
    int 0x16
    jz .done
    xor ah, ah
    int 0x16
    jmp .flush_keyboard

.done:

    xor ah, ah  ; wait for a key, then restart
    int 0x16
    jmp start

plot:

    pusha
    mov al, 80
    mul bh
    mov bh, 0
    add ax, bx
    add ax, ax
    xchg di, ax
    mov ax, dx
    stosw
    popa
    ret

draw_player:

    mov cx, 3

.next_cell: 

    call plot
    inc bh
    loop .next_cell
    ret

%assign CODE_SIZE ($ - $$)
%warning Code size = CODE_SIZE bytes

times 510-($-$$) db 0
dw 0xaa55