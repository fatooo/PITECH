#include <SPI.h>
#include <Servo.h> //Servo kütüphanesini ekledik.
#include "nRF24L01.h"
#include "RF24.h"  


#define enA 2
#define enB 3
#define in1 24
#define in2 26
#define in3 28
#define in4 30
#define in5 32
#define in6 34



//Modül ile ilgili kütüphaneleri ekliyoruz
int mesaj[1];
RF24 alici(9,53); //CE,CSN
const uint64_t kanal = 0xE8E8F0F0E1LL;
bool sag = false;
bool sol = false;
bool ileri = false;
bool geri = false;
bool shoot = false;
String karar ;
int i;



void setup(void){
 Serial.begin(9600);
 
 alici.begin();
 alici.openReadingPipe(1,kanal);
 alici.startListening();


  pinMode(enB, OUTPUT);
  pinMode(enA, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
  pinMode(in5, OUTPUT);
  pinMode(in6, OUTPUT);


 }

void loop(void){
 if (alici.available())
 {
   bool done = false;    
   
     done = alici.read(mesaj, 1);  

       if (mesaj[0]==5){
         karar = "yavaş geri";
             analogWrite(enA, i);
             analogWrite(enB, i);
             digitalWrite(in1, HIGH);
             digitalWrite(in2, LOW);
             digitalWrite(in3, HIGH);
             digitalWrite(in4, LOW);
             digitalWrite(in5, LOW);
             digitalWrite(in6, LOW);


                 
        }

     if(mesaj[0]==9){
          
         karar =  "yavaş ileri";
 
             analogWrite(enA, i);
             analogWrite(enB, i);
             digitalWrite(in1, LOW);
             digitalWrite(in2, HIGH);
             digitalWrite(in3, LOW);
             digitalWrite(in4, HIGH);
             digitalWrite(in5, LOW);
             digitalWrite(in6, LOW);
            
              
                    
        }

        if(mesaj[0]==64){
          
          karar = "yavaş sol";
           analogWrite(enA, i);
           analogWrite(enB, i);  
           digitalWrite(in1, HIGH);
           digitalWrite(in2, LOW);
           digitalWrite(in3, LOW);
           digitalWrite(in4, HIGH);
           digitalWrite(in5, LOW);
           digitalWrite(in6, LOW);

    
          
        }

        
        if(mesaj[0]==32){
          
          karar = "yavaş sağ";
             analogWrite(enA, i);
             analogWrite(enB, i);
             digitalWrite(in1, LOW);
             digitalWrite(in2, HIGH);
             digitalWrite(in3, HIGH);
             digitalWrite(in4, LOW);
             digitalWrite(in5, LOW);
             digitalWrite(in6, LOW);


                                    
        }

        if(mesaj[0]==16){
          
          karar = "shoot";
             digitalWrite(enA, HIGH);
             digitalWrite(enB, HIGH);
           digitalWrite(in1, LOW);
           digitalWrite(in2, LOW);
           digitalWrite(in3, LOW);
           digitalWrite(in4, LOW);
           digitalWrite(in5, HIGH);
           digitalWrite(in6, LOW);

        
          
        }
        if(mesaj[0]==8){
          
         karar =  "ileri";
             digitalWrite(enA, HIGH);
             digitalWrite(enB, HIGH);
             digitalWrite(in1, LOW);
             digitalWrite(in2, HIGH);
             digitalWrite(in3, LOW);
             digitalWrite(in4, HIGH);
             digitalWrite(in5, LOW);
             digitalWrite(in6, LOW);
             

              
                    
        }
        if (mesaj[0]==4){
         karar = "geri";
             digitalWrite(enA, HIGH);
             digitalWrite(enB, HIGH);
             digitalWrite(in1, HIGH);
             digitalWrite(in2, LOW);
             digitalWrite(in3, HIGH);
             digitalWrite(in4, LOW);
             digitalWrite(in5, LOW);
             digitalWrite(in6, LOW);

         
              

         
        }
        if(mesaj[0]==2){
          karar="sag";
            
            digitalWrite(enA, HIGH);
            digitalWrite(enB, HIGH);

             digitalWrite(in1, LOW);
             digitalWrite(in2, HIGH);
             digitalWrite(in3, HIGH);
             digitalWrite(in4, LOW);
             digitalWrite(in5, LOW);
             digitalWrite(in6, LOW);
        }
        if(mesaj[0]==1){
          karar="sol";
             digitalWrite(enA, HIGH);
             digitalWrite(enB, HIGH);
             digitalWrite(in1, HIGH);
             digitalWrite(in2, LOW);
             digitalWrite(in3, LOW);
             digitalWrite(in4, HIGH);
             digitalWrite(in5, LOW);
             digitalWrite(in6, LOW);
        }
        if(mesaj[0]==0){
          i=150;
          karar= "dur";
            digitalWrite(enA, HIGH);
            digitalWrite(enB, HIGH);

            digitalWrite(in1, LOW);
            digitalWrite(in2, LOW);
            digitalWrite(in3, LOW);
            digitalWrite(in4, LOW);
            digitalWrite(in5, LOW);
            digitalWrite(in6, LOW);
          
        }
       
      
     Serial.println(karar);
   
     delay(10);
   
 }
 }
