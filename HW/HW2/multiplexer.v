// define gates with delays
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50
`define XNOR xnor #50

module behavioralMultiplexer(out, address0, address1, in0, in1, in2, in3);
output out;
input address0, address1;
input in0, in1, in2, in3;
wire[3:0] inputs = {in3, in2, in1, in0};
wire[1:0] address = {address1, address0};
assign out = inputs[address];
endmodule

module structuralMultiplexer(out, address0, address1, in0, in1, in2, in3);
output out;
input address0, address1;
input in0, in1, in2, in3;
wire and0out, and1out, and2out, and3out;
wire naddr0, naddr1;

`NOT not0(naddr0, address0);
`NOT not1(naddr1, address1);

`AND and0(and0out, in0, naddr0, naddr1); // Woo, three input ANDs!
`AND and1(and1out, in1, naddr0, address1); 
`AND and2(and2out, in2, address0, naddr1); 
`AND and3(and3out, in3, address0, address1);

`OR or0(out, and0out, and1out, and2out, and3out); 
endmodule

module testMultiplexer;

reg in0, in1, in2, in3;
reg address0, address1;
wire beh_out; // Behavioral multiplexer output
wire str_out; // Structural multiplexer output

behavioralMultiplexer beh_multip(beh_out, address0, address1, in0, in1, in2, in3);
structuralMultiplexer str_multip(str_out, address0, address1, in0, in1, in2, in3); 

initial begin
$display("         Inputs         | Beh.| Str.| Exp.");
$display("In3 In2 In1 In0 | A1 A0 | Out | Out | Out ");

// Test Input 0
in3=1; in2=1; in1=1; in0=0; address1=0; address0=0; #1000 
$display("%b   %b   %b   %b   | %b  %b  | %b   | %b   | 0 ", in3, in2, in1, in0, address1, address0, beh_out, str_out);
in3=0; in2=0; in1=0; in0=1; address1=0; address0=0; #1000 
$display("%b   %b   %b   %b   | %b  %b  | %b   | %b   | 1 ", in3, in2, in1, in0, address1, address0, beh_out, str_out);

// Test Input 1
in3=1; in2=1; in1=0; in0=1; address1=0; address0=1; #1000 
$display("%b   %b   %b   %b   | %b  %b  | %b   | %b   | 0 ", in3, in2, in1, in0, address1, address0, beh_out, str_out);
in3=0; in2=0; in1=1; in0=0; address1=0; address0=1; #1000 
$display("%b   %b   %b   %b   | %b  %b  | %b   | %b   | 1 ", in3, in2, in1, in0, address1, address0, beh_out, str_out);

// Test Input 2
in3=1; in2=0; in1=1; in0=1; address1=1; address0=0; #1000 
$display("%b   %b   %b   %b   | %b  %b  | %b   | %b   | 0 ", in3, in2, in1, in0, address1, address0, beh_out, str_out);
in3=0; in2=1; in1=0; in0=0; address1=1; address0=0; #1000 
$display("%b   %b   %b   %b   | %b  %b  | %b   | %b   | 1 ", in3, in2, in1, in0, address1, address0, beh_out, str_out);

// Test Input 3
in3=0; in2=1; in1=1; in0=1; address1=1; address0=1; #1000 
$display("%b   %b   %b   %b   | %b  %b  | %b   | %b   | 0 ", in3, in2, in1, in0, address1, address0, beh_out, str_out);
in3=1; in2=0; in1=0; in0=0; address1=1; address0=1; #1000 
$display("%b   %b   %b   %b   | %b  %b  | %b   | %b   | 1 ", in3, in2, in1, in0, address1, address0, beh_out, str_out);
end
endmodule
