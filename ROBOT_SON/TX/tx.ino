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

 int command = 0;
 int x_direction = 0;
 int y_direction = 0;
 int x_move = 0;
 int y_move = 0;
 bool shoot = false;
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

     shoot = (joystick_switch<60);
     x_direction = (joystick_x > 50);
     y_direction = joystick_y > 50;
     x_move = (abs(joystick_x)+130)/210;
     y_move = (abs(joystick_y)+130)/210;
     
     command = ((int)shoot) + ((int)x_direction)*8 + (int(y_direction))*64 + x_move*2 + y_move*16;
     message[0] = command;
     
//       if(joystick_y>450){
//        
//            message[0]=2;
//           // Serial.println(joystick_x);      
//          }
//       else if (joystick_y<-450){      
//            message[0]=1;     
//             // Serial.println(joystick_x);
//              }
//       else if (joystick_x>450){
//                message[0] = 8;
//               //Serial.println(joystick_y);      
//              }
//        else if (joystick_x<-450){
//                message[0]=4;
//                //Serial.println(joystick_y);
//               }
//        else if  (joystick_switch<50) {
//               message[0]=16;
//                }
//
//        else if (joystick_y<450 && joystick_y>100) {
//                message[0]=32; 
//          
//          }
//          else if (joystick_y<-100 && joystick_y>-450) {
//                message[0]=64; 
//          
//          }
//
//           else if (joystick_x>100 && joystick_x<450){
//                message[0] = 9;
//                    
//              }
//        else if (joystick_x<-100 && joystick_x>-450){
//                message[0]=5;
//                //Serial.println(joystick_y);
//               }        


//                
//        else  {
//               message[0]=B00000000;
//              } 
//               delay(100);
              
 verici.write(message, 1);   //mesaj değişkeni yollanıyor 
 Serial.println(message[0],BIN);
 }
