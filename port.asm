.386
.model flat, stdcall
option casemap: none


include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc 
include \masm32\include\shell32.inc
include \masm32\include\wsock32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\shell32.lib
includelib \masm32\lib\user32.lib 
includelib \masm32\lib\kernel32.lib 
includelib \masm32\lib\wsock32.lib
includelib \masm32\lib\masm32.lib




.data

txt db "An error occured while calling WSAStartup",0
txt1 db "An error occured while creating a socket",0
txt2 db "An error occured while connecting",0
txt3 db "An error occured while receiving",0
txt5 db "df",0


capt db "SCHiM",0
wsadata WSADATA <>
hostname db "10.195.1.145",0
Port dd 5556 
NICK db "NICK SCHiMBot",0
USER db "Arghya Kundu",0
CHANNEL db "/join #botts",0
sin sockaddr_in <?> 

.data?
sock dd ? 
;ErrorCode dd ?   
ErrorCode  dd ?
hMemory dd ?                ; handle to memory block 
buffer dd ?                       ; address of the memory block 
available_data dd ?        ; the amount of data available from the socket 
actual_data_read dd ?    ; the actual amount of data read from the socket 

.code
show_error proc caption:ptr byte, err_txt:ptr byte
    invoke WSAGetLastError
    mov ErrorCode, eax
    invoke MessageBoxA, MB_OK, caption, err_txt, 0
    ret
show_error endp

main proc
;invoke StdOut, addr txt1    ;Show Data

    invoke WSAStartup, 101h,addr wsadata

    .if eax==0   ; An error occured if eax != 0, because there's no return value for this api, if there's return, there's an error
        invoke socket,AF_INET,SOCK_STREAM,0     ; Create a stream socket for internet use
        .if eax!=INVALID_SOCKET
            mov sock,eax

            ;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
            ;Now we have a socket ready for use, we still have to be able to connect to somewere though...
            ;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

            mov sin.sin_family, AF_INET
            invoke htons, Port  ; convert port number into network byte order first
            mov sin.sin_port,ax ; note that this member is a word-size param.
            invoke gethostbyname, addr hostname

            mov eax,[eax+12]    ; move the value of h_list member into eax
            mov eax,[eax]       ; copy the pointer to the actual IP address into eax
            mov eax,[eax]       ; copy IP address into eax
            mov sin.sin_addr,eax

            ;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
            ;Now That's done we can connect to a site! (an irc channel in this case)
            ;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

            invoke connect, sock, addr sin, sizeof sin
            .if eax!=SOCKET_ERROR
                invoke send, sock, addr USER, 100, 0
            .else
                invoke show_error, offset capt, offset txt2
            .endif
invoke StdOut, addr txt1    ;Show Data

            invoke ioctlsocket, sock, FIONREAD, addr available_data 
                .if eax==NULL 
                     ;invoke GlobalAlloc, GHND, available_data 
                        ; mov hMemory,eax 
                         invoke GlobalLock, eax 
                            mov buffer,eax 
                             invoke recv, sock, buffer, 2000,0 ;available_data, 0 
                              ;   mov actual_data_read, eax 
                                    ;invoke StdOut, addr actual_data_read    ;Show Data
                                   invoke MessageBoxA, MB_OK, addr buffer,offset buffer,0
                                       ;  invoke GlobalUnlock, buffer 
                                          ;   invoke GlobalFree, hMemory 
               .else
                    invoke show_error, offset capt, offset txt3

            .endif

        .else
            invoke show_error, offset capt, offset txt1
        .endif
    .else
        invoke show_error, offset capt, offset txt
    .endif
    ;invoke StdOut, addr txt1    ;Show Data

    invoke ExitProcess, 0
main endp
end main