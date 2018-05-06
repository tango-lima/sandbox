BITS 16

ORG 0x7C00
  
  ; Initialize segment registers
  mov ax, 0x0000
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax 
  mov ss, ax
  
  ; Initialize stack pointer
  mov sp, 0x7C00
  
  ; Print boot message
  mov si, booting_stage_one_str
  call print_str

  ; Check if BIOS LBA extension is present
  mov bx, 0x55AA
  mov ah, 0x41
  ; Register dl contains boot drive number
  int 0x13
  jc no_int13h_extensions
  
  ; Load second stage from disk
  mov si, dap
  mov ah, 0x42
  ; Register dl contains boot drive number
  int 0x13
  jc second_stage_load_failed

  ; Jump to second stage
  jmp 0x1000:0x0000

  ; Loop forever
  spin:
    jmp spin
  
  ; Print string
  print_str:
    push al
    cld
  print_str_loop:
    lodsb
    or al, al
    jz print_str_done
    call print_char
    jmp print_str_loop
  print_str_done:
    pop al
    ret
  
  ; Print character
  print_char:
    push ah
    mov ah, 0x0E
    int 0x10
    pop ah
    ret
    
  no_int13h_extensions:
    mov si, no_int13h_extensions_str
    call print_str
    jmp spin

  second_stage_load_failed:
    mov si, second_stage_load_failed_str
    call print_str
    jmp spin
  
  ; Strings
  booting_stage_one_str:
    db "Booting stage one...", 0xD, 0xA, 0x0
  no_int13h_extensions_str:
    db "Error: No support for int13h extensions!", 0xD, 0xA, 0x0
  second_stage_load_failed_str:
    db "Error: Failed to load second stage!", 0xD, 0xA, 0x0

  ; Disk access packet
  dap:
    dw 0x0010
  dap_read_blocks:
    dw 0x0080
  dap_buffer_ptr:
    dw 0x0000
  dap_buffer_seg:
    dw 0x1000
  dap_start_lba:
    dq 0x00000800
  
  ; Padding
  times 510-($-$$) db 0x0
  
  ; Magic number
  dw 0xAA55
  
