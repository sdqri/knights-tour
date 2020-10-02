include emu8086.inc


org 100h    ; code starts at offset 100h	

; A 8086 assembly solution for knight's tour problem using warnsdorff's heuristic 
            xor cx,cx
            Lea si,msg1
            call print_string
            call scan_num
            mov position_x,cl
            xor cx,cx
            Lea si,msg2
            putc 13
            putc 10
            call print_string
            call scan_num
            mov position_y,cl 
            putc 13
            putc 10
            call solve
            ret
            
;finds (moves_x[],moves_y[]) by (position_x,position_y) -uses cx,al,ah,si
findmoves proc
            xor cx,cx
fm:         mov si,cx
            mov al,position_x
            mov ah,move_x[si]
            add al,ah
            mov moves_x[si],al
            mov al,position_y
            mov ah,move_y[si]
            add al,ah
            mov moves_y[si],al
            inc cx
            cmp cx,7
            jle fm
            ret
findmoves endp

;finds (mam_x[],mam_y[]) by (m_x,m_y) -uses cx,al,ah,si               
findmam proc
            xor cx,cx
fmam:       mov si,cx
            mov al,m_x
            mov ah,move_x[si]
            add al,ah
            mov mam_x[si],al
            mov al,m_y
            mov ah,move_y[si]
            add al,ah
            mov mam_y[si],al
            inc cx
            cmp cx,7
            jle fmam
            ret            
findmam endp

;checks move(m_x,m_y) is legal or illegal and returns 1 or 0 in (isl)- 
islegal proc
            cmp m_x,0
            jl illegal
            cmp m_x,7
            ja illegal
            cmp m_y,0
            jl illegal
            cmp m_y,7
            ja illegal
            mov isl,1
            ret
illegal:    mov isl,0
            ret
islegal endp

;checks existence of move(m_x,m_y) in hist[] and returns 1 or 0 in (e)- uses bl,bh,si
existinhist proc
            mov al,8
            mov bl,m_y
            mul bl
            xor bh,bh
            mov bl,m_x
            add ax,bx
            mov si,ax
            cmp hist[si],-1
            je leih
            mov e,1
            ret 
leih:       mov e,0
            ret                                                        
existinhist endp
            
;finds degree of move(m_x,m_y) and returns (degree) - calls findmam, islegal, existinhist - uses dl,dh,si                        
finddegree proc
            push cx
            call findmam
            xor dl,dl
            xor cx,cx
fde:        mov si,cx
            push ax
            mov al,mam_x[si]
            mov m_x,al
            mov al,mam_y[si]
            mov m_y,al
            pop ax
            call islegal
            cmp isl,0
            je continue
            call existinhist
            cmp e,1
            je continue
            inc dl
continue:   inc cx
            cmp cx,7
            jle fde
            mov degree,dl
            pop cx
            ret
finddegree endp

finddegrees proc
            xor cx,cx
lbl_fd:     mov si,cx
            mov al,moves_x[si]
            mov m_x,al
            mov checking_move_x,al
            mov al,moves_y[si]
            mov m_y,al
            mov checking_move_y,al
            call islegal
            cmp isl,0
            je invalid
            call existinhist
            cmp e,1
            je invalid
            call finddegree
            mov al,degree
            mov si,cx
            mov degrees[si],al
            inc cx
            cmp cx,7
            jle lbl_fd           
            ret
invalid:    mov al,-1
            mov si,cx
            mov degrees[si],al
            inc cx
            cmp cx,7
            jle lbl_fd
            ret            
finddegrees endp

;this procedure finds minimum value's index in states[]
findmin proc
            push ax
            push bx
            push cx
            push dx
            xor ax,ax    
            xor cx,cx   
            xor dx,dx
            mov dh,10
            mov dl,-1
findm:      mov si,cx
            mov ah,degrees[si]
            cmp ah,0
            jge notzero
            add ah,64
notzero:    cmp ah,dh
            jle isle
            jmp cont
isle:       mov dl,cl
            mov dh,ah
cont:       inc cx
            cmp cx,7
            jle findm
            mov min,dl     
            pop dx
            pop bx
            pop cx
            pop ax
            ret
findmin endp

move proc   
            push ax
            push bx
            push cx
            push dx
            xor ax,ax
            mov al,min
            mov si,ax
            mov al,8
            mov bl,moves_y[si]
            mov position_y,bl
            mul bl
            mov bl,moves_x[si]
            mov position_x,bl
            xor bh,bh
            add ax,bx
            mov si,ax
            mov al,n
            inc al
            mov hist[si],al
            mov n,al
            pop dx
            pop cx
            pop bx
            pop ax
            ret                
move endp

init proc
            push ax
            push bx
            push cx
            push dx
            xor ax,ax
            xor bx,bx
            mov al,8 
            mov bl,position_y
            mul bl
            mov bl,position_x
            add ax,bx
            mov si,ax
            mov al,n
            mov hist[si],al
            pop dx
            pop cx
            pop bx
            pop ax
            ret            
init endp

print_position proc
            mov al,position_x
            cmp al,0
            jne lb
            putc 65
            jmp ly
lb:         cmp al,1
            jne lc
            putc 66
            jmp ly
lc:         cmp al,2
            jne ld
            putc 67
            jmp ly
ld:         cmp al,3
            jne le
            putc 68
            jmp ly
le:         cmp al,4
            jne lf
            putc 69
            jmp ly
lf:         cmp al,5
            jne lg
            putc 70
            jmp ly
lg:         cmp al,6
            jne lh
            putc 71
            jmp ly
lh:         putc 72
ly:         xor ax,ax
            mov al,position_y
            cmp al,0
            jne l2
            putc 49
            jmp lbreak
l2:         cmp al,1
            jne l3
            putc 50
            jmp lbreak
l3:         cmp al,2
            jne l4
            putc 51
            jmp lbreak
l4:         cmp al,3
            jne l5
            putc 52
            jmp lbreak
l5:         cmp al,4
            jne l6
            putc 53
            jmp lbreak
l6:         cmp al,5
            jne l7
            putc 54
            jmp lbreak
l7:         cmp al,6
            jne l8
            putc 55
            jmp lbreak
l8:         putc 56
lbreak:     putc 13
            putc 10
            ret
print_position endp

solve proc  
            xor cx,cx            
lsolve:     push cx
            call init
            call print_position
            call findmoves
            call finddegrees
            call findmin
            call move
            pop cx
            inc cx
            cmp cx,64
            jle lsolve
            ret                           
solve endp

position_x db 0
position_y db 0
n db 0
m_x db ?
m_y db ?
isl db ?
e db ?
min db ? 
move_x db 2,1,-1,-2,-2,-1,1,2
move_y db 1,2,2,1,-1,-2,-2,-1
moves_x db 8 dup(?)
moves_y db 8 dup(?)
mam_x db 8 dup(?)
mam_y db 8 dup(?)
hist db 64 dup(-1)
checking_move_x db ?
checking_move_y db ?
degree db ?
print_cache dw ?,0            
degrees db 2,3,4,1,2,0,3,3
msg1 dw "Initial position -> x [0-7]:",0
msg2 dw "Initial position -> y [0-7]:",0

DEFINE_SCAN_NUM
DEFINE_PRINT_STRING 
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS 
ret




