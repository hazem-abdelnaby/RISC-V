module RegFile (
    input CLK,
    input RST,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    input WriteEn,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
);
integer i;

reg [31:0] RegisterFile [0:31];

always @(*)
begin
    ReadData1=(ReadReg1 == 5'd0)? 32'd0:RegisterFile[ReadReg1];
    ReadData2=(ReadReg2 == 5'd0)? 32'd0:RegisterFile[ReadReg2];
end


always @(posedge CLK or negedge RST) begin
    if (!RST) 
    begin
        for (i = 0; i < 32; i = i + 1) 
        begin
            RegisterFile[i] <= 32'd0;
        end
    end 
    else if (WriteEn && WriteReg != 5'd0) 
    begin
        RegisterFile[WriteReg] <= WriteData;
    end
end

endmodule
