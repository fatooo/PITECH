#include  <SPI.h> 
#include "nRF24L01.h"
#include "RF24.h"     //Modül ile ilgili kütüphaneleri ekliyoruz
RF24 verici(9,10);     //kütüphane tarafından kullanılacak pinleri tanımlıyoruz (CE,CSN)
const uint64_t kanal = 0xE8E8F0F0E1LL; //kanalı tanımlıyoruz  
int joystick_x_pin = A0;
 int joystick_y_pin = A1;
 int joystick_switch_pin = A2;
 int joystick_x=0;
 int joystick_y=0;
 int joystick_switch = 0;
 int message[1] ; 
void setup(void)
{
 verici.begin();       //nrf yi başlatıyoruz
 verici.openWritingPipe(kanal);  //kanal id sı tanımlanıyor
 Serial.begin(9600);
}
void loop(void)
{  
     //Reading commands from joystick
     joystick_x = analogRead(joystick_x_pin)-512;
     joystick_y = analogRead(joystick_y_pin)-512;
     joystick_switch = analogRead(joystick_switch_pin);
       if(joystick_y>400){
        
            message[0]=B00000010;
           // Serial.println(joystick_x);      
          }
        else if (joystick_y<-400){      
            message[0]=B00000001;     
             // Serial.println(joystick_x);
              }
       else if (joystick_x>400){
                message[0] = B00001000;
               //Serial.println(joystick_y);      
              }
        else if (joystick_x<-400){
                message[0]=B00000100;
                //Serial.println(joystick_y);
               }
        else if  (joystick_switch==0) {
               message[0]=B00010000;
                }
        else  {
               message[0]=B00000000;
              }  
 verici.write(message, 1);   //mesaj değişkeni yollanıyor 
 Serial.println(message[0]);
 }
