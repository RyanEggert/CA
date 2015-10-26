
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
