#include "yakk.h"

//#define DEBUG

#define IDLE_STACK_SIZE 2048
uint16_t YKIdleCount = 0;
struct TCB TCBArray[NUMBER_OF_TCBs];
unsigned int nextTask;
unsigned int nextBP;
unsigned int nextSP;
int IdleStk[IDLE_STACK_SIZE];
int isRunning = 0;
unsigned int YKCtxSwCount;
unsigned char currentTaskPriority = 102;
unsigned int firstTime = 1;
unsigned int currentTCBIndex = 404;
unsigned ISRDepth = 0;
unsigned YKTickNum = 0;
unsigned returnToLocation;
unsigned ourTCB;
unsigned nextTCB;
extern void dispatchHelper();
extern void dispatchHelperFirst();
extern void initializeStack();
int okToSwitch = 0;


void YKInitialize(){
	int i = 0;
	YKExitMutex();
	for(i= 0; i < 15; i++){
		TCBArray[i].inUse = 0;
	}

	YKNewTask(YKIdleTask, (void *)&IdleStk[IDLE_STACK_SIZE] , 100);


}

void YKNewTask(void(*task)(void), void * taskStack, unsigned char priority){
	int i = 0;

	//Get the next avaliable TCB

	YKEnterMutex();
	for(i = 0; i < NUMBER_OF_TCBs; i++){
		if(!TCBArray[i].inUse){
			break;
		}
	}

	#ifdef DEBUG
	printString("Assigning task to TCB ");
	printInt(i);
	printString("\n");
	#endif

	TCBArray[i].taskID = i;
	TCBArray[i].taskPriority = priority;
	TCBArray[i].taskStack = taskStack;
	TCBArray[i].ip = (unsigned int)task;
	TCBArray[i].taskState = running;
	TCBArray[i].delayCount = 0;
	TCBArray[i].inUse = 1;
	TCBArray[i].sp = (unsigned)(taskStack);
	TCBArray[i].bp = (unsigned)(taskStack);


	ourTCB = (unsigned)&(TCBArray[i]);
	YKExitMutex();
	initializeStack();

	YKScheduler();
}

void YKRun(){
	isRunning = 1;
	YKScheduler();
}


void YKIdleTask(){
	int i;
	while(1){
	okToSwitch = 1;	
		//This loop should have four instruction

		for(i = 0; i < 1; i++){
			i++;
			i--;
		}
		YKIdleCount++;
	}
}

void YKScheduler(){
	//Loop through all the TCBs,
	int index = 0;
	int highestPriority = 101;
	int indexOfTaskToRun = 101;
	for(index = 0; index < NUMBER_OF_TCBs ; index++){
		if(!TCBArray[index].inUse){
			break;
		}
		if(TCBArray[index].delayCount != 0){
			continue;	
		}

		if(TCBArray[index].taskPriority <= highestPriority){
			highestPriority = TCBArray[index].taskPriority;
			indexOfTaskToRun = index;
		}
	}
	#ifdef DEBUG
	printString("task to run is ");
	printInt(indexOfTaskToRun);
	printString(" and Previouse task was ");
	printInt(currentTCBIndex);
	if(firstTime){
		printString(" and it's the first time");
	}
	if(!isRunning){
		printString(" but kernel is NOT running");
	}
	printString("\n");
	#endif

	ourTCB = (unsigned)&(TCBArray[currentTCBIndex]);
	nextTCB = (unsigned)&(TCBArray[indexOfTaskToRun]);

	
	if(!isRunning){
		currentTCBIndex = indexOfTaskToRun;
		return;
	}
	
	if(currentTCBIndex == indexOfTaskToRun && !firstTime){
		currentTCBIndex = indexOfTaskToRun;
		return;
	}
	
	//Set the priority of the running task (or about to be running)
	//currentTaskPriority = TCBArray[indexOfTaskToRun].taskPriority;
	if(isRunning && firstTime){
		firstTime = 0;
		YKCtxSwCount++;
		currentTCBIndex = indexOfTaskToRun;
		dispatchHelperFirst();
		return;
	}

	
	//If the kernel has been started
	if(isRunning){
		firstTime = 0;
		YKCtxSwCount++;
		currentTCBIndex = indexOfTaskToRun;		
		dispatchHelper();
		return;
	}
}

void YKDispatcher(){

}


void YKEnterMutex(void){
	YKEnterMutexHelper();
}

void YKExitMutex(void){
	YKExitMutexHelper();
}

void YKDelayTask(unsigned count){
	int i = 0;
	okToSwitch = 0;
	YKEnterMutex();
	TCBArray[currentTCBIndex].delayCount = count;

	YKScheduler();
	YKExitMutex();	

	okToSwitch = 1;
}

void YKEnterISR(){
	ISRDepth++;
}

void YKExitISR(){
	ISRDepth--;
	if(ISRDepth == 0){
		YKScheduler();
	}
}

void ignoring(){
	printString("Ignoring\n");
}

void YKTickHandler(){
	int index = 0;
	int count = 0; 


	YKTickNum++;
	for(index = 0; index < NUMBER_OF_TCBs; index++){
		if(!TCBArray[index].inUse){
			break;
		}
		if(TCBArray[index].delayCount > 0){
			TCBArray[index].delayCount--;


		}
	} 

	#ifdef DEBUG
	printString("Delaycounts are:");
	for(count = 0; count < 15; count++){
		printString(", ");
		printInt(TCBArray[count].delayCount);

	}
	printString("\n");
	#endif
}

