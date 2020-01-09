; SparcZ - A Funny little Network utility
; by ronybc ( url: http://www.ronybc.com )

.486p
.model flat,stdcall
option casemap:none

include \masm32\include\user32.inc

include \masm32\include\kernel32.inc

include \masm32\include\winmm.inc
includelib \masm32\lib\user32.lib

includelib \masm32\lib\kernel32.lib

includelib \masm32\lib\winmm.lib

.data

mci1      db "set cdaudio door open",0
mci2      db "set cdaudio door closed",0
mci3      db 0

.code

start:
    
 

cdopen:
    invoke mciSendString,ADDR mci1,ADDR mci3,0,0
    
   
    

cdclose:
    invoke mciSendString,ADDR mci2,ADDR mci3,0,0
    
      
jmp cdopen


invoke ExitProcess, 0


end start