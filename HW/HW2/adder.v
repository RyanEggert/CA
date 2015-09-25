// define gates with delays
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50
`define XNOR xnor #50

module behavioralFullAdder(sum, carryout, a, b, carryin);
output sum, carryout;
input a, b, carryin;
assign {carryout, sum}=a+b+carryin;
endmodule

module structuralFullAdder(sum, carryout, a, b, carryin);
output sum, carryout;
input a, b, carryin;
wire FA_XOR1_O;
wire FA_AND1_O;
wire FA_AND2_O;
`XOR FA_XOR1(FA_XOR1_O, a, b);
`XOR FA_XOR2(sum, FA_XOR1_O, carryin);
`AND FA_AND1(FA_AND1_O, FA_XOR1_O, carryin);
`AND FA_AND2(FA_AND2_O, a, b);
`OR FA_OR1(carryout, FA_AND1_O, FA_AND2_O);
endmodule

module testFullAdder;
reg a, b, carryin;
wire str_sum, str_carryout;
wire beh_sum, beh_carryout;
behavioralFullAdder beh_adder(beh_sum, beh_carryout, a, b, carryin);
structuralFullAdder str_adder(str_sum, str_carryout, a, b, carryin);

initial begin
// Begin Combined Testbench
// Completely test behavioral and structural adders
$display(" Inputs  | Behavioral | Structural | Expected");
$display("A B C_In | Sum C_Out  | Sum C_Out  |Sum C_Out");
carryin=0;a=0;b=0; #1000 
$display("%b %b %b    |  %b  %b      |  %b  %b      | 0   0", a, b, carryin, beh_sum, beh_carryout, str_sum, str_carryout);
carryin=1;a=0;b=0; #1000 
$display("%b %b %b    |  %b  %b      |  %b  %b      | 1   0", a, b, carryin, beh_sum, beh_carryout, str_sum, str_carryout);
carryin=0;a=0;b=1; #1000 
$display("%b %b %b    |  %b  %b      |  %b  %b      | 1   0", a, b, carryin, beh_sum, beh_carryout, str_sum, str_carryout);
carryin=1;a=0;b=1; #1000 
$display("%b %b %b    |  %b  %b      |  %b  %b      | 0   1", a, b, carryin, beh_sum, beh_carryout, str_sum, str_carryout);
carryin=0;a=1;b=0; #1000 
$display("%b %b %b    |  %b  %b      |  %b  %b      | 1   0", a, b, carryin, beh_sum, beh_carryout, str_sum, str_carryout);
carryin=1;a=1;b=0; #1000 
$display("%b %b %b    |  %b  %b      |  %b  %b      | 0   1", a, b, carryin, beh_sum, beh_carryout, str_sum, str_carryout);
carryin=0;a=1;b=1; #1000 
$display("%b %b %b    |  %b  %b      |  %b  %b      | 0   1", a, b, carryin, beh_sum, beh_carryout, str_sum, str_carryout);
carryin=1;a=1;b=1; #1000 
$display("%b %b %b    |  %b  %b      |  %b  %b      | 1   1", a, b, carryin, beh_sum, beh_carryout, str_sum, str_carryout);
// Reference truth table verified from
// http://www.electronicshub.org/wp-content/uploads/2014/08/Truth-Table-for-Full-Adder.jpg
end
endmodule
