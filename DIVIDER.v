module DIVIDER(
input 	      clk,
input 	      reset_n,
input 	      req,
input  [15:0] values,
output reg    ack,
output [15:0] result
);

reg [3:0] state;
reg [7:0] A;
reg [7:0] B;
reg [8:0] P;
reg [3:0] counter;
reg [7:0] remainder;
reg [7:0] quotient;

assign result [15:8] = remainder;
assign result [7:0] = quotient;

localparam [3:0]
    S0  = 4'd0, //reset_n
    S1  = 4'd1, //load dividend and divisor
    S2  = 4'd2, //if msb p = 1
    S3  = 4'd3, //concatenation (P) (LSB P = MSB A)
    S4  = 4'd4, //P <= P + B
    S5  = 4'd5, //concatenation (P) (LSB P = MSB A)
    S6  = 4'd6, //P <= P + (-B)
    S7  = 4'd7, //concatenation (A) (LSB A = not MSB P)
    S8  = 4'd8, //if msb p = 1
    S9  = 4'd9, //P <= P + B
    S10 = 4'd10; //STOP

always @(posedge clk or negedge reset_n)
begin
	if (~reset_n) state <= S0;
	else if (state == S0 & req) state <= S1;
	else if (state == S1) state <= S2;
	else if (state == S2 & P[8]) state <= S3;
	else if (state == S3) state <= S4;
	else if (state == S2 & ~P[8]) state <= S5;
	else if (state == S5) state <= S6;
	else if (state == S4) state <= S7;
	else if (state == S6) state <= S7;
	else if (state == S7) state <= S8;
	else if (state == S8 & counter == 8) state <= S9;
	else if (state == S8) state <= S2;
	else if (state == S9) state <= S10;
end

always @(posedge clk or negedge reset_n)
begin
	if (~reset_n) A <= 'b0;
	else if (state == S1) A <= values [15:8];
	else if (state == S7) A [7:0] <= {A[6:0], ~P[8]};
end

always @(posedge clk or negedge reset_n)
begin
	if (~reset_n) B <= 'b0;
	else if (state == S1) B <= values [7:0];
end

always @(posedge clk or negedge reset_n) 
begin
	if (~reset_n) P <= 'b0;
	else if (state == S3 | state == S5) P <= {P[7:0], A[7]};
	else if (state == S4 | state == S9) P <= P + B;
	else if (state == S6) P <= P + (-B);
end

always @(posedge clk or negedge reset_n)
begin
	if (~reset_n) ack <= 'b0;
	else if (ack) ack <= 'b0;
	else if (state == S9) ack <= 'b1;
	else if (state == S10) ack <= 'b0;
end

always @(posedge clk or negedge reset_n)
begin
	if (~reset_n) remainder <= 'b0;
	else if (state == S9) remainder <= P [7:0];
end

always @(posedge clk or negedge reset_n)
begin
	if (~reset_n) quotient <= 'b0;
	else if (state == S9) quotient <= A;
end

always @(posedge clk or negedge reset_n)
begin
	if (~reset_n) counter <= 'b0;
	else if (state == S0) counter <= 'b0;
	else if (state == S7) counter <= counter + 1;
end

endmodule
