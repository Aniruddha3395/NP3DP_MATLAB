//simple A4988 connection
//jumper reset and sleep together
//connect  VDD to Arduino 3.3v or 5v
//connect  GND to Arduino GND (GND near VDD)
//connect  1A and 1B to stepper coil 1
//connect 2A and 2B to stepper coil 2
//connect VMOT to power source (9v battery + term)
//connect GRD to power source (9v battery - term)


int stp = 9;  //connect pin 13 to step
int dir = 8;  // connect pin 12 to dir
int a = 0;     //  gen counter
long del0=5;
long del1=100;
int start_state = 0; 
int start_pin = 7;

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
  long sVal = analogRead(A0);
//  Serial.println(sVal);
  del0=1000+sVal*7;
  del1=1000+sVal*7;
 
  Serial.println(del0);
  if (a <  200)  //sweep 200 step in dir 1
   {
    digitalWrite(dir, HIGH);
//    a++;
    digitalWrite(stp, HIGH);   
//    delay(del0);
    delayMicroseconds(del0);               
    digitalWrite(stp, LOW);  
//    delay(del0);              
   delayMicroseconds(del0);
   }
//  else 
//   {
////    digitalWrite(dir, HIGH);
//    a++;
//    digitalWrite(stp, HIGH);  
//    delay(del1);               
//    digitalWrite(stp, LOW);  
//    delay(del1);
//    
//    if (a>400)    //sweep 200 in dir 2
//     {
//      a = 0;
////      digitalWrite(dir, LOW);
//     }
    }

  }
