// define gates with delays
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50
`define XNOR xnor #50

module FullAdder1bit
(
    output sum,         //sum of a and b
    output carryout,    // Carry out of summation of a and b
    input a,            // First operand (1-bit)
    input b,            // Second operand (1-bit)
    input carryin       // Carried In bit (1-bit)
);

wire xor1_O;
wire and1_O;
wire and2_O;

`XOR xor1(xor1_O, a, b);
`XOR xor2(sum, xor1_O, carryin);
`AND and1(and1_O, xor1_O, carryin);
`AND and2(and2_O, a, b);
`OR or1(carryout, and1_O, and2_O);
endmodule


module FullAdder4bit
(
  output[3:0] sum,  // 4-bit 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  output overflow,  // True if the calculation resulted in an overflow
  input[3:0] a,     // First operand (4-bit) in 2's complement format
  input[3:0] b      // Second operand (4-bit) in 2's complement format
);

wire adder0_cout;
wire adder1_cout;
wire adder2_cout;
wire adder3_cout;
// A four-bit full adder is comprised of four one-bit adders
FullAdder1bit adder0(sum[0], adder0_cout, a[0], b[0], 0); // First addition operation has no carryin
FullAdder1bit adder1(sum[1], adder1_cout, a[1], b[1], adder0_cout);
FullAdder1bit adder2(sum[2], adder2_cout, a[2], b[2], adder1_cout);
FullAdder1bit adder3(sum[3], adder3_cout, a[3], b[3], adder2_cout);

// If the adder3 carryin != adder3 carryout, there is an overflow error
`XNOR overflowxnor (overflow, adder2_cout, adder3_cout);

endmodule

module testFullAdder1bit;
reg a, b, carryin;
wire str_sum, str_carryout;
wire beh_sum, beh_carryout;
FullAdder1bit str_adder(str_sum, str_carryout, a, b, carryin);

initial begin
// Begin Combined Testbench
// Completely test behavioral and structural adders
$display(" Inputs  | Structural | Expected");
$display("A B C_In | Sum C_Out  |Sum C_Out");
// At most, signal travels through 3 gates. Set durations to a bit over 3 times the gate delay.
carryin=0;a=0;b=0; #175 
$display("%b %b %b    |  %b  %b      | 0   0", a, b, carryin, str_sum, str_carryout);
carryin=1;a=0;b=0; #175 
$display("%b %b %b    |  %b  %b      | 1   0", a, b, carryin, str_sum, str_carryout);
carryin=0;a=0;b=1; #175 
$display("%b %b %b    |  %b  %b      | 1   0", a, b, carryin, str_sum, str_carryout);
carryin=1;a=0;b=1; #175 
$display("%b %b %b    |  %b  %b      | 0   1", a, b, carryin, str_sum, str_carryout);
carryin=0;a=1;b=0; #175 
$display("%b %b %b    |  %b  %b      | 1   0", a, b, carryin, str_sum, str_carryout);
carryin=1;a=1;b=0; #175 
$display("%b %b %b    |  %b  %b      | 0   1", a, b, carryin, str_sum, str_carryout);
carryin=0;a=1;b=1; #175 
$display("%b %b %b    |  %b  %b      | 0   1", a, b, carryin, str_sum, str_carryout);
carryin=1;a=1;b=1; #175 
$display("%b %b %b    |  %b  %b      | 1   1", a, b, carryin, str_sum, str_carryout);
// Reference truth table verified from
// http://www.electronicshub.org/wp-content/uploads/2014/08/Truth-Table-for-Full-Adder.jpg
end
endmodule
