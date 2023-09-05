# UART_RX

> UART stands for Universal Asynchronous Receiver/Transmitter.

> UART is a block of circuitry responsible for implementing serial communication between 2 devices.

> UART can be simplex (only transmit or recieve the data),half duplex (data transmission in both directions but not simultaneously) or Full Duplex protocol ( data transmission in both directions simultaneously).

> Data is transmitted as frames.

> It's important for lower-speed and low-throughput applications.

#Inputs :-
> RX_IN (serial_data) which is coming from UART_TX and it will enter to UART RX to convert it to parallel form and transfer the data to be processed by other blocks.

>PAR_EN to enable the parity flag if it's required.

>PAR_TYPE to determine which parity type (even or odd) will be used in the frame.

>prescale is a 5-bit signal which is used to indicate the speed of UART RX relative to UART TX and it take the values of (8,16,32)

>clk

>rst (asynchronous reset)

 #Outputs :-
> data_valid it indicates that the data is sent correctly

> P_Data is a 8-bit data that came out from deserializer

#Specifications :-
> UART RX receive a UART frame on RX_IN.

> RX_IN is high in the IDLE case (No transmission). 

>PAR_ERR signal is high when the calculated parity bit not equal the received frame parity bit as this mean that the frame is corrupted.

>STP_ERR signal is high when the received stop bit not equal 1 as this mean that the frame is corrupted.

>DATA is extracted from the received frame and then sent through P_DATA bus associated with DATA_VLD signal only after checking that the frame is received correctly and not corrupted. (PAR_ERR = 0 && STP_ERR = 0).

> Registers are cleared using asynchronous active low reset

> PAR_EN (Configuration)
0: To disable frame parity bit
1: To enable frame parity bit

>PAR_TYP (Configuration)
0: Even parity bit
1: Odd parity bit

>UART_RX can accept consequent frames without any gap

>UART_RX support oversampling by 3 so that the UART_RX can recieve the correct bits
 
