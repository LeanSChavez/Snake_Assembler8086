.8086
.model small
.stack 100h
.data

    ingreso db "Presione cualquier tecla para continuar ...",0ah,0dh,24h

    finaltexto db "Su puntaje fue: ",0ah,24h

    color db 015
    x_coord db 0  
    y_coord db 0

    longitud dw 3
    longitud2 db 3

    cuadradoh1 dw 255
    cuadradov1 db 180
    cuadradov2 db 20
    cuadradoh2 dw 64

    dir db 0 

    puntaje dw 0 ,0ah,0dh,24h

    array_x db 134, 203, 156, 111, 245, 87, 221, 169, 188, 72

    array_y db 45, 112, 79, 156, 67, 135, 34, 98, 52, 165

    x_manzana db 0
    y_manzana db 0


    delayvar dw 30000

.code





main proc

mov ax, @data
mov ds, ax


    int 80h

    mov si, 0

    ; Mostrar mensaje de bienvenida
    mov ah, 9
    mov dx, offset ingreso
    int 21h

    ; Esperar que el usuario presione cualquier tecla
    mov ah, 1
    int 21h

    ; Cambiar a modo gráfico 13h (320x200, 256 colores)
    mov ah, 00h
    mov al, 13h
    int 10h


    ; Inicializar las coordenadas del "snake"
    mov x_coord, 150
    mov y_coord, 100






;CUADRADO ROJO ES 

;  64,20           255,20
 ;      ------------
 ;      |          |
 ;      |          |
 ;      |          |
 ;      |          |
 ;      |          |
 ;      -----------|
 ; 64,180           255,180

inicio:



movimiento:
    
    xor si,si
    xor bx,bx
    xor ax,ax
    xor dx,dx
    xor di,di
 

    call borrar


    cmp puntaje, 2
    je dif1

    cmp puntaje, 4
    je dif2

    cmp puntaje, 6
    je dif3

    jmp man



    jmp manzanilla
dif1:
    mov delayvar, 20000
    mov color, 013
    jmp man

dif2:
    mov delayvar, 15000
    mov color, 006
    jmp man
dif3:
    mov delayvar, 10000
    mov color, 003
    jmp man



man:
    cmp puntaje, 11
    je mepase

    jmp manzanilla

mepase:
mov puntaje,0

manzanilla:
    mov bx, puntaje
    mov al, array_x[bx]
    mov x_manzana, al

    mov al, array_y[bx]
    mov y_manzana, al

    call manzana
    
    mov ah, 11h
    int 16h
    jz aca

separacion:
    ; Leer la entrada del teclado
    mov ah, 00h
    int 16h
    ; Guardar en AL el carácter de la tecla presionada
    ; Comprobar las teclas presionadas
    cmp al, 4Ah        ; 'J' izquierda
    je izquierda_intermedio
    cmp al, 49h        ; 'I' arriba
    je arriba_intermedio
    cmp al, 4Ch        ; 'L' derecha
    je derecha_intermedio
    cmp al, 4Bh        ; 'K' abajo
    je abajo_intermedio


aca:
    cmp dir,1
    je izquierda_intermedio

    cmp dir,2
    je arriba_intermedio

    cmp dir,3
    je derecha_intermedio

    cmp dir,4
    je abajo_intermedio

    jmp separacion





izquierda_intermedio:
cmp dir,3
je derecha_intermedio

jmp izquierda
arriba_intermedio:
cmp dir, 4
je abajo_intermedio

jmp arriba
derecha_intermedio:
cmp dir,1
je izquierda_intermedio

jmp derecha
abajo_intermedio:
cmp dir,2
je arriba_intermedio

jmp abajo


izquierda:
    mov dir,1
     xor si,si
         
    dec x_coord     

izq2:

    ; Dibujar el píxel en las coordenadas (x_coord, y_coord)
    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, color      ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)
    mov cl, x_coord    ; Coordenada X (0 a 319) en CL
    mov dl, y_coord    ; Coordenada Y (0 a 199) en DL
    int 10h            ; Llamada a la interrupción 0x10
 
dibujar:
    cmp si, longitud
    jae seguir
    dec x_coord
    inc si
    jmp izq2


seguir:

    mov bl, longitud2
    mov ah, 0Ch
    mov al, 0
    mov bh, 00h
    add x_coord, bl
    mov cl, x_coord
    mov dl, y_coord
    int 10h
    

    call delay


    mov al, x_manzana
    cmp al, x_coord
    je casimanzanaizq
    jmp finalizq    

casimanzanaizq:
mov al, y_manzana
cmp al, y_coord
je esmanzanaizq
jmp finalizq

esmanzanaizq:
inc puntaje
inc longitud
inc longitud2
jmp movimiento

