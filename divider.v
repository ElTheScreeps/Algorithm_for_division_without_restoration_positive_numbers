module divider(
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

localparam S0  = 4'b0000; //reset_n
localparam S1  = 4'b0001; //load dividend and divisor
localparam S2  = 4'b0010; //if msb p = 1
localparam S3  = 4'b0011; //concatenation (P) (LSB P = MSB A)
localparam S4  = 4'b0100; //P <= P + B
localparam S5  = 4'b0101; //concatenation (P) (LSB P = MSB A)
localparam S6  = 4'b0110; //P <= P + (-B)
localparam S7  = 4'b0111; //concatenation (A) (LSB A = not MSB P)
localparam S8  = 4'b1000; //if msb p = 1
localparam S9  = 4'b1001; //P <= P + B
localparam S10 = 4'b1010; //STOP

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
