################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/my_peripheral_test/my_peripheral_test.c \
../src/my_peripheral_test/platform.c 

OBJS += \
./src/my_peripheral_test/my_peripheral_test.o \
./src/my_peripheral_test/platform.o 

C_DEPS += \
./src/my_peripheral_test/my_peripheral_test.d \
./src/my_peripheral_test/platform.d 


# Each subdirectory must supply rules for building sources it contributes
src/my_peripheral_test/%.o: ../src/my_peripheral_test/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../hello_world_bsp/microblaze_0/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.50.b -mno-xl-soft-mul -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


