module RISC_SC(
    input CLK,
    input RST,
    output [31:0] PC
);

wire [31:0] Instruction;
wire [31:0] ImmExt;
wire [31:0] ReadData;
wire [31:0] ALUResult;
wire [31:0] ReadData1;
wire [31:0] ReadData2;
wire [31:0] ALUInput2;
wire [31:0] PCPlus4;
wire [31:0] result;

wire [4:0] WriteReg;
wire [2:0] ALUControl;
wire [1:0] ImmSrc;
wire [1:0] ResultSrc;

wire ALUSrc;
wire RegWrite;
wire MemWrite;
wire PCSrc;
wire Zero;

assign WriteReg = Instruction[11:7];

Control_Unit U0 (
    .Op(Instruction[6:0]),
    .Funct3(Instruction[14:12]),
    .Funct7(Instruction[30]),
    .Zero(Zero),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .ResultSrc(ResultSrc),
    .PCSrc(PCSrc),
    .MemWrite(MemWrite),
    .ALUControl(ALUControl),
    .RegWrite(RegWrite)
);

Extend U1 (
    .Instr(Instruction),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
);
ALU U2 (
    .A(ReadData1),
    .B(ALUInput2),
    .ALU_Control(ALUControl),
    .Y(ALUResult),
    .zero(Zero)
);

RegFile U3 (
    .CLK(CLK),
    .RST(RST),
    .ReadReg1(Instruction[19:15]),
    .ReadReg2(Instruction[24:20]),
    .WriteReg(WriteReg),
    .WriteData(result),
    .WriteEn(RegWrite),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

PC U4 (
    .CLK(CLK),
    .RST(RST),
    .ImmExt(ImmExt),
    .PCSrc(PCSrc),
    .pc(PC),
    .PCPlus4(PCPlus4)
);

Instruction_MEM U5 (
    .pc(PC),
    .Instr(Instruction)
);

Data_MEM U6 (
    .CLK(CLK),
    .MemWrite(MemWrite),
    .A(ALUResult),
    .WriteData(ReadData2),
    .ReadData(ReadData)
);

MUX4X1 U7 (
    .IN_0(ALUResult),
    .IN_1(ReadData),
    .IN_2(PCPlus4),
    .IN_3(32'd0),
    .SEL(ResultSrc),
    .OUT(result)
);

MUX2X1 U8 (
    .IN_0(ReadData2),
    .IN_1(ImmExt),
    .SEL(ALUSrc),
    .OUT(ALUInput2)
);

endmodule