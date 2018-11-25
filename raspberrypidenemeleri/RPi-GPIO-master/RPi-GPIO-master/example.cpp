#include "gpio.h"
#include <unistd.h>
int main()
{
	//create a GPIO object, which will control pin 4 (in output mode)
	gpio gpio21(21);
	while(true)
	{
		//Turn the pin on
		gpio21=1;
		//Wait for 1 second
		sleep(1);
		//Turn the pin off
		gpio21=0;
		//wait again
		sleep(1);
	}
}
