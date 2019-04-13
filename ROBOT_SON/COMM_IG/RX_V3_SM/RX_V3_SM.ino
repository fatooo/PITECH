#include <SPI.h>
#include <Servo.h> //Servo kütüphanesini ekledik.
#include "nRF24L01.h"
#include "RF24.h"  

#define EN_left   2
#define EN_right  3
#define M_left    24
#define M_left_b  26
#define M_right   28
#define M_right_b 30
#define M_shoot   32
#define M_shoot_b 34

//Modül ile ilgili kütüphaneleri ekliyoruz
int   message[1];
RF24  receiver(9,53);  //CE,CSN
const uint64_t kanal = 0xE8E8F0F0E1LL;

  int no_signal = 0;

  int shoot   = 0; 
  int x_speed = 0;
  int y_speed = 0;
  int x_direction = 0;
  int y_direction = 0;

  int left_speed  = 0;
  int right_speed = 0;
  int pwm_left    = 0;
  int pwm_right   = 0;

                                     // Global parameters
  int calibration_left   = 0;        // sol teker için güç artış(+)/azalış(-) miktarı
  int calibration_right  = 0;        // sağ teker için güç artış(+)/azalış(-) miktarı
  int speed_offset       = 60;
  int speed_param        = 60;       // 3*param + offset 255'den büyük olamaz 
  int force_delay        = 30;       // Delay of force and shoot in force shoot
  


void setup(void){
 
  Serial.begin(9600);
 
  receiver.begin();
  receiver.openReadingPipe(1,kanal);
  receiver.startListening();

  pinMode(EN_left   , OUTPUT);
  pinMode(EN_right  , OUTPUT);
  pinMode(M_left    , OUTPUT);
  pinMode(M_left_b  , OUTPUT);
  pinMode(M_right   , OUTPUT);
  pinMode(M_right_b , OUTPUT);
  pinMode(M_shoot   , OUTPUT);
  pinMode(M_shoot_b , OUTPUT);

}

