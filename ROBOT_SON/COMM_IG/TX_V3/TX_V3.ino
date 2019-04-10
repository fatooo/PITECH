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

 int command =0;
 int x_direction = 0;
 int y_direction = 0;
 int x_move =0;
 int y_move =0;
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
     
     command = (int)(joystick_switch<100);
     x_direction = (joystick_x > 50);
     y_direction = joystick_y > 50;
     x_move = abs(joystick_x)/129;
     y_move  =abs(joystick_y)/129;
     
    command = command + ((int)x_direction)*8 + (int(y_direction))*64 + x_move*2 + y_move*16;

    Serial.print(command);
    Serial.print("\n");
     delay(10);
     
     
      verici.write(message, 1);   //mesaj değişkeni yollanıyor 
 }
