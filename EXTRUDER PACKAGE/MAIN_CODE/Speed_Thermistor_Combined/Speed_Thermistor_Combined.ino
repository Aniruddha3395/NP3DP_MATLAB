//code for getting the resistance of thermistor

#define analog_pin A1     //analog pin for getting intermediate voltage
#define LED 7       //indicator for heating block attaining desired temp.
#define stp 9  //connect pin 13 to step
#define dir 8  // connect pin 12 to dir
#define start_pin 4

#define T0 298.15       // room temp
#define B 3950          // B value
#define input_size 5    //number of samples

float R1=10000.0;     //other resistance in series
int analog_val[input_size];
int i = 0;
float analog_val_new;
int t = 20;      //gap between the readings for averaging (in ms) 
float R;    //resistance of thermistor 
float T;    //temp of heating block
long delay_motor = 50*32;
int start_state = 1;    //state of motor 1:ON  2:OFF 
unsigned long previousMillis = 0;

 
void setup() 
//integrate fan code
{
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
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

unsigned long currentMillis = millis();

//averaging values for better results
//  for (i =0;i<input_size;i++) 
//  {
//    analog_val[i] =  analogRead(analog_pin);  
//    delay(t);
//  }

if (currentMillis - previousMillis >= t)
{
    previousMillis = currentMillis;
i = i+1;
analog_val[i-1] =  analogRead(analog_pin);  
analog_val_new = 0.0;

if (i==5)
{
for (i=1; i<input_size;i++) 
  {
     analog_val_new += analog_val[i];
  }
analog_val_new /= input_size;
  
//calculating resistance
  float my_val=analog_val[1];
  Serial.print(my_val);
  Serial.print("\t");
  float divide=1023/my_val;
  Serial.print(divide);
  Serial.print("\t");
  R = R1/((divide-1));
  Serial.print("Thermistor resistance: ");
  Serial.print(R);
  Serial.print("\t");
  Serial.print("ADC ");
  Serial.print(analog_val_new);
  Serial.print("\t");
  Serial.print(analog_val[1]);
   Serial.print("\t");

  
  Serial.print("\t");
    
// Calculating temperature value
  T = (1/((1/T0)+(log(R/R1)/B)))-273; 
  Serial.print("Temp: ");
  Serial.println(T);
  Serial.print("\t");

  if (T<229.9) 
  {
    analogWrite(10, 255);
  }
  else if (T>230.1) 
  {
    analogWrite(10, 0);  
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
