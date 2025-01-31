section .bss
    todoList resb 1024
    taskIndex resb 4
    buffer resb 100

section .data
    msg_prompt db "1. Add Task", 10, "2. View Tasks", 10, "3. Exit", 10, "> ", 0
    msg_add db "Enter task: ", 0
    msg_view db "Your To-Do List:", 10, 0
    newline db 10, 0
    msg_invalid db "Invalid option!", 10, 0
    

section .text
    global _start

_start:
    call menu

menu:
    ; Print menu options
    mov rsi, msg_prompt
    mov rdx, 25
    call print_string

    ; Get use input
    call read_input
    movzx rax, byte [buffer];

    cmp al, '1'
    je add_task
    cmp al, '2'
    je view_tasks
    cmp al, '3'
    je exit_program

    ; Invalid input
    mov rsi, msg_invalid
    mov rdx, 15
    call print_string
    jmp menu

add_task:
    ; Prompt for task
    mov rsi, msg_add
    mov rdx, 12
    call print_string

    ; Read task from user
    call read_input

    ; Store task in memory
    mov rdi, todoList
    mov rsi, buffer
    mov rcx, 100
    rep movsb

    ;Update task index
    inc byte [taskIndex]
    jmp menu

view_tasks:
    mov rsi, msg_view
    mov rdx, 17
    call print_string

    ; Print tasks
    mov rsi, todoList
    mov rdx, 100
    call print_string

    jmp menu

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall

print_string:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

read_input:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 100
    syscall
    ret

