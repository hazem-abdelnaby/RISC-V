module ALU (
    input [31:0] A, B,
    input [2:0] ALU_Control,
    output reg [31:0] Y,
    output zero
);

always @(*) 
begin
    case (ALU_Control)
        3'b000: Y = A + B;
        3'b001: Y = A - B;
        3'b010: Y = A & B;
        3'b011: Y = A | B;
        3'b101: Y = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
        default: Y = 32'd0;
    endcase
    
end

assign zero =(Y==32'b0)? 1'b1:1'b0; 
endmodule
