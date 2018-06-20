// code for motor speed

#define stp 9  //connect pin 13 to step
#define dir 8  // connect pin 12 to dir
#define start_pin 4

long delay_motor = 50*32;
int start_state = 1;    //state of motor 1:ON  2:OFF 

void setup() 
{  
  Serial.begin(9600);              
  pinMode(stp, OUTPUT);
  pinMode(dir, OUTPUT); 
  pinMode(start_pin, INPUT);      
}


void loop() 
{
  start_state = digitalRead(start_pin);
  if (start_state==1)
  {
    digitalWrite(dir, HIGH);
    digitalWrite(stp, HIGH);   
    delayMicroseconds(delay_motor);               
    digitalWrite(stp, LOW);  
    delayMicroseconds(delay_motor);
  }
//can also add motor reversse functionality with other digital o/p pin
}
