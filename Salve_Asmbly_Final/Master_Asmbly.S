#include   "avr/io.h"


main:


     mosi_lo                  ;set data-out lo Master In, Slave Out is set to pin 12
     sbi      ddrb,mosi      ;make it an output

     call SPI_SlaveInit; 


loop:

/*NO LOOP*/

ISR:

  clr r19; set INT
  ldi r19,received;

  call received, SPI_SlaveReceive;Receive data

        my_string db "Received: ";
  push offset my_string
  call printf
        my_string db received;
  push offset my_string
  call printf

  call SlaveTransmit; Transmitted data

SPI_SlaveInit: 

  ldi r16, 0x50
  out SPCR, r16

SPI_SlaveReceive:

wait: in r16,SPSR
 bst r16,SPIF
 brtc wait
 ret 

SlaveTransmit:

  clr r20;
  ldi, r20, data;

wait: in r16,SPSR
 bst r16,SPIF
 brtc wait
 ret 
        my_string db "\tSent: ";
  push offset my_string
  call printf
        my_string db data;
  push offset my_string
  call printf
        my_string db "\n";
  push offset my_string
  call printf
