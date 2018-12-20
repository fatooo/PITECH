//#include <LiquidCrystal.h>

int Htime;              //integer for storing high time
int Ltime;              //integer for storing low time
float Ttime[10];        // integer for storing total time of a cycle
float Ttime_sum;
float Ttime_avg;

float frequency;        //storing frequency
float difference;
float standard_deviation;
float precision;     //***must be at same size with Ttime array***

int Counter;
bool signal_status;

void setup()
{
    pinMode(41,INPUT);  // digital signal input
    pinMode(23,OUTPUT); // 2kHz
    pinMode(25,OUTPUT); // 4kHz
    pinMode(27,OUTPUT); // 6kHz
    Serial.begin(115200);
    precision= 10;
    //lcd.begin(16, 2);
}
void loop()
{
    Ttime_sum = 0; 
            
    for (int i=1; i <= precision; i++){
      Htime=pulseIn(41,HIGH);      //read high time
      Ltime=pulseIn(41,LOW);        //read low time
    
      Ttime[i] = Htime+Ltime;
      Ttime_sum = Ttime_sum + Ttime[i];
      delay(1);
    }

    Ttime_avg = Ttime_sum / precision;
    difference = 0;
       
    for (int i=1; i <= precision; i++){
      difference = difference + (sq(Ttime[i] - Ttime_avg)/precision);
    }

    standard_deviation = sqrt(difference) ;
    
    
    if (standard_deviation < 10){
      standard_deviation = 10;
      signal_status = true;
    }
    else if(standard_deviation<60){
      signal_status = true;
    }
    else{
      signal_status = false;      
    }
     
    if(signal_status) {
    Ttime_sum = 0; 
    Counter = 0;
    
    for (int i=1; i <= precision; i++){
      if (abs(Ttime[i]-Ttime_avg) < standard_deviation){
         Ttime_sum = Ttime_sum + Ttime[i];
         Counter++;
    }}

   
    frequency=1000000/(Ttime_sum/Counter);    //getting frequency with Ttime is in Micro seconds

    if( frequency < 6600 && frequency > 5400) //kırmızı
    { digitalWrite(23,HIGH);}
    else{
      digitalWrite(23,LOW);}
    
    if( frequency < 4600 && frequency > 3600) //sarı
    { digitalWrite(25,HIGH);}
    else{
      digitalWrite(25,LOW);}

    if( frequency < 2700 && frequency > 1300) //yeşil
    { digitalWrite(27,HIGH);}
    else{
      digitalWrite(27,LOW);}
    
    Serial.println(frequency);
    delay(100);
    }
    else
    {
    delay(100);
    }
    
}
