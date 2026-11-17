module Control_Unit  (
    input [6:0] Op,
    input [2:0] Funct3,
    input Funct7,
    input Zero,
    output reg [1:0] ImmSrc,
    output reg ALUSrc,
    output reg [1:0] ResultSrc,
    output reg PCSrc,
    output reg MemWrite,
    output reg [2:0] ALUControl,
    output reg RegWrite
);

localparam R_TYPE = 7'b0110011;
localparam I_TYPE = 7'b0010011;
localparam LW = 7'b0000011;
localparam SW = 7'b0100011;
localparam BEQ = 7'b1100011;
localparam JAL = 7'b1101111;

always @(*) 
begin
    ImmSrc = 2'b00;
    ALUSrc = 1'b0;
    ResultSrc = 2'b00;
    PCSrc = 1'b0;
    MemWrite = 1'b0;
    RegWrite = 1'b0;
    ALUControl =3'b000;
    case (Op)
        R_TYPE: begin
            ALUSrc = 1'b0;
            ResultSrc = 2'b00;
            RegWrite = 1'b1;
            case ({Funct7, Funct3})
                4'b0000: ALUControl = 3'b000; 
                4'b1000: ALUControl = 3'b001;
                4'b0111: ALUControl = 3'b010;
                4'b0110: ALUControl = 3'b011;
                4'b0010: ALUControl = 3'b101;
                default: ALUControl = 3'b000;
            endcase
        end
        I_TYPE: 
        begin
            ALUSrc = 1'b1;
            ResultSrc = 2'b00;
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
        end
        LW: begin
            ALUSrc = 1'b1;
            ResultSrc = 2'b01;
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            ALUControl = 3'b000;
        end
        SW: begin
            ALUSrc = 1'b1;
            MemWrite = 1'b1;
            ImmSrc = 2'b01;
            ALUControl = 3'b000;
        end
        BEQ: begin
            ALUSrc = 1'b0;
            PCSrc = Zero;
            ImmSrc = 2'b10;
            ALUControl = 3'b001;
        end
        JAL: 
        begin
            PCSrc = 1'b1;
            RegWrite = 1'b1;
            ImmSrc = 2'b11;
            ResultSrc = 2'b10;
        end
        default: 
        begin
            ImmSrc = 2'b00;
            ALUSrc = 1'b0;
            ResultSrc = 2'b00;
            PCSrc = 1'b0;
            MemWrite = 1'b0;
            RegWrite = 1'b0;
            ALUControl = 3'b000;
        end
    endcase
end
    
endmodule
