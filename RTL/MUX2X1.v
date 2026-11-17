module MUX2X1 (
    input [31:0] IN_0,
    input [31:0] IN_1,
    input SEL,
    output [31:0] OUT
);

assign OUT = (SEL)? IN_1 : IN_0;
    
endmodule
