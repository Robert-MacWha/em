module Processor (
    input clk,
    input rst
);
    localparam OPCODE_WIDTH = 15;
    localparam OPCODE_DEPTH = 1023;
    localparam OPCODE_DEPTH_LOG2 = $clog2(OPCODE_DEPTH);
    localparam STACK_WIDTH = 255;
    localparam STACK_DEPTH = 127;
    localparam STACK_PREVIEW_DEPTH = 1;

    // * Architecture
    // Program Counter
    wire pc_load_sig;
    wire pc_inc_sig;
    wire [OPCODE_DEPTH_LOG2:0] pc_load_val;
    wire [OPCODE_DEPTH_LOG2:0] pc;

    // ROM
    wire [OPCODE_WIDTH:0] rom_data;  //? Data read from the ROM for the current pc

    // STACK
    wire stack_push_sig;
    wire [STACK_WIDTH:0] stack_push_data;
    wire [2:0] stack_pop_sig;
    wire [0:STACK_WIDTH] stack_preview[STACK_PREVIEW_DEPTH:0];

    //* Modules
    ProgramCounter #(
        .WIDTH(OPCODE_DEPTH_LOG2)
    ) progCtr (
        .clk(clk),
        .rst(rst),
        .load_pc(pc_load_sig),
        .inc_pc(pc_inc_sig),
        .pc_val(pc_load_val),
        .pc(pc)
    );

    ROM #(
        .WIDTH(OPCODE_WIDTH),
        .DEPTH(OPCODE_DEPTH)
    ) rom (
        .clk (clk),
        .addr(pc),
        .data(rom_data)
    );

    STACK #(
        .WIDTH(STACK_WIDTH),
        .DEPTH(STACK_DEPTH),
        .PREVIEW_DEPTH(STACK_PREVIEW_DEPTH)
    ) stack (
        .clk(clk),
        .push(stack_push_sig),
        .push_data(stack_push_data),
        .pop(stack_pop_sig),
        .preview(stack_preview)
    );

endmodule
