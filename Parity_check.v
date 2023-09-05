module Parity_check(

input	wire			clk,
input	wire			rst,
input	wire			PAR_TYPE,
input	wire			par_chk_en,
input	wire			par_en,
input	wire			sampled_bit,
input	wire	[7:0]		P_Data,
output	reg			par_err
);

reg		parity_bit ;

localparam even = 1'b0;
localparam odd  = 1'b1;

always@(posedge clk or negedge rst)
 begin
	if (!rst)
begin
	parity_bit <= 1'b0 ;
end

	else if (par_en)
begin
	case (PAR_TYPE)
	
even:
	begin
	parity_bit <= ^(P_Data);
	end
	
odd:
	begin
    parity_bit <= ~^(P_Data);
	end
	
	endcase
end
end

always@(posedge clk or negedge rst)
begin

if (!rst)
begin
par_err <= 1'b0;
end

else if (par_chk_en)
begin
par_err <= sampled_bit ^ parity_bit ;
end


end
endmodule
