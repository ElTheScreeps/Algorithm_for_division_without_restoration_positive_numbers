module top();

reg 		clk;
reg 		reset_n;
reg 		req;
reg  [15:0] valori;

wire 		ack;
wire [15:0] rezultat;

always #5 clk <= ~clk;

initial begin
clk = 0;
reset_n = 1;
req = 0;
valori = 0;
repeat (3) @(posedge clk);
reset_n = 0;
@(posedge clk);
req = 1;
reset_n = 1;
@(posedge clk)
valori = 16'b0100101100001010;
req = 0;
@(posedge clk);
repeat (150) @(posedge clk);
$stop;
end

divider DIVIDER(
.clk(clk),
.reset_n(reset_n),
.req(req),
.valori(valori),
.ack(ack),
.rezultat(rezultat)
);

endmodule
