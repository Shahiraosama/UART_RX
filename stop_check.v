module stop_check (

input	wire		clk,
input	wire		rst,
input	wire		stp_chk_en,
input	wire		sampled_bit,
output	reg		stp_err


);

always @(posedge clk or negedge rst)
begin

if (!rst)
begin
stp_err <= 1'b0 ;
end

else if (stp_chk_en)
begin

if (sampled_bit)
begin
stp_err <= 1'b0;
end

else
begin
stp_err <= 1'b1;
end

end

end
endmodule