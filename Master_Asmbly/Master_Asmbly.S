#include   "avr/io.h"


main:

  
  ss_inactive            ;set latch bit hi (inactive)Slave select is set to pin 10
  sbi      ddrb,nss      ;make it an output

  sck_lo                  ;set clk line lo Clock is set to pin 13
  sbi      ddrb,sck      ;make it an output
  
  mosi_lo                  ;set data-out lo Master Out, Slave In is set to pin 11
  sbi      ddrb,mosi      ;make it an output

        mois_hi                ;set data-in hi Master In, Slave Out is set to pin 12
       sbi      ddrb,mosi      ;make it an input

  ldi r16,0x1D   set port bits to output mode Turn SSH on high for no communication
  out DDRB,r16;

       ldi r16, 0x51;/* Start Transmission */
       out SPCR, r16;SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPRO);

 ret

  clr r18;   OG buffer
  ldi r18, buffer;
  clr r19;   New buffer
  ldi r19,received;
  clr r20;   Count set to 0 for start of loop
  ldi, r20, i;

Loop:

  call delay; 

  ldi r16,0x1D  ; set port bits to output mode Turn SSH on high for communication
  out DDRB,r16

        my_string db "Sent: "
  push offset my_string
  call printf

        my_string db "Sent: "
  push offset my_string
  call printf

  call buffer, SPI_Master; Transmitted data

  call buffer, SPI_Master; Receive data

        my_string db "\t Received: ";
  push offset my_string;
  call printf;

        my_string db \n";
  push offset my_string;
  call printf;

        my_string db received;
  push offset my_string;
  call printf;

  ldi r16,0x1D   set port bits to input mode
  in DDRB,r16;


ADD i, 1; For loop inc by 1

my_loop: 
  cmp i, 225;
  mov i, 0;
  }
}

delay:

       ldi r16, x ; 1 cycle
loop:  nop        ; 1 cycle
       dec r16    ; 1 cycle
       brne loop1 ; 2 cycles when jumping, 1 otherwise
ret

SPI_Master:

  lds r8, data;SPDR = data;
  out SPDR, r8
  
  wait: in r16,SPSR;while(!(SPSR & (1<<SPIF)));
  bst r16,SPIF
  brtc wait
 ret 
