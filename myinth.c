#include "clib.h"
#include "yakk.h"
extern int KeyBuffer;

static int n = 1;
static int i = 0;

void resetISRC()
{
	printString("RESET");
	exit(0);
}

void tickISRC()
{



	//if(n >= 2){
		printString("\nTICK");
		printInt(n);
		printString("\n");
	//}
	n++;


}

void keyboardISRC()
{
	if(KeyBuffer == 'd')
	{
		
		printString("\nDELAY KEY PRESSED\n");
		for(i = 0; i < 5000; i++)
		{
			//Just a busy loop
		}

		printString("\nDELAY COMPLETE\n");
	}
	else
	{
		printString("\nKEYPRESS (");
		printChar((char)KeyBuffer);
		printString(") IGNORED\n");
	}
}




