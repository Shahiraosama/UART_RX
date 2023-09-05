`include "UART_RX.v"
`timescale 1ns/1ps
module UART_RX_TB ;

reg				clk_tb;
reg				rst_tb;
reg				RX_IN_tb;	
reg				PAR_EN_tb;
reg		[4:0]		prescale_tb;
reg				PAR_TYPE_tb;
wire				data_valid_tb;
wire	[7:0]			P_Data_tb;

localparam T = 5;
localparam even =1'b0;
localparam odd  = 1'b1;
integer i;

reg [10:0] data_with_parity;
reg	[9:0] data_with_no_parity;


always
begin
#(T/2.0) clk_tb = ~clk_tb ;
end






initial
begin

clk_tb = 1'b0;
rst_tb =1'b0;
RX_IN_tb =1'b1;
PAR_EN_tb =1'b0;
prescale_tb =5'd16;
PAR_TYPE_tb =1'b0;


#T rst_tb = 1'b1;

data_with_no_parity = 10'b0_1100_0101_1;

for (i=9 ; i > -1 ; i=i-1) 
begin
    @(posedge clk_tb)
begin
        RX_IN_tb = data_with_no_parity [i];
        #(17*T);
    end
end

$display ("\n Test Case 1 checking the data with prescale of 16 and no parity \n");
#(T) check_data (8'b1010_0011);
#(T) RX_IN_tb =1'b1;

/////////////////////////////////////////////////////////////////////////////////////////////////////////

#T rst_tb =1'b0;
#T PAR_EN_tb =1'b1; rst_tb = 1'b1;



data_with_parity = 11'b0_1100_0101_0_1;
for (i=10 ; i > -1 ; i=i-1) 
begin
    @(posedge clk_tb)
begin
        RX_IN_tb = data_with_parity [i];
        #(17*T);
    end
end

$display ("\n Test Case 2 checking the data with prescale of 16 and even parity \n");
#(T) check_data_with_even_parity (8'b1010_0011);
#(T) even_parity_check (0);
#(T) RX_IN_tb =1'b1;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

#T rst_tb =1'b0;
#T PAR_EN_tb =1'b1; rst_tb = 1'b1; PAR_TYPE_tb =1'b1;


data_with_parity = 11'b0_1100_0101_1_1;
for (i=10 ; i > -1 ; i=i-1) 
begin
    @(posedge clk_tb)
begin
        RX_IN_tb = data_with_parity [i];
        #(17*T);
    end
end

$display ("\n Test Case 3 checking the data with prescale of 16 and odd parity \n");
#(T) check_data_with_odd_parity (8'b1010_0011);
#(T) odd_parity_check (1);
#(T) RX_IN_tb =1'b1;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#T rst_tb =1'b0;
#T PAR_EN_tb =1'b0; rst_tb = 1'b1; prescale_tb =5'd8;

data_with_no_parity = 10'b0_1100_0101_1;

for (i=9 ; i > -1 ; i=i-1) 
begin
    @(posedge clk_tb)
begin
        RX_IN_tb = data_with_no_parity [i];
        #(9*T);
    end
end

$display ("\n Test Case 4 checking the data with prescale of 8 and no parity \n");
#(T) check_data (8'b1010_0011);
#(T) RX_IN_tb =1'b1;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////


#T rst_tb =1'b0;
#T PAR_EN_tb =1'b1; rst_tb = 1'b1; PAR_TYPE_tb = 1'b0;

data_with_parity = 11'b0_1100_0101_0_1 ;

for (i=10 ; i > -1 ; i=i-1) 
begin
    @(posedge clk_tb)
begin
        RX_IN_tb = data_with_parity [i];
        #(9*T);
    end
end

$display ("\n Test Case 5 checking the data with prescale of 8 and even parity \n");
#(T) check_data (8'b1010_0011);
#(T) even_parity_check (0);
#(T) RX_IN_tb =1'b1;

///////////////////////////////////////////////////////////////////////////////




#T rst_tb =1'b0;
#T PAR_EN_tb =1'b1; rst_tb = 1'b1; PAR_TYPE_tb =1'b1;


data_with_parity = 11'b0_1100_0101_1_1;
for (i=10 ; i > -1 ; i=i-1) 
begin
    @(posedge clk_tb)
begin
        RX_IN_tb = data_with_parity [i];
        #(9*T);
    end
end

$display ("\n Test Case 6 checking the data with prescale of 8 and odd parity \n");
#(T) check_data_with_odd_parity (8'b1010_0011);
#(T) odd_parity_check (1);
#(T) RX_IN_tb =1'b1;


#(2*T) $stop;
end


task check_data;
input [7:0] x;


if (x !== P_Data_tb)
begin
$display("\n the data isn't sent correctly \n"); 
end
else
begin
$display("\n the data is sent correctly \n");
end

endtask


task check_data_with_even_parity;
input [7:0] y;


if (y == P_Data_tb)
begin
$display("\n the data is sent correctly \n"); 
end
else
begin
$display("\n the data isn't sent correctly \n"); 
end

endtask

 
task even_parity_check;
input z;

if (z == DUT.PAR_CHK.parity_bit)
begin
$display("\n the even parity check passed \n"); 
end
else
begin
$display("\n the even parity check failed \n"); 
end


endtask




task check_data_with_odd_parity;
input [7:0] y;


if (y == P_Data_tb)
begin
$display("\n the data is sent correctly \n"); 
end
else
begin
$display("\n the data isn't sent correctly \n"); 
end

endtask



task odd_parity_check;
input z;

if (z == DUT.PAR_CHK.parity_bit)
begin
$display("\n the odd parity check passed \n"); 
end
else
begin
$display("\n the odd parity check failed \n"); 
end


endtask


// always @(posedge clk_tb)
//  begin
//     counter<=counter+1;

//     if (counter == prescale_tb-1'b1) 
// begin
// 	txclk <= ~txclk;
// end
// else
// begin
//     rxclk<= ~rxclk;
// end  
// end

 



UART_RX DUT (
.clk(clk_tb),
.rst(rst_tb),
.RX_IN (RX_IN_tb),
.PAR_EN(PAR_EN_tb),
.prescale(prescale_tb),
.PAR_TYPE(PAR_TYPE_tb),
.data_valid (data_valid_tb),
.P_Data (P_Data_tb)

);

endmodule