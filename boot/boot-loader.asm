BITS 16

ORG 0x0000

  ; Initialize segment registers
  mov ax, 0x1000
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  
  mov ax, 0x2000
  mov ss, ax
  
  ; Initialize stack pointer
  mov sp, 0x0000
  
  ; Print boot message
  mov si, booting_stage_two
  call print_str
  
  ; Loop forever
  spin:
    jmp spin
  
  ; Print string
  print_str:
    cld
  print_str_loop:
    lodsb
    or al, al
    jz print_str_done
    call print_char
    jmp print_str_loop
  print_str_done:
    ret
  
  ; Print character
  print_char:
    mov ah, 0x0E
    int 0x10
    ret
    
  ; Strings
  booting_stage_two:
    db "Booting stage two...", 0xD, 0xA, 0x0
  
