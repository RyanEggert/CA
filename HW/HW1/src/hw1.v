module hw1test;
//initial begin
//$display("Hello, CompArch!");
//end

// Global Signals
reg A;
reg B;
wire nA;
wire nB;
not G_I1(nA, A);
not G_I2(nB, B);

// 1. ~(AB)
wire W_1_AB;
wire W_1_out;
and GT_1_A1(W_1_AB, A, B);
not GT_1_I1(W_1_out, W_1_AB);

// 2. ~A + ~B
wire W_2_out;
or GT_2_O1(W_2_out, nA, nB);

// 3. ~(A + B)
wire W_3_AorB;
wire W_3_out;
or GT_3_O1(W_3_AorB, A, B);
not GT_3I1(W_3_out, W_3_AorB);

// 4. ~A * ~B
wire W_4_out;
and GT_4_A1(W_4_out, nA, nB);

initial begin
$display("Two-Variable DeMorgan's Law Exhaustive Proof");
$display("A B | ~(AB) | ~A+~B | ~(A+B) | ~A~B | "); // Prints header for truth table
A=0;B=0; #1 // Set A and B, wait for update (#1)
$display("%b %b |     %b |     %b |      %b |    %b |", A, B, W_1_out, W_2_out, W_3_out, W_4_out);
A=0;B=1; #1 // Set A and B, wait for new update
$display("%b %b |     %b |     %b |      %b |    %b |", A, B, W_1_out, W_2_out, W_3_out, W_4_out);
A=1;B=0; #1
$display("%b %b |     %b |     %b |      %b |    %b |", A, B, W_1_out, W_2_out, W_3_out, W_4_out);
A=1;B=1; #1
$display("%b %b |     %b |     %b |      %b |    %b |", A, B, W_1_out, W_2_out, W_3_out, W_4_out);
end

endmodule
