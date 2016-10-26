# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakc.c"
# 1 "yakk.h" 1
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 2 "yakk.h" 2
# 1 "/usr/lib/gcc/x86_64-redhat-linux/4.8.5/include/stdint.h" 1 3 4
# 9 "/usr/lib/gcc/x86_64-redhat-linux/4.8.5/include/stdint.h" 3 4
# 1 "/usr/include/stdint.h" 1 3 4
# 25 "/usr/include/stdint.h" 3 4
# 1 "/usr/include/features.h" 1 3 4
# 375 "/usr/include/features.h" 3 4
# 1 "/usr/include/sys/cdefs.h" 1 3 4
# 392 "/usr/include/sys/cdefs.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 393 "/usr/include/sys/cdefs.h" 2 3 4
# 376 "/usr/include/features.h" 2 3 4
# 399 "/usr/include/features.h" 3 4
# 1 "/usr/include/gnu/stubs.h" 1 3 4
# 10 "/usr/include/gnu/stubs.h" 3 4
# 1 "/usr/include/gnu/stubs-64.h" 1 3 4
# 11 "/usr/include/gnu/stubs.h" 2 3 4
# 400 "/usr/include/features.h" 2 3 4
# 26 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/bits/wchar.h" 1 3 4
# 22 "/usr/include/bits/wchar.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 23 "/usr/include/bits/wchar.h" 2 3 4
# 27 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 28 "/usr/include/stdint.h" 2 3 4
# 36 "/usr/include/stdint.h" 3 4
typedef signed char int8_t;
typedef short int int16_t;
typedef int int32_t;

typedef long int int64_t;







typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;

typedef unsigned int uint32_t;



typedef unsigned long int uint64_t;
# 65 "/usr/include/stdint.h" 3 4
typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef int int_least32_t;

typedef long int int_least64_t;






typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned int uint_least32_t;

typedef unsigned long int uint_least64_t;
# 90 "/usr/include/stdint.h" 3 4
typedef signed char int_fast8_t;

typedef long int int_fast16_t;
typedef long int int_fast32_t;
typedef long int int_fast64_t;
# 103 "/usr/include/stdint.h" 3 4
typedef unsigned char uint_fast8_t;

typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long int uint_fast64_t;
# 119 "/usr/include/stdint.h" 3 4
typedef long int intptr_t;


typedef unsigned long int uintptr_t;
# 134 "/usr/include/stdint.h" 3 4
typedef long int intmax_t;
typedef unsigned long int uintmax_t;
# 10 "/usr/lib/gcc/x86_64-redhat-linux/4.8.5/include/stdint.h" 2 3 4
# 3 "yakk.h" 2



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
 unsigned int ip;

 unsigned int sp;
 unsigned int bp;

 unsigned ax;
 unsigned bx;
 unsigned cx;
 unsigned dx;
 unsigned si;
 unsigned di;
 unsigned es;
 unsigned ds;

 void * taskStack;
 unsigned taskID;
 unsigned int taskPriority;
 taskStates taskState;
 unsigned int delayCount;
 struct TCB * nextTCB;
 unsigned inUse;

}TCB;


extern unsigned ourTCB;
extern unsigned nextTCB;

extern struct TCB TCBArray[15];

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
# 2 "yakc.c" 2




uint16_t YKIdleCount = 0;
struct TCB TCBArray[15];
unsigned int nextTask;
unsigned int nextBP;
unsigned int nextSP;
int IdleStk[2048];
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

 YKNewTask(YKIdleTask, (void *)&IdleStk[2048] , 100);


}

void YKNewTask(void(*task)(void), void * taskStack, unsigned char priority){
 int i = 0;



 YKEnterMutex();
 for(i = 0; i < 15; i++){
  if(!TCBArray[i].inUse){
   break;
  }
 }







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


  for(i = 0; i < 1; i++){
   i++;
   i--;
  }
  YKIdleCount++;
 }
}

void YKScheduler(){

 int index = 0;
 int highestPriority = 101;
 int indexOfTaskToRun = 101;
 for(index = 0; index < 15 ; index++){
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
# 128 "yakc.c"
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



 if(isRunning && firstTime){
  firstTime = 0;
  YKCtxSwCount++;
  currentTCBIndex = indexOfTaskToRun;
  dispatchHelperFirst();
  return;
 }



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
 for(index = 0; index < 15; index++){
  if(!TCBArray[index].inUse){
   break;
  }
  if(TCBArray[index].delayCount > 0){
   TCBArray[index].delayCount--;


  }
 }
# 229 "yakc.c"
}
