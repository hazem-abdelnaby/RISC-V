module Instruction_MEM (
    input [31:0] pc,
    output reg [31:0] Instr
);
reg [31:0] memory [0:255];

always @(*) 
begin
    Instr = memory[pc[9:2]];
end

endmodule
