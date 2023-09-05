module edge_bit_counter (

input	wire				clk,
input	wire				rst,
input	wire				enable,
input	wire    	[4:0]		prescale,
output	reg		[3:0]	 	bit_count,
output	reg		[4:0]		edge_count		

);

always@(posedge clk or negedge rst)
begin

if(!rst)
begin
edge_count <= 5'b0 ;
bit_count <= 4'b0 ;
end

else if (enable)
begin

if(edge_count != prescale)
begin
edge_count <= edge_count + 1'b1 ;
end

else
begin
edge_count <= 5'b0;
bit_count <= bit_count + 1'b1 ;

end

end

end

endmodule