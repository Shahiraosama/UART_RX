module deserializer (

input	wire			sampled_bit,
input	wire			deser_en,
input	wire			clk,
input	wire			rst,
input	wire		[4:0]	prescale,
input	wire		[4:0]	edge_count,
output	reg		[7:0]	P_Data

);

always @ (posedge clk or negedge rst)
begin
if(!rst)

begin 

P_Data <= 8'b0;

end

else if (deser_en && edge_count == prescale )

begin
// 1100_0101
// 1000_0000    128
// 1100_0000    192
// 0110_0000    96
// 0011_0000    48
// 0001_1000    24
// 1000_1100    140
// 0100_0110    70
// 1010_0011    163

//P_Data <= {P_Data[6:0],sampled_bit};
P_Data <= {sampled_bit,P_Data[7:1]};
end

end

endmodule