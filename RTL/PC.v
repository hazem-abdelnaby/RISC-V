module PC (
    input CLK,
    input RST,
    input [31:0] ImmExt,
    input PCSrc,
    output reg [31:0] pc,
    output wire [31:0] PCPlus4
);

reg [31:0] PCTarget;
reg [31:0] next_pc;

assign PCPlus4 = pc + 32'd4;

always @(*) begin
    PCTarget = pc + ImmExt;
end

always @(*) begin
    if (PCSrc)
        next_pc = PCTarget;
    else
        next_pc = PCPlus4;
end

always @(posedge CLK or negedge RST) begin
    if (!RST)
        pc <= 32'b0;
    else
        pc <= next_pc;
end

endmodule