void loop(void){
 
 receive:                          //receive the input message
 
 if (receiver.available()){
    bool done = false;
    done = receiver.read(message,1);
    no_signal = 0;
 }
 else if(no_signal > 10){
    digitalWrite(EN_left   ,LOW);
    digitalWrite(EN_right  ,LOW);
    digitalWrite(M_left    ,LOW);
    digitalWrite(M_left_b  ,LOW);
    digitalWrite(M_right   ,LOW);
    digitalWrite(M_right_b ,LOW);
    digitalWrite(M_shoot   ,LOW);
    digitalWrite(M_shoot_b ,LOW);
    delay(10);
    goto receive;
 }
 else{
    no_signal = no_signal+1;
    delay(10);
    goto receive;
 }
 Serial.print(message[0],BIN);
 Serial.print('\n');
 
 ////////////////////////////////////////////////////////////
 ////// Decide operation mode  
 ////////////////////////////////////////////////////////////
  
 if (message[0 == 0]){                              //// Halt Operation   ////
    digitalWrite(EN_left   ,LOW);
    digitalWrite(EN_right  ,LOW);
    digitalWrite(M_left    ,LOW);
    digitalWrite(M_left_b  ,LOW);
    digitalWrite(M_right   ,LOW);
    digitalWrite(M_right_b ,LOW);
    digitalWrite(M_shoot   ,LOW);
    digitalWrite(M_shoot_b ,LOW);
    goto receive;
 }                                   
 else if(bitRead(message[0],7 == 1)){               //// Special moves    ////
    if(message[0] == 128){           // Special Halt
        digitalWrite(EN_left   ,LOW);
        digitalWrite(EN_right  ,LOW);
        digitalWrite(M_left    ,LOW);
        digitalWrite(M_left_b  ,LOW);
        digitalWrite(M_right   ,LOW);
        digitalWrite(M_right_b ,LOW);
        digitalWrite(M_shoot   ,LOW);
        digitalWrite(M_shoot_b ,LOW);
    }        
    else if(message[0] == 129){      // Force Shoot
        ////////////////////////////////////////////////
        //   Force Shoot 
        ////////////////////////////////////////////////
    
        digitalWrite(M_left    ,HIGH);
        digitalWrite(M_left_b  ,LOW);
        digitalWrite(M_right   ,HIGH);
        digitalWrite(M_right_b ,LOW);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);

        delay(force_delay);

        digitalWrite(M_shoot   ,HIGH);
        digitalWrite(M_shoot_b ,LOW);
        delay(10);
        
    }   
    else if(message[0] == 130){      // Move Right
        ////////////////////////////////////////////////
        //   Lateral Move Right (6 move, 30 ms per move)
        //   ↑↓ - ↑↑ - ↓↑ - ↓↑ - ↓↓ - ↑↓
        ////////////////////////////////////////////////
  
        // -1- //
        digitalWrite(M_left    ,HIGH);
        digitalWrite(M_left_b  ,LOW);
        digitalWrite(M_right   ,LOW);
        digitalWrite(M_right_b ,HIGH);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);
        delay(30);  
        // -2- //
        digitalWrite(M_left    ,HIGH);
        digitalWrite(M_left_b  ,LOW);
        digitalWrite(M_right   ,HIGH);
        digitalWrite(M_right_b ,LOW);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);
        delay(30);
        // -3- //
        digitalWrite(M_left    ,LOW);
        digitalWrite(M_left_b  ,HIGH);
        digitalWrite(M_right   ,HIGH);
        digitalWrite(M_right_b ,LOW);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);
        delay(30);
        // -4- //
        delay(30);
        // -5- //
        digitalWrite(M_left    ,LOW);
        digitalWrite(M_left_b  ,HIGH);
        digitalWrite(M_right   ,LOW);
        digitalWrite(M_right_b ,HIGH);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);
        delay(30);
        // -6- //
        digitalWrite(M_left    ,HIGH);
        digitalWrite(M_left_b  ,LOW);
        digitalWrite(M_right   ,LOW);
        digitalWrite(M_right_b ,HIGH);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);    
        delay(30);

    }   
    else if(message[0] == 131){     // Move Left
    ////////////////////////////////////////////////
    //   Lateral Move Left (6 move, 30 ms per move)
    //   ↓↑ - ↑↑ - ↑↓ - ↑↓ - ↓↓ - ↓↑
    ////////////////////////////////////////////////
      
        // -1- //
        digitalWrite(M_left    ,LOW);
        digitalWrite(M_left_b  ,HIGH);
        digitalWrite(M_right   ,HIGH);
        digitalWrite(M_right_b ,LOW);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);    
        delay(30);
        // -2- //
        digitalWrite(M_left    ,HIGH);
        digitalWrite(M_left_b  ,LOW);
        digitalWrite(M_right   ,HIGH);
        digitalWrite(M_right_b ,LOW);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);    
        delay(30);
        // -3- //
        digitalWrite(M_left    ,HIGH);
        digitalWrite(M_left_b  ,LOW);
        digitalWrite(M_right   ,LOW);
        digitalWrite(M_right_b ,HIGH);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);    
        delay(30);
        // -4- //
        delay(30);
        // -5- //
        digitalWrite(M_left    ,LOW);
        digitalWrite(M_left_b  ,HIGH);
        digitalWrite(M_right   ,LOW);
        digitalWrite(M_right_b ,HIGH);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);    
        delay(30);
        // -6- //
        digitalWrite(M_left    ,LOW);
        digitalWrite(M_left_b  ,HIGH);
        digitalWrite(M_right   ,HIGH);
        digitalWrite(M_right_b ,LOW);
        digitalWrite(EN_left   ,HIGH);
        digitalWrite(EN_right  ,HIGH);    
        delay(30);

    }   

 

 
 }
 else{                                              //// Normal Operation ////
                                    // Decode the message 
    shoot       = (message[0]&1);
    x_speed     = (message[0]&6) /2 ;
    y_speed     = (message[0]&48)/16;
    x_direction = ((message[0]&8) /4) - 1 ;
    y_direction = ((message[0]&64)/32)- 1 ;
 
    if (x_speed == 0) 
        x_direction = 0;
 
    if (y_speed == 0)
        y_direction = 0;
 
                                    // perform shooting  
    if (shoot == 1){
       digitalWrite(M_shoot, HIGH) ;
       digitalWrite(M_shoot_b, LOW);
    }
    else {
        digitalWrite(M_shoot, LOW)   ;
        digitalWrite(M_shoot_b, HIGH);
    }

                                    // eliminat 0/0 uncertainty
    if (x_speed == 0 && y_speed == 0)
        goto receive;
                                    
                                    // calculate pwm for wheels

    left_speed  = (speed_param * (y_direction*sq(y_speed)+x_direction*sq(x_speed))) / (x_speed + y_speed);
    right_speed = (speed_param * (y_direction*sq(y_speed)-x_direction*sq(x_speed))) / (x_speed + y_speed);
 
                                    // correct speeds in respect to correction factor and offset
    pwm_left  = abs(left_speed) + speed_offset + calibration_left ;
    pwm_right = abs(right_speed)+ speed_offset + calibration_right;

                                    // drive motors
                                    // Left Motor direction
    if (left_speed > 10){
        digitalWrite(M_left  , HIGH);
        digitalWrite(M_left_b, LOW) ;
    }
    else if (left_speed < -10){
        digitalWrite(M_left  , LOW) ;
        digitalWrite(M_left_b, HIGH);
    }
    else{
        digitalWrite(M_left  , LOW) ;
        digitalWrite(M_left_b, LOW) ;
    }
                                    // Right Motor direction
    if (right_speed > 10){
        digitalWrite(M_right  , HIGH);
        digitalWrite(M_right_b, LOW) ;
    }
    else if (right_speed < -10){
        digitalWrite(M_right  , LOW) ;
        digitalWrite(M_right_b, HIGH);
    }
    else{
        digitalWrite(M_right  , LOW) ;
        digitalWrite(M_right_b, LOW) ;
    }

                                    // Set PWM
    analogWrite(EN_left, pwm_left);
    analogWrite(EN_right, pwm_right);
 }                                   
 
 delay(10);
 
 }
