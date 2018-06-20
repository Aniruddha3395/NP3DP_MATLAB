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
int del0=5;
int del1=100;

void setup() 
{  
  Serial.begin(9600);              
  pinMode(stp, OUTPUT);
  pinMode(dir, OUTPUT);       
}


void loop() 
{
  int sVal = analogRead(A0);
  Serial.println(sVal);
  del0=sVal/2;
  del1=sVal/4;

  
  if (a <  200)  //sweep 200 step in dir 1
   {
    digitalWrite(dir, LOW);
    a++;
    digitalWrite(stp, HIGH);   
    delay(del0);               
    digitalWrite(stp, LOW);  
    delay(del0);              
   }
  else 
   {
//    digitalWrite(dir, HIGH);
    a++;
    digitalWrite(stp, HIGH);  
    delay(del1);               
    digitalWrite(stp, LOW);  
    delay(del1);
    
    if (a>400)    //sweep 200 in dir 2
     {
      a = 0;
//      digitalWrite(dir, LOW);
     }
    }
}
