//#include <LiquidCrystal.h>

//LiquidCrystal lcd(2, 3, 4, 5, 6, 7);

int Htime;              //integer for storing high time
int Ltime;                //integer for storing low time
float Ttime;            // integer for storing total time of a cycle
float Ttime1;
float Ttime2;
float Ttime3;
float frequency;        //storing frequency

void setup()
{
    pinMode(41,INPUT); //square wave input from Schmitt Trigger
    pinMode(23,OUTPUT); // 2kHz
    pinMode(25,OUTPUT); // 4kHz
    pinMode(27,OUTPUT); // 6kHz
    Serial.begin(9600);
    //lcd.begin(16, 2);
}
void loop()
{
//    lcd.clear();
//    lcd.setCursor(0,0);
//    lcd.print("Frequency of signal");

    Htime=pulseIn(41,HIGH);      //read high time
    Ltime=pulseIn(41,LOW);        //read low time
    
    Ttime1 = Htime+Ltime;

    Htime=pulseIn(41,HIGH);      //read high time
    Ltime=pulseIn(41,LOW);        //read low time
    
    Ttime2 = Htime+Ltime;

    Htime=pulseIn(41,HIGH);      //read high time
    Ltime=pulseIn(41,LOW);        //read low time
    
    Ttime3 = Htime+Ltime;

    Ttime = (Ttime1 + Ttime2 + Ttime3)/3;

    frequency=1000000/Ttime;    //getting frequency with Ttime is in Micro seconds
//    lcd.setCursor(0,1);
//    lcd.print(frequency);
//    lcd.print(" Hz");

    if( frequency < 6500 && frequency > 5500) //kırmızı
    { digitalWrite(23,HIGH);
    }
    else{
      digitalWrite(23,LOW);
    }
    
    if( frequency < 4500 && frequency > 3500) //sarı
    { digitalWrite(25,HIGH);
    }
    else{
      digitalWrite(25,LOW);
    }

    if( frequency < 2500 && frequency > 1500) //yeşil
    { digitalWrite(27,HIGH);
    }
    else{
      digitalWrite(27,LOW);
    }
    
    Serial.println(frequency);
    delay(100);
}
