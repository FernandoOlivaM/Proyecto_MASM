cls macro
	pusha
	mov ah, 0x00
	mov al, 0x03  
	int 0x10
	popa
endm

.386
.MODEL flat, stdcall
OPTION casemap:none
;INCLUDES
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
.DATA
	;variables para el menu
	menuPrincipal		db 13,10,"Por favor, ingrese el numero de opcion a ejecutar:",13,10,09,"a. CIFRADO UTILIZANDO SOLO LA CLAVE ",13,10,09,"b. CIFRADO UTILIZANDO LA CLAVE Y MENSAJE  ",13,10,09,"c. DESCIFRADO UTILIZANDO SOLO LA CLAVE ",13,10,09,"d. DESCIFRADO UTILIZANDO LA CLAVE Y PALABRA",13,10,09,"e. DESCIFRADO ESTADISTICO ",13,10,09,"f. CIFRADO ESTADISTICO",13,10,09,"g. SALIR ",13,10,">",0
	textoOpta			db 13,10,"CIFRADO UTILIZANDO SOLO LA CLAVE",13,10,0
	textoOptb			db 13,10,"CIFRADO UTILIZANDO LA CLAVE Y MENSAJE",13,10,0
	textoOptc			db 13,10,"DESCIFRADO UTILIZANDO SOLO LA CLAVE",13,10,0
	textoOptd			db 13,10,"DESCIFRADO UTILIZANDO LA CLAVE Y PALABRA",13,10,0
	textoOpte			db 13,10,"DESCIFRADO ESTADISTICO",13,10,0
	textoOptf			db 13,10,"CIFRADO ESTADISTICO",13,10,0
	textoOptNoValida	db 13,10,"Por favor, ingrese una opcion valida",13,10,0
	optMenu				db 0,0

	;VARIABLES PARA CREAR LA MATRIZ
	MATRIZ DW 676 DUP (0),0
	CadenaL DB "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0va 
	salto DB 10d, 0
	ContadorL0 DB 0,0
	ContadorL1 DB 0,0
	ContadorL2 DB 26,0
	pos DB 0,0
	pos1 DB 0,0
	vAux DB 0,0
.CODE
main:
	MenuPrincipal:
	;cls ; se llama a la macro para limpiar la pantalla
		INVOKE StdOut, ADDR menuPrincipal ; mensaje para mostra el menu y solicitar una opcion
		INVOKE StdIn, ADDR optMenu,10	; se lee la opcion del menu principal
		cmp     optMenu, 'a'				; se evalua que la opcion sea valida
        jl      OptNoValida                                                                
        cmp     optMenu, 'g'				; la opcion debe ser un numero entre a y e             
        jg      OptNoValida                                                        
        cmp     optMenu, 'a'				; la opcion a ejecuta el crifrado con clave
        je      cifClave                                                              
        cmp     optMenu, 'b'				; la opcion b ejecuta el cifrado con clave y palabra
        je      cifClavePalabra    
		cmp     optMenu, 'c'				; la opcion c ejecuta el descifrado con clave
        je      desClave
		cmp     optMenu, 'd'				; la opcion d ejecuta el descifrado con clave y palabra
        je      desClavePalabra
		cmp     optMenu, 'e'				; la opcion d eje cuta el descifrado estadisco
        je      desEstadistico 
		cmp     optMenu, 'f'				; la opcion e eje cuta el cifrado estadisco
        je      cifEstadistico 
        cmp     optMenu, 'g'             ; la opcion f ejecuta la opcion de salir                                                      
        jmp     Salir 

	;LLENAR LA MATRIZ CON CARACTERES
	CALL LLENARMATRIZ
	cifClave:
		INVOKE StdOut, ADDR textoOpta
		jmp MenuPrincipal	
	cifClavePalabra:
		INVOKE StdOut, ADDR textoOptb
		jmp MenuPrincipal	
	desClave:
		INVOKE StdOut, ADDR textoOptc
		jmp MenuPrincipal
	desClavePalabra:
	INVOKE StdOut, ADDR textoOptd
		jmp MenuPrincipal
	desEstadistico:
		INVOKE StdOut, ADDR textoOptd
		jmp MenuPrincipal
	cifEstadistico:
		INVOKE StdOut, ADDR textoOpte
		jmp MenuPrincipal
	OptNoValida:
		INVOKE StdOut, ADDR textoOptNoValida	; se da a conocer que la opcion no es valida
		jmp MenuPrincipal
	Salir:
		INVOKE ExitProcess, 0	

LLENARMATRIZ PROC FAR
	XOR BX, BX
	XOR CX, CX
	XOR AX, AX
	XOR DX, DX
	LEA ESI, MATRIZ
	MOV AL, ContadorL2
	MOV ContadorL0, AL
CICLOL:
	MOV AL, ContadorL0
	CMP AL, 00h
	JE FINCICLOL
	;ENCONTRAR LA LETRA EN LA QUE DEBE DE EMPEZAR LA LETRA DE LA SIGUIENTE FILA
	CALL ENCONTRARLETRA
	MOV DL, [EDI]
	;INGRESAR A LA CADENA MATRIZ
	CALL INGRESARAMATRIZ
	INC pos
	DEC ContadorL0
JMP CICLOL
FINCICLOL:
	INVOKE StdOut, ADDR MATRIZ
RET
LLENARMATRIZ ENDP

ENCONTRARLETRA PROC NEAR
	MOV DL, pos
	MOV pos1, DL
	LEA EDI, CadenaL
ENCONTRAR:
	CMP pos1, 00h
	JE FINENCONTRAR
	DEC pos1
	INC EDI
JMP ENCONTRAR
FINENCONTRAR:
RET
ENCONTRARLETRA ENDP

INGRESARAMATRIZ PROC NEAR
	MOV AL, ContadorL2
	MOV ContadorL1, AL
INGRESO:
	CMP ContadorL1, 00h
	JE FININGRESO
	MOV DL, [EDI]
	CMP DL, 00h
	JNE SALTOINGRESO
	LEA EDI, CadenaL
SALTOINGRESO:
	MOV DL, [EDI]
	MOV [ESI], DL
	INC ESI
	INC EDI
	DEC ContadorL1
JMP INGRESO
FININGRESO:
RET
INGRESARAMATRIZ ENDP
END main