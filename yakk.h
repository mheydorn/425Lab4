#include "clib.h"
#include <stdint.h>

#define NUMBER_OF_TCBs 15

extern uint16_t YKIdleCount;

extern unsigned int nextBP;

extern unsigned int nextSP;

extern unsigned int nextTask;

extern unsigned int YKCtxSwCount;

extern unsigned ISRDepth;

extern unsigned YKTickNum;

extern unsigned returnToLocation;
extern int okToSwitch;

typedef enum tasks{running,delayed,suspended} taskStates;

typedef struct TCB{
	unsigned int ip; //Program counter for the next task to run 

	unsigned int sp;//2
	unsigned int bp;//4

	unsigned ax;//6
	unsigned bx;//8
	unsigned cx;//10
	unsigned dx;//12
	unsigned si;//14
	unsigned di;//16
	unsigned es;//18
	unsigned ds;//20

	void * taskStack;
	unsigned taskID;
	unsigned int taskPriority; //Higher number is higher priority
	taskStates taskState;
	unsigned int delayCount;//30
	struct TCB * nextTCB;//32
	unsigned inUse; //Indicates whether this TCB is in use //34

}TCB;


extern unsigned ourTCB;
extern unsigned nextTCB;

extern struct TCB TCBArray[NUMBER_OF_TCBs];

void YKScheduler();

void YKDispatcher();

void dispatchHelper();

void YKEnterMutexHelper();

void YKExitMutexHelper();

void YKIdleTask();

void YKInitialize();

void YKNewTask();

void YKEnterMutex();

void YKExitMutex();

void YKRun();

void YKDelayTask(unsigned count);

void YKEnterISR();

void YKExitISR();

void YKTickHandler();
