// define gates with delays
`define AND and #50
`define OR or #50
`define NOT not #50
`define XOR xor #50
`define XNOR xnor #50

module behavioralDecoder(out0, out1, out2, out3, address0, address1, enable);
output out0, out1, out2, out3;
input address0, address1;
input enable;
assign {out3,out2,out1,out0}=enable<<{address1,address0};
endmodule

module structuralDecoder(out0, out1, out2, out3, address0, address1, enable);
output out0, out1, out2, out3;
input address0, address1;
input enable;
// Surpise! This looks suspiciously similar to a mux. 
`NOT not0(naddr0, address0);
`NOT not1(naddr1, address1);

`AND and0(out0, enable, naddr0, naddr1); // Woo, three input ANDs!
`AND and1(out1, enable, address0, naddr1); 
`AND and2(out2, enable, naddr0, address1); 
`AND and3(out3, enable, address0, address1);
endmodule

module testDecoder; 
reg addr0, addr1;
reg enable;
wire beh_out0, beh_out1, beh_out2, beh_out3;
wire str_out0, str_out1, str_out2, str_out3;
behavioralDecoder beh_decoder (beh_out0, beh_out1, beh_out2, beh_out3, addr0, addr1, enable);
structuralDecoder str_decoder (str_out0, str_out1, str_out2, str_out3, addr0, addr1, enable); // Swap after testing

initial begin
$display(" Inputs | Behavioral  | Structural  | Expected");
$display("En A0 A1| O0 O1 O2 O3 | O0 O1 O2 O3 | Outputs ");
enable=0;addr0=0;addr1=0; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, beh_out0, beh_out1, beh_out2, beh_out3,  str_out0, str_out1, str_out2, str_out3);
enable=0;addr0=1;addr1=0; #1000
$display("%b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, beh_out0, beh_out1, beh_out2, beh_out3,  str_out0, str_out1, str_out2, str_out3);
enable=0;addr0=0;addr1=1; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, beh_out0, beh_out1, beh_out2, beh_out3,  str_out0, str_out1, str_out2, str_out3);
enable=0;addr0=1;addr1=1; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, beh_out0, beh_out1, beh_out2, beh_out3,  str_out0, str_out1, str_out2, str_out3);
enable=1;addr0=0;addr1=0; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b | O0 Only", enable, addr0, addr1, beh_out0, beh_out1, beh_out2, beh_out3,  str_out0, str_out1, str_out2, str_out3);
enable=1;addr0=1;addr1=0; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b | O1 Only", enable, addr0, addr1, beh_out0, beh_out1, beh_out2, beh_out3,  str_out0, str_out1, str_out2, str_out3);
enable=1;addr0=0;addr1=1; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b | O2 Only", enable, addr0, addr1, beh_out0, beh_out1, beh_out2, beh_out3,  str_out0, str_out1, str_out2, str_out3);
enable=1;addr0=1;addr1=1; #1000 
$display("%b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b | O3 Only", enable, addr0, addr1, beh_out0, beh_out1, beh_out2, beh_out3,  str_out0, str_out1, str_out2, str_out3);
end
endmodule
