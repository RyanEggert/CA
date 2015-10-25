
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