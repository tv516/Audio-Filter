/*
 * audio_demo.c
 *
 *  Created on: May 8, 2013
 *      Author: jxciee
 */

#include <stdio.h>
#include "io.h"
#include "system.h"
#include "alt_types.h"
#include "math.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"



// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

// Global variables
#define MAX_SAMPLES 				 0x80000  //max sample data (16 bits each) for SDRAM

uint32 ECHO_CNT = 0;                      // index into buffer
uint32 SAMPLE_CNT = 0;                    //keep track of which sample is being read from SDRAM
uint32 CHANNELS = 0;
volatile uint16 TOGGLE = 0;



#define FIRST_TIME         1                // 1= means it is the first time running, so the file is loaded in SRAM

//set up pointers to peripherals
uint16* SdramPtr    = (uint16*)NEW_SDRAM_CONTROLLER_0_BASE;
uint32* AudioPtr    = (uint32*)AUDIO_0_BASE;
uint32* TimerPtr    = (uint32*)TIMER_0_BASE;
uint32* PinPtr      = (uint32*)PIN_BASE;

  //In this ISR, most of the processing is performed.  The timer interrupt is set for 20.83 us which is
  // 1/48000.  By setting the timer interrupt at the sampling rate, a new sample is never missed and the
  // audio output fifo never gets overloaded.  this is easier than using the interrupts provided with the
  // audio core
void timer_isr(void *context)
{
	  uint16 right_sample, left_sample;

		//clear timer interrupt
        *TimerPtr = 0;
        if (TOGGLE == 0)
        { TOGGLE = 1;}
        else {TOGGLE = 0;
        }
        *PinPtr = TOGGLE;


	    if (SAMPLE_CNT < MAX_SAMPLES)
	    {
	    	left_sample = SdramPtr[SAMPLE_CNT++];  //read left side sample first

	    	if (CHANNELS == 2)                       //only read right sample if stereo mode
	    	{
	    		right_sample = SdramPtr[SAMPLE_CNT++];
	    		AudioPtr[3] = right_sample;       //in stereo, output to both sides
	    	    AudioPtr[2] = left_sample;
	    	}
	    	else
	    	{
	    		AudioPtr[3] = left_sample;       //in mono, output same sample to both sides
	    		AudioPtr[2] = left_sample;
	    	}
	    }
	    else      //this will allow continuous looping of audio.  comment this out to only play once
	    {
	    	SAMPLE_CNT = 0;
	    }


	return;

}



//this function reads a .wav file and stores the data in the SDRAM
//first it parses the header and stores that information in variables.
//Only files with 48K sample rates and 16 bit data will work with this program.

void read_file(void)
{
	//buffers for the header information
	uint8 ChunkID[4], Format[4], Subchunk1ID[4], Subchunk2ID[4];
	uint32 ChunkSize,Subchunk1Size, SampleRate, ByteRate, Subchunk2Size;
	uint16 AudioFormat, NumChannels, BlockAlign, BitsPerSample;
	uint16 Data;
	FILE* fp;
	uint32 i = 0;

	//start reading
	  fp = fopen("/mnt/host/piano2.wav", "r");

	  if(fp == NULL)
	  {
	    printf("error, no file open!\n");
	  }

	  else
	  {
	    printf("file opened.\n");
	    fread(ChunkID,1,4,fp);
	    fread(&ChunkSize,4,1,fp);
	    fread(Format,1,4,fp);
	    fread(Subchunk1ID,1,4,fp);
	    fread(&Subchunk1Size,4,1,fp);
	    fread(&AudioFormat,2,1,fp);
	    fread(&NumChannels,2,1,fp);
	    fread(&SampleRate,4,1,fp);
	    fread(&ByteRate,4,1,fp);
	    fread(&BlockAlign,2,1,fp);
	    fread(&BitsPerSample,2,1,fp);
	    fread(&Subchunk2ID,1,4,fp);
	    fread(&Subchunk2Size,4,1,fp);

	    CHANNELS = NumChannels;

	    while (i < MAX_SAMPLES)
	    {

	    	fread(&Data, 2, 1, fp);  //read the file in one short int at a time
	    	SdramPtr[i++] = Data;   //store in sdram.

	    }
	    printf("file read \n");  //let user know file was read
	  }
}




int main(void)
{
	printf("ESD-I Audio Demo Program Running.\n");

#if (FIRST_TIME)
	read_file();
#endif

   //Register interrupts
   //Use legacy register because the audio core forces the system to legacy
	//alt_irq_register(TIMER_0_IRQ,0,timer_isr);
	alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ,timer_isr,0,0);
   //initialize timer interrupt 48Khz
	TimerPtr[4] = 3;


 while (1)
 {
 }
 return 0;
}
