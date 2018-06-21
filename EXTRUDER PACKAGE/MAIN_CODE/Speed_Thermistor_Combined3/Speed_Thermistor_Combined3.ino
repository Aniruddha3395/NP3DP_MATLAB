//code for getting the resistance of thermistor

#define analog_pin A1     //analog pin for getting intermediate voltage
#define LED 7       //indicator for heating block attaining desired temp.
#define stp 9  //connect pin 13 to step
#define dir 8  // connect pin 12 to dir
#define start_pin 4
#define fan_pin 6
#define transistor_pin 10
#define transistor_pin2 5
#define input_size 5    //number of samples

float R1=100000.0;     //other resistance in series
int analog_val[input_size];
int i = 0;
float analog_val_new;
int t = 20;      //gap between the readings for averaging (in ms) 
float R;    //resistance of thermistor 
float T;    //temp of heating block
long delay_motor = 50*32;
int start_state = 1;    //state of motor 0:OFF  1:ON   
int fan_state = 0;    //state of fan 0:OFF  1:ON  
unsigned long previousMillis = 0;
float B = 3950;     //B value
float T0 = 298.15;    //room temp

void setup() 
{
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
  pinMode(stp, OUTPUT);
  pinMode(dir, OUTPUT); 
  pinMode(start_pin, INPUT);     // connected to ABB
  pinMode(fan_pin, INPUT);     //connected to ABB

}

void loop() 
{
fan_state = digitalRead(fan_pin);   //fan start/stop
  
if (fan_state==1)
{
  analogWrite(transistor_pin2, 255);
}
else
{
  analogWrite(transistor_pin2, 0);
}


start_state = digitalRead(start_pin);
  if (start_state==1)
  {
    digitalWrite(dir, HIGH);
    digitalWrite(stp, HIGH);   
    delayMicroseconds(delay_motor);               
    digitalWrite(stp, LOW);  
    delayMicroseconds(delay_motor);
  }

unsigned long currentMillis = millis();


if (currentMillis - previousMillis >= t)
{
    previousMillis = currentMillis;
i = i+1;
analog_val[i-1] =  analogRead(analog_pin);  
analog_val_new = 0.0;

if (i==5)
{
for (i=0; i<input_size;i++) 
  {
     analog_val_new += analog_val[i];
  }
analog_val_new /= input_size;         //averaging values for better results

//calculating resistance
  float R = R1/((1023/analog_val_new)-1);
  Serial.print("Thermistor resistance: ");
  Serial.print(R);
  Serial.print("\t");
    
// Calculating temperature value
  T = (1/((1/T0)+(log(R/R1)/B)))-273; 
  Serial.print("Temp: ");
  Serial.println(T);
  Serial.print("\t");

  if (T<229.9) 
  {
    analogWrite(transistor_pin, 255);
  }
  else if (T>230.1) 
  {
    analogWrite(transistor_pin, 0);  
    digitalWrite(LED, HIGH);
  }
  
if (T<200)
{
  digitalWrite(LED, LOW);
  
}
  Serial.print("\n");
i = 0;
}
} 
}
