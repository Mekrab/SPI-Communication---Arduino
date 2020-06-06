void setup() {
  Serial.begin(9600);

  pinMode(MISO, OUTPUT); // Master In, Slave Out is set to pin 12
  SPI_SlaveInit();//Enable interrupts slave
}

void loop() {
/*Leaving blank as the no real work was needed in the loop*/
}
/*Interrupt to receive and send at the same time sending our prior SPDR modification*/
ISR (SPI_STC_vect){ 
  uint8_t received = SPI_SlaveReceive();//Receive data
  Serial.print("Received: ");
  Serial.print(received);
  SlaveTransmit(received); // Transmitted data
}
/* Enable SPI,Slave and interrupts*/
void SPI_SlaveInit(void){ 
  SPCR=(1<<SPE)|(1<<SPIE);                                      
}

void SlaveTransmit(uint8_t data){
  /* Start Transmission*/
  SPDR = data;
  /*wait for transmission complete*/
  while(!(SPSR & (1<<SPIF)));
  Serial.print("\tSent: ");
  Serial.print(data);
  Serial.print("\n");
}
/*Wait for reception complete*/
uint8_t SPI_SlaveReceive(){ 
  while(!(SPSR & (1<<SPIF)));//
  return SPDR;
}
