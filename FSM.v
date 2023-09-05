module FSM (

input	wire			clk,
input	wire			rst,
input	wire	[4:0]		prescale,
input	wire			PAR_EN,
input	wire			RX_IN,
input	wire	[4:0]		edge_count,	
input	wire	[3:0]		bit_count,
input	wire			stp_err,
input	wire			strt_glitch,
input	wire			par_err,
output	reg			data_sample_en,
output	reg			enable,
output	reg			deser_en,
output	reg			data_valid,
output	reg			stp_chk_en,
output	reg			strt_chk_en,
output	reg			par_chk_en


);

reg		[3:0]	current_state;
reg		[3:0]	next_state;

localparam IDLE   = 4'b0000;
localparam start  = 4'b0001;
localparam S_Data = 4'b0010;
localparam parity = 4'b0011;
localparam stop   = 4'b0111;
localparam check  = 4'b1111;
localparam anothr_frame = 4'b1110;


always @(posedge clk or negedge rst) begin
    if(!rst) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state ;
    end
end

always@(*) begin
    case(current_state)
    IDLE: begin
        if (RX_IN) begin
            next_state = IDLE ;
        end
        else begin
            next_state = start;
        end
    end

    start: begin
        if (bit_count == 4'b0 && edge_count != prescale ) begin
            next_state = start;
        end
        else begin
            if (!strt_glitch)
            begin
            next_state = S_Data;
            end
            else begin
            next_state = IDLE ;
            end
        end
    end

    S_Data: begin
        if ((bit_count != 4'd0) && (bit_count <= 4'd8)) begin
            next_state = S_Data ;
        end
        else begin
            if(PAR_EN) begin
                next_state = parity ;
            end
            else begin
                next_state = stop ;
            end
        end
    end

    parity: begin
        if(bit_count != 4'd9 && edge_count == prescale) begin
            next_state = parity;
        end
        else begin
            if(!par_err) begin
                next_state = stop ;
            end
            else begin
                next_state = IDLE;
            end
        end
    end

    stop: begin
        if (bit_count == 4'd9 && edge_count != prescale) begin
            next_state = stop;
        end
        else begin
            next_state = check;
        end
    end

    check: begin
        if (stp_err || par_err) begin
            next_state = IDLE ;
        end
        else begin
            next_state = anothr_frame;
        end
    end

    anothr_frame: begin
        if(!RX_IN) begin
            next_state = start;
        end
        else begin
            next_state = IDLE ;
        end
    end

    default :
    begin
    next_state = IDLE ;
    end

    endcase

end

always@(*)
begin

case(current_state)

IDLE:
begin

if(RX_IN)
begin
data_sample_en = 1'b0;
enable = 1'b0;
deser_en = 1'b0;
data_valid =1'b0;
stp_chk_en =1'b0;
strt_chk_en =1'b0;
par_chk_en = 1'b0;
end

else
begin
data_sample_en = 1'b1;
enable = 1'b1;
deser_en = 1'b0;
data_valid =1'b0;
stp_chk_en =1'b0;
strt_chk_en =1'b1;
par_chk_en = 1'b0;
end

end

start:
begin

data_sample_en = 1'b1;
enable = 1'b1;
deser_en = 1'b0;
data_valid =1'b0;
stp_chk_en =1'b0;
strt_chk_en =1'b1;
par_chk_en = 1'b0;


end

S_Data:
begin

data_sample_en = 1'b1;
enable = 1'b1;
deser_en = 1'b1;
data_valid =1'b0;
stp_chk_en =1'b0;
strt_chk_en =1'b0;
par_chk_en = 1'b0;

end


parity:
begin

data_sample_en = 1'b1;
enable = 1'b1;
deser_en = 1'b0;
data_valid =1'b0;
stp_chk_en =1'b0;
strt_chk_en =1'b0;
par_chk_en = 1'b1;

end

stop:
begin

data_sample_en = 1'b1;
enable = 1'b1;
deser_en = 1'b0;
data_valid =1'b0;
stp_chk_en =1'b1;
strt_chk_en =1'b0;
par_chk_en = 1'b0;

end

check:
begin

data_sample_en = 1'b1;
enable = 1'b0;
deser_en = 1'b0;
data_valid =1'b0;
stp_chk_en =1'b0;
strt_chk_en =1'b0;
par_chk_en = 1'b0;

end

anothr_frame:
begin
data_sample_en = 1'b1;
enable = 1'b0;
deser_en = 1'b0;
data_valid =1'b1;
stp_chk_en =1'b0;
strt_chk_en =1'b0;
par_chk_en = 1'b0;
end


default:
begin
data_sample_en = 1'b0;
enable = 1'b0;
deser_en = 1'b0;
data_valid =1'b0;
stp_chk_en =1'b0;
strt_chk_en =1'b0;
par_chk_en = 1'b0;
end

endcase


end
endmodule