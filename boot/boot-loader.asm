BITS 16

ORG 0x0000

  ; Initialize segment registers
  mov ax, cs
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  
  ; Initialize stack pointer
  mov sp, 0xF000
  
  ; Print boot message
  mov si, booting_stage_two
  call print_str
  
  ; Save boot drive
  mov [boot_drive], dl
  
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
    
  ; Variables
  boot_drive:
    db 0x0
  
  ; Padding
  times 65536-8192-($-$$) db 0x0
  
  ; Stack
  stack_low:
    times 4096 db 0x0
  stack_top:
  
  ; Padding
  times 4096-16 db 0x0
  
  ; Configuration
  kernel_lba_start:
    dq 0x1000
  kernel_lba_length:
    dq 0x1000
