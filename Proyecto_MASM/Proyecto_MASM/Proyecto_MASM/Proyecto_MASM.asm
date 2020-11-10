.386
.MODEL flat, stdcall
OPTION casemap:none
;INCLUDES
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
.DATA
	vAux DB 10d, 0
.CODE
main:
	INVOKE StdOut, ADDR vAux

	INVOKE ExitProcess, 0
END main