
// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end

endmodule

module register32(q, d, wrenable, clk);

parameter SIZE = 32; // SIZE is the size (in bits) of the register. 
                     // For example, N=32 corresponds to a 32-bit register.
output reg[SIZE-1:0] q;
input[SIZE-1:0] d;
input wrenable;
input clk;

generate
    genvar i; // instantiate variable for generate sequence
    for (i=0; i<SIZE; i=i+1) begin
        always @(posedge clk) begin
            if(wrenable) begin
                q[i] = d[i];
            end
        end
    end
endgenerate

endmodule

module register32zero(q, d, wrenable, clk);
parameter SIZE = 32; // SIZE is the size (in bits) of the register. 
                     // For example, N=32 corresponds to a 32-bit register.
output reg[SIZE-1:0] q;
input[SIZE-1:0] d;
input wrenable;
input clk;
    always @(posedge clk) begin
        q = {SIZE{1'b0}};
    end
endmodule


module mux32to1by1
(
output      out,
input[4:0]  address,
input[31:0] inputs
);

assign out=inputs[address];
endmodule

module test_mux32;
wire        out;
reg[4:0]    address;
reg[31:0]   inputs;
mux32to1by1 testMUX(out, address, inputs);
initial begin
// Can I select an input?
$display("      Inputs                               | Expected | Measured |");
$display("address | inputs                           | output   | output   |");

// Add d1 + d1
inputs = 32'b00000000000000000000000000000001; address=5'd0; #5000
$display("%b   | %b | %b        | %b        |", address, inputs, 1'd1, out);

inputs = 32'b01111111111111111111111111111111; address=5'd31; #5000
$display("%b   | %b | %b        | %b        |", address, inputs, 1'd0, out);

inputs = 32'b00000000000000010000000000000000; address=5'd16; #5000
$display("%b   | %b | %b        | %b        |", address, inputs, 1'd1, out);
end
endmodule


module mux32to1by32
(
output[31:0]    out,
input[4:0]      address,
input[31:0]     input31, input30, input29, input28, input27, input26, input25, input24, input23, input22, input21, input20, input19, input18, input17, input16, input15, input14, input13, input12, input11, input10, input9, input8, input7, input6, input5, input4, input3, input2, input1, input0
);

  wire[31:0] mux[31:0];         // Create a 2D array of wires
  assign mux[31] = input31;
  assign mux[30] = input30;
  assign mux[29] = input29;
  assign mux[28] = input28;
  assign mux[27] = input27;
  assign mux[26] = input26;
  assign mux[25] = input25;
  assign mux[24] = input24;
  assign mux[23] = input23;
  assign mux[22] = input22;
  assign mux[21] = input21;
  assign mux[20] = input20;
  assign mux[19] = input19;
  assign mux[18] = input18;
  assign mux[17] = input17;
  assign mux[16] = input16;
  assign mux[15] = input15;
  assign mux[14] = input14;
  assign mux[13] = input13;
  assign mux[12] = input12;
  assign mux[11] = input11;
  assign mux[10] = input10;
  assign mux[9] = input9;
  assign mux[8] = input8;
  assign mux[7] = input7;
  assign mux[6] = input6;
  assign mux[5] = input5;
  assign mux[4] = input4;
  assign mux[3] = input3;
  assign mux[2] = input2;
  assign mux[1] = input1;
  assign mux[0] = input0;
  assign out = mux[address];    // Connect the output of the array
endmodule


module decoder1to32
(
output[31:0]    out,
input           enable,
input[4:0]      address
);
    assign out = enable<<address; 
endmodule