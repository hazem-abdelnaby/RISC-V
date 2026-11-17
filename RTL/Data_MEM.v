module Data_MEM (
    input CLK,
    input MemWrite,
    input [31:0] A,
    input [31:0] WriteData,
    output reg [31:0] ReadData
);

reg [31:0] memory [0:255];

always @(*) begin
    ReadData = memory[A[9:2]];
end

always @(posedge CLK) begin
    if (MemWrite)
        memory[A[9:2]] <= WriteData;
end

endmodule