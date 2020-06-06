void setup() {
  Serial.begin (9600);
  pinMode(SS, OUTPUT); // Slave select is set to pin 10
  pinMode(SCK, OUTPUT); // Clock is set to pin 13
  pinMode(MOSI, OUTPUT); // Master Out, Slave In is set to pin 11
  pinMode(MISO, INPUT); // Master In, Slave Out is set to pin 12
  digitalWrite(SS,HIGH);//Turn SSH on high for no communication
  SPI_MasterInit();//Enable interrupts master
}
uint8_t buffer_;//OG buffer
uint8_t received_;//New buffer
uint8_t i = 0;//Count set to 0 for start of loop

void loop() {
  delay(1000); 
  digitalWrite(SS, LOW); //Turn SSH on high for communication
  Serial.print("Sent: ");
  Serial.print(i);
  buffer_ = SPI_Master(i); // Transmitted data
  received_ = SPI_Master(i);//Receive data
  Serial.print(" \t Received: ");
  Serial.print(received_);
  Serial.print("\n");
  digitalWrite(SS, HIGH); //Turn SSH on high for no communication
  /*need to put in some sort of check so that the variable stops at end of data frame*/
  i++;
  if(i == 256){
    i = 0;
  }
}
 /* Enable SPI, Master, set clock rate  */
void SPI_MasterInit(void){
  SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR0);
}
/*Could do the the transmit and the receive in one function:*/
uint8_t SPI_Master(uint8_t data){
  SPDR = data;//Start Transmission
  while(!(SPSR & (1<<SPIF)));//Wait for transmission & receiving complete
  return SPDR;//Return Data Register
}
