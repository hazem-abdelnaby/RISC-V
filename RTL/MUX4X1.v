module MUX4X1 (
    input [31:0] IN_0,
    input [31:0] IN_1,
    input [31:0] IN_2,
    input [31:0] IN_3,
    input [1:0] SEL,
    output reg [31:0] OUT
);
always @(*)
begin
    case (SEL)
        2'b00: OUT = IN_0;
        2'b01: OUT = IN_1;
        2'b10: OUT = IN_2;
        2'b11: OUT = IN_3;
        default: OUT = 32'b0;
    endcase
end
    
endmodule
