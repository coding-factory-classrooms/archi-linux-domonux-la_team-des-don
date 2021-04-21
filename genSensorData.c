#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>


int main( int argc, char* argv[] )
{
    char buff[256];
    printf("genSensorData start\n");
    // Check number of arguments
    // if(argc != 2){
    //     strcpy( buff, "\ngenTick : your command is not correct.\nPlease type : genTick <delay>\nwith a delay value in milliseconds between 50 and 5000\n\n");
    //     write(2,buff, strlen(buff));
    // }
    while (1){
        printf("Sensor = %s\n", argv[1]);
        // Wait for a while according to delay
        usleep( 1000*1000 );
    }
    // End of program
    printf("genSensorData end\n");
    return 0;
}
