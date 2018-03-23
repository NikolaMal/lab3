#include <stdio.h.>
#include "platform.h"
#include "xparameters.h"
#include "xio.h"

int main () {
	unsigned int DataRead;
	unsigned int OldData;

	init_platform();

	xil_printf("%c[2J", 27);

	OldData = (unsigned int) 0xffffffff;
	while(1){
		DataRead = XIo_In32(XPAR_MY_PERIPHERAL_0_BASEADDR);
		if(DataRead!=OldData){
			xil_printf("DIP Switch settings: 0x%2X\r\n", DataRead);
			XIo_Out32(XPAR_MY_PERIPHERAL_0_BASEADDR, DataRead);
			OldData = DataRead;
		}
	}
}