finalizq:

    mov dl, longitud2
    mov bl, 64
    ADD bl, dl
    cmp x_coord,bl
    jbe salir_intermedio2

    mov dl, longitud2
    mov bl, 255
    sub bl, dl
    cmp x_coord, bl
    jae salir_intermedio2

    mov dl, longitud2
    mov bl, 20
    add bl, dl
    cmp y_coord, bl
    jbe salir_intermedio2

    mov dl, longitud2
    mov bl, 180
    sub bl,dl
    cmp Y_coord, bl
    jae salir_intermedio2

    mov ah, 11h
    int 16h
    jnz movimiento_intermedio3

    


jmp izquierda


movimiento_intermedio3:
jmp movimiento


salir_intermedio2:
jmp salir


abajo:
    mov dir,4
    xor si,si
         
    inc y_coord       

aba2:

    ; Dibujar el píxel en las coordenadas (x_coord, y_coord)
    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, color      ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)
    mov cl, x_coord    ; Coordenada X (0 a 319) en CL
    mov dl, y_coord    ; Coordenada Y (0 a 199) en DL
    int 10h            ; Llamada a la interrupción 0x10
 
dibujar2:
    cmp si, longitud
    jae seguir2
    inc y_coord
    inc si
    jmp aba2


seguir2:
   

    mov bl, longitud2
    mov ah, 0Ch
    mov al, 0
    mov bh, 00h
    sub y_coord, bl
    mov cl, x_coord
    mov dl, y_coord
    int 10h
    

    call delay

    mov al, x_manzana
    cmp al, x_coord
    je casimanzanaaba
    jmp finalaba   

casimanzanaaba:
mov al, y_manzana
cmp al, y_coord
je esmanzanaaba
jmp finalaba

esmanzanaaba:
inc puntaje
inc longitud
inc longitud2
jmp movimiento

finalaba:
    mov dl, longitud2
    mov bl, 64
    ADD bl, dl
    cmp x_coord,bl
    jbe salir_intermedio

    mov dl, longitud2
    mov bl, 255
    sub bl, dl
    cmp x_coord, bl
    jae salir_intermedio

    mov dl, longitud2
    mov bl, 20
    add bl, dl
    cmp y_coord, bl
    jbe salir_intermedio

    mov dl, longitud2
    mov bl, 180
    sub bl,dl
    cmp Y_coord, bl
    jae salir_intermedio

     mov ah, 11h
    int 16h
    jnz movimiento_intermedio



jmp abajo



salir_intermedio:
jmp salir

movimiento_intermedio:
jmp movimiento

derecha:
    mov dir,3
        ;Me muevo a la derecha
    xor si,si
    inc x_coord

dere2:

    ; Dibujar el píxel en las coordenadas (x_coord, y_coord)
    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, color      ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)
    mov cl, x_coord    ; Coordenada X (0 a 319) en CL
    mov dl, y_coord    ; Coordenada Y (0 a 199) en DL
    int 10h            ; Llamada a la interrupción 0x10


dibujar3:
    cmp si, longitud
    jae seguir3
    inc x_coord
    inc si
    jmp dere2

seguir3:



    mov bl, longitud2
    mov ah, 0Ch
    mov al, 0
    mov bh, 00h

    sub x_coord,bl

    mov cl, x_coord
    mov dl, y_coord
    int 10h

    call delay

    mov al, x_manzana
    cmp al, x_coord
    je casimanzanadere
    jmp finaldere   

casimanzanadere:
mov al, y_manzana
cmp al, y_coord
je esmanzanadere
jmp finaldere

esmanzanadere:
inc puntaje
inc longitud
inc longitud2
jmp movimiento

finaldere:
       mov dl, longitud2
    mov bl, 64
    ADD bl, dl
    cmp x_coord,bl
    jbe salir_intermedio3

    mov dl, longitud2
    mov bl, 255
    sub bl, dl
    cmp x_coord, bl
    jae salir_intermedio3

    mov dl, longitud2
    mov bl, 20
    add bl, dl
    cmp y_coord, bl
    jbe salir_intermedio3

    mov dl, longitud2
    mov bl, 180
    sub bl,dl
    cmp Y_coord, bl
    jae salir_intermedio3

    mov ah, 11h
    int 16h
    jnz movimiento_intermedio2


 
jmp derecha




salir_intermedio3:
jmp salir

movimiento_intermedio2:
jmp movimiento_intermedio

arriba:
    mov dir,2
           ;Me muevo a la derecha
    xor si,si
    dec y_coord

arri2:

    ; Dibujar el píxel en las coordenadas (x_coord, y_coord)
    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, color      ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)
    mov cl, x_coord    ; Coordenada X (0 a 319) en CL
    mov dl, y_coord    ; Coordenada Y (0 a 199) en DL
    int 10h            ; Llamada a la interrupción 0x10


