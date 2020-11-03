include \masm32\include\masm32rt.inc
include \masm32\include\masm32.inc
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
.386
.MODEL flat, stdcall
OPTION casemap:none ; convenion sobre mayusculas y minusculas al pasar parametros al api

.DATA

.code

start:
	printf("Proyecto Microprogramación")			; se imprime en pantala

	INVOKE ExitProcess,0									; se termina la ejecución

end start