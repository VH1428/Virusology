%include "io.inc"

section .data
MAX_STACK_SIZE equ 10   ; размер стека
CANARY equ -1           ; значение "осведомителя"

section .text

global CMAIN
CMAIN:
; назначение использованных регистров
; eax - регистр для ввода/вывода данных в/из стека
; ebx - начало участка хранения введенных символов
; ecx - счетчик считанных символов
; edx - вершина реализованного стека
; esp - вершина доступного в начале программы стека/база реализованного стека

    mov edx,esp   
    
    ;осведомитель за теоретической максимальной вершиной
    mov dword [esp+4*(MAX_STACK_SIZE+2)],CANARY

    mov ecx,0; очистка счетчика и регистра данных
    mov eax,0

    GET_STRING [ebx],20;

    push_loop:      ; цикл добавления данных в стек
    mov al,[ebx+ecx]; EAX=*+AX=*+AH+AL
    call _push;
    
    ; проверка осведомителя
    cmp dword [esp+4*(MAX_STACK_SIZE+2)],CANARY;
    je continue
    PRINT_STRING "Stack is overflowed!" ; осведомитель поврежден
    mov edx, esp                          ; "очистка" стека - смещение указателя вершины к базе 
    jmp exit                              ;
    continue:
    
    inc ecx;
    cmp eax,0;
    jne push_loop;
    
                    
  
    pop_loop:       ; цикл извлечения данных из стека
    call _pop;
    PRINT_CHAR eax
    dec ecx;
    cmp ecx,0
    jne pop_loop
    
    exit: 
    
ret
    
    _push:                       ; поместить данные eax в стек 
            add edx, 4           ; изменить указатель на вершину стека (увеличить на 4 байта)
            mov dword [edx], eax ; поместить данные на вершину стека
    ret

    _pop:                        ; извлечь данные из стека в eax
            
            mov eax, edx;        ; проверка на возможность
            sub eax,4            ; извлечения данных         
            cmp esp,eax          ;
            je cant_pop          ;
                                   
            mov eax, dword [edx] ; поместить данные из вершины стека в eax
            sub edx, 4           ; изменить указатель на вершину стека (уменьшить на 4 байта)
            cant_pop:
     ret
