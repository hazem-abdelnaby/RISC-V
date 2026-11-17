`timescale 1ns / 1ps

module RISC_SC_tb;

reg CLK;
reg RST;
wire [31:0] PC;

integer errors;

RISC_SC dut (
    .CLK(CLK),
    .RST(RST),
    .PC(PC)
);

always #5 CLK = ~CLK;

initial 
begin
    $dumpfile("RISC_SC_tb.vcd");
    $dumpvars();
    CLK = 1'b0;
    errors = 0;

    dut.U5.memory[0]  = 32'h00500113;
    dut.U5.memory[1]  = 32'h00C00193;
    dut.U5.memory[2]  = 32'hFF718393;
    dut.U5.memory[3]  = 32'h0023E233;
    dut.U5.memory[4]  = 32'h0041F2B3;
    dut.U5.memory[5]  = 32'h004282B3;
    dut.U5.memory[6]  = 32'h02728863;
    dut.U5.memory[7]  = 32'h0041A233;
    dut.U5.memory[8]  = 32'h00020463;
    dut.U5.memory[9]  = 32'h00000293;
    dut.U5.memory[10] = 32'h0023A233;
    dut.U5.memory[11] = 32'h005203B3;
    dut.U5.memory[12] = 32'h402383B3;
    dut.U5.memory[13] = 32'h0471AA23;
    dut.U5.memory[14] = 32'h06002103;
    dut.U5.memory[15] = 32'h005104B3;
    dut.U5.memory[16] = 32'h008001EF;
    dut.U5.memory[17] = 32'h00100113;
    dut.U5.memory[18] = 32'h00910133;
    dut.U5.memory[19] = 32'h0221A023;
    dut.U5.memory[20] = 32'h00210063;

    RST = 1'b0;
    #20;
    RST = 1'b1;

    #500;
    
    $display("---- Final PC ----");
    if (PC === 32'h50)
        $display("PASS: PC = 0x%h (stuck in done loop)", PC);
    else begin
        $display("FAIL: PC = 0x%h (expected 0x50)", PC);
        errors = errors + 1;
    end

    $display("---- Register checks ----");
    check_reg(5'd2, 32'd25);
    check_reg(5'd3, 32'd68);
    check_reg(5'd4, 32'd1);
    check_reg(5'd5, 32'd11);
    check_reg(5'd7, 32'd7);
    check_reg(5'd9, 32'd18);

    $display("---- Memory checks ----");
    check_mem(8'd24, 32'd7);
    check_mem(8'd25, 32'd25);

    if (errors == 0)
        $display("RISC-V test passed.");
    else
        $display("RISC-V test FAILED with %0d error(s).", errors);

    $stop;
end
task check_mem;
    input [7:0]  word_index;
    input [31:0] expected;
    begin
        if (dut.U6.memory[word_index] === expected)
            $display("PASS: memory[%0d] (byte addr %0d) = %0d", word_index, word_index*4, dut.U6.memory[word_index]);
        else begin
            $display("FAIL: memory[%0d] (byte addr %0d) = %0d (expected %0d)",
                     word_index, word_index*4, dut.U6.memory[word_index], expected);
            errors = errors + 1;
        end
    end
endtask


task check_reg;
    input [4:0]  n;
    input [31:0] expected;
    begin
        if (dut.U3.RegisterFile[n] === expected)
            $display("PASS: x%0d = %0d", n, dut.U3.RegisterFile[n]);
        else begin
            $display("FAIL: x%0d = %0d (expected %0d)", n, dut.U3.RegisterFile[n], expected);
            errors = errors + 1;
        end
    end
endtask

always @(posedge CLK) begin
    if (RST)
        $display("t=%0t  PC=0x%h  Instr=0x%h", $time, PC, dut.Instruction);
end

endmodule