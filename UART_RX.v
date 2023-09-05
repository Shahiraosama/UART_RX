`include "Data_sampling.v"
`include "deserializer.v"
`include "edge_bit_counter.v"
`include "start_check.v"
`include "stop_check.v"
`include "Parity_check.v"
`include "FSM.v"
module UART_RX (

input	wire			clk,
input	wire			rst,
input	wire			RX_IN,
input	wire			PAR_EN,
input	wire		[4:0]	prescale,
input	wire			PAR_TYPE,
output				data_valid,
output			[7:0]	P_Data


);

wire			par_chk_en; 
wire			sampled_bit;
wire			par_err;
wire			stp_chk_en;
wire			deser_en;
wire			data_sample_en;
wire	[4:0]		edge_count;
wire			enable;
wire	[3:0]		bit_count;
wire			strt_chk_en;
wire			strt_glitch;


Parity_check PAR_CHK (
.clk(clk),
.rst(rst),
.PAR_TYPE(PAR_TYPE),
.par_chk_en(par_chk_en),
.par_en(PAR_EN),
.sampled_bit(sampled_bit),
.P_Data(P_Data),
.par_err(par_err)
);


stop_check stp_chk (
.clk(clk),
.rst(rst),
.stp_chk_en(stp_chk_en),
.sampled_bit(sampled_bit),
.stp_err(stp_err)

);

deserializer deser_Unit (
.clk(clk),
.rst(rst),
.sampled_bit(sampled_bit),
.P_Data(P_Data),
.deser_en (deser_en),
.edge_count (edge_count),
.prescale (prescale)
);

Data_sampling sampler (
.clk(clk),
.rst(rst),
.RX_IN(RX_IN),
.prescale(prescale),
.data_sample_en(data_sample_en),
.edge_count(edge_count),
.sampled_bit (sampled_bit)

);

edge_bit_counter counter_Unit (
.clk(clk),
.rst(rst),
.enable(enable),
.prescale(prescale),
.bit_count (bit_count),
.edge_count (edge_count)
);

start_check strt_CHK_Unit (
.clk(clk),
.rst(rst),
.sampled_bit(sampled_bit),
.strt_chk_en (strt_chk_en),
.strt_glitch (strt_glitch)

);

FSM fsm_Unit (
.clk(clk),
.rst(rst),
.PAR_EN(PAR_EN),
.RX_IN(RX_IN),
.edge_count(edge_count),
.bit_count(bit_count),
.stp_err(stp_err),
.strt_glitch(strt_glitch),
.par_err (par_err),
.data_sample_en (data_sample_en),
.enable(enable),
.deser_en(deser_en),
.data_valid(data_valid),
.stp_chk_en(stp_chk_en),
.strt_chk_en(strt_chk_en),
.par_chk_en (par_chk_en),
.prescale (prescale)
);


endmodule