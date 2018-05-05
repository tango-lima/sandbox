BITS 16
  
  ; Zero segment registers
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax 
  mov ss, ax
  
  ; Initialize stack pointer
  mov sp, 0x7c00
  
  ; Print boot message
  mov si, booting_stage_1
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
  booting_stage_1:
    db "Booting stage 1 ...", 0xD, 0xA, 0x0
  
  ; Padding
  times 510-($-$$) db 0x0
  
  ; Magic number
  dw 0xAA55
  