dibujar4:
    cmp si, longitud
    jae seguir4
    dec y_coord
    inc si
    jmp arri2

seguir4:
    

    mov bl, longitud2
    mov ah, 0Ch
    mov al, 0
    mov bh, 00h

    add y_coord,bl

    mov cl, x_coord
    mov dl, y_coord
    int 10h

    call delay

    mov al, x_manzana
    cmp al, x_coord
    je casimanzanaarri
    jmp finalarri    

casimanzanaarri:
mov al, y_manzana
cmp al, y_coord
je esmanzanaarri
jmp finalarri

esmanzanaarri:
inc puntaje
inc longitud
inc longitud2
jmp movimiento

finalarri:
    mov dl, longitud2
    mov bl, 64
    ADD bl, dl
    cmp x_coord,bl
    jbe salir

    mov dl, longitud2
    mov bl, 255
    sub bl, dl
    cmp x_coord, bl
    jae salir

    mov dl, longitud2
    mov bl, 20
    add bl, dl
    cmp y_coord, bl
    jbe salir
    mov dl, longitud2
    mov bl, 180
    sub bl,dl
    cmp Y_coord, bl
    jae salir

    mov ah, 11h
    int 16h
    jnz movimiento_intermedio4



jmp arriba

movimiento_intermedio4:
jmp movimiento

salir:
    mov ah,00h
    mov al,03h
    int 10h

    mov ah,9
    mov dx, offset finaltexto
    int 21h


    add PUNTAJE,30h

    mov ah,9
    mov dx, offset puntaje
    int 21h





    ; Salir del programa
    mov ax, 4c00h
    int 21h




main endp

borrar proc
push ax
push bx
push cx
push dx


; Borrar toda la pantalla a color negro (0)
mov cx, 65
mov dx, 21
mov al, 0  ; Color negro

limpiar_pantalla:
    mov ah, 0Ch ; Función 0x0C: Escribir un píxel
    int 10h     ; Llamada a la interrupción 0x10
    inc cx      ; Incrementar la columna
    cmp cx, 254 ; Si la columna es 320, resetear a 0 y avanzar una fila
    jne continuarfunc
    mov cx, 65  ; Resetear columna a 0
    inc dx      ; Incrementar la fila

continuarfunc:
    cmp dx, 179 ; Si la fila es 200, hemos terminado
    jl limpiar_pantalla


interfaz:
    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, 4      ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)
    mov cx, cuadradoh1        ; Coordenada X (0 a 319) en CL
    mov dl, cuadradov1        ; Coordenada Y (0 a 199) en DL
    int 10h            ; Llamada a la interrupción 0x10

    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, 4      ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)
    mov cx, cuadradoh1        ; Coordenada X (0 a 319) en CL
    mov dl, cuadradov2        ; Coordenada Y (0 a 199) en DL
    int 10h            ; Llamada a la interrupción 0x10

    dec cuadradoh1
    cmp cuadradoh1, 64
    je continuar
    jmp interfaz


continuar:
mov cuadradoh1, 255
mov cuadradoh2, 64
mov cuadradov2, 20



interfaz2:
    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, 4      ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)
    mov cx, cuadradoh1        ; Coordenada X (0 a 319) en CL
    mov dl, cuadradov2        ; Coordenada Y (0 a 199) en DL
    int 10h            ; Llamada a la interrupción 0x10

    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, 4      ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)
    mov cx, cuadradoh2        ; Coordenada X (0 a 319) en CL
    mov dl, cuadradov2        ; Coordenada Y (0 a 199) en DL
    int 10h            ; Llamada a la interrupción 0x10

    inc cuadradov2
    cmp cuadradov2, 180
    je finalfunc
    jmp interfaz2

    
 finalfunc:   


; Continúa con el resto de tu código
pop dx
pop cx
pop bx
pop ax
ret
borrar endp


manzana proc
    push ax
    push bx
    push cx
    push si


    xor bx,bx
    xor si,si

    mov ah, 0Ch        ; Función 0x0C: Escribir un píxel
    mov al, 2          ; Color del píxel (0-255)
    mov bh, 00h        ; Página de video (usualmente 0)

    mov cl, x_manzana       ; Coordenada X (0 a 319) en CL
    mov dl, y_manzana     ; Coordenada Y (0 a 199) en DL

    int 10h            ; Llamada a la interrupción 0x10


    pop si
    pop cx
    pop bx
    pop ax
    ret
manzana endp








delay proc
push cx




     xor cx,cx
     mov cx, delayvar
     
delaycic:
   
loop delaycic 

pop cx
ret

delay endp

end




