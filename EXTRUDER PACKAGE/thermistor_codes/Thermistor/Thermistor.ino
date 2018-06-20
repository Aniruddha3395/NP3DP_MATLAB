//code for getting the resistance of thermistor

#define R1 100000   //other resistance in series
#define analog_pin A0     //analog pin for getting intermediate voltage
#define T0 298.15
#define B 3950
#define input_size 5

int analog_val[input_size];
int i;
float analog_val_new;
int t = 20;      //gap between the readings for averaging (in ms) 
float R;
float T;
 
void setup() {

  Serial.begin(9600);
//  analogReference(EXTERNAL);

}

void loop() {

//averaging values for better results
  for (i =0;i<input_size;i++) {
  analog_val[i] =  analogRead(analog_pin);  
  delay(t);
  }
analog_val_new = 0.0;
  for (i=0; i<input_size;i++) {
     analog_val_new += analog_val[i];
  }
  analog_val_new /= input_size;
  
//calculating resistance
R = R1/((1023/analog_val_new)-1);
Serial.print("Thermistor resistance: ");
Serial.print(R);
Serial.print("\t");
    
// Calculating temperature value
T = (1/((1/T0)+(log(R/R1)/B)))-273; 
Serial.print("Temp: ");
Serial.println(T);
Serial.print("\n");

delay(500);
 
}
