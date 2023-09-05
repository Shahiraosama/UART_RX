module Data_sampling (

input	wire			clk,	
input	wire			rst,
input	wire	[4:0]		prescale,
input	wire			RX_IN,
input	wire			data_sample_en,
input	wire	[4:0]		edge_count,
output	reg			sampled_bit

);

wire		[3:0]	half_bit;
wire		[3:0]	half_bit_before;
wire		[3:0]	half_bit_after;	
reg			sampling_done;
reg		[2:0]	samples;

always@(posedge clk or negedge rst)
begin

if (!rst)
begin
samples <= 3'b0 ;
sampling_done <= 1'b0;
sampled_bit <= 1'b0;
end

else if (data_sample_en && !sampling_done)

begin

if (edge_count == half_bit_before )

begin
samples[0] <= RX_IN ; 
end

else if (edge_count == half_bit )
begin
samples[1] <= RX_IN ;
end


else if (edge_count == half_bit_after )

begin
samples [2] <= RX_IN ;
sampling_done <= 1'b1;
end

end

else if (data_sample_en && sampling_done)
begin
sampled_bit <= (samples [0] & samples [2]) | (samples [0] & samples[1]) | (samples[1] & samples[2]) ;
sampling_done <= 1'b0;
end

else
begin
sampling_done <= 1'b0;
end

end







assign half_bit = (prescale >> 1'b1)  ;
assign half_bit_before = half_bit - 1'b1 ;
assign half_bit_after = half_bit + 1'b1;


endmodule