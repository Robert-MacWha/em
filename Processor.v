`include "Opcodes.vh"

module Processor (
    input clk,
    input rst
);
    localparam ROM_FILE = "test.hex";
    localparam OPCODE_WIDTH = 7;
    localparam OPCODE_DEPTH = 1023;
    localparam OPCODE_DEPTH_BITS = $clog2(OPCODE_DEPTH);
    localparam STACK_WIDTH = 16;
    localparam STACK_DEPTH = 31;
    localparam STACK_DEPTH_BITS = $clog2(STACK_DEPTH);

    //* Memories
    reg [STACK_WIDTH:0] stack[0:STACK_DEPTH];
    reg [OPCODE_WIDTH:0] rom[0:OPCODE_DEPTH];

    //* Internal Registers
    reg [OPCODE_DEPTH_BITS:0] pc = 0;
    reg [OPCODE_DEPTH_BITS:0] pc_next = 0;
    reg [STACK_DEPTH_BITS:0] stack_ptr = 0;
    reg [STACK_DEPTH_BITS:0] stack_ptr_next = 0;
    wire [OPCODE_WIDTH:0] opcode;

    // frequently used inputs
    wire [STACK_WIDTH:0] stack0;
    wire [STACK_WIDTH:0] stack1;

    assign stack0 = (stack_ptr > 0) ? stack[stack_ptr-1] : 0;
    assign stack1 = (stack_ptr > 1) ? stack[stack_ptr-2] : 0;
    assign opcode = rom[pc];

    // load ROM
    initial $readmemh(ROM_FILE, rom);

    //* Tracing
    task undefined;
        begin
            $display("undefined ");
            $display("HALTED");
            $finish;
        end
    endtask

    task stop;
        begin
            $display("STOP");
            $finish;
        end
    endtask

    //* Instruction decoding - Stack
    // TODO: Add underflow checks
    always @(pc) begin
        case (opcode)
            `STOP:   stop;
            `ADD: begin
                stack[stack_ptr-2] <= stack0 + stack1;
                stack_ptr_next <= stack_ptr - 1;
                $display("ADD: %h + %h = %h", stack0, stack1, stack0 + stack1);
            end
            `MUL: begin
                stack[stack_ptr-2] <= stack0 * stack1;
                stack_ptr_next <= stack_ptr - 1;
                $display("MUL: %h * %h = %h", stack0, stack1, stack0 * stack1);
            end
            `LT: begin
                stack[stack_ptr-2] <= stack0 < stack1;
                stack_ptr_next <= stack_ptr - 1;
                $display("LT: %h < %h = %h", stack0, stack1, stack0 < stack1);
            end
            `EQ: begin
                stack[stack_ptr-2] <= stack0 == stack1;
                stack_ptr_next <= stack_ptr - 1;
                $display("EQ: %h == %h = %h", stack0, stack1, stack0 == stack1);
            end
            `ISZERO: begin
                stack[stack_ptr-1] <= stack0 == 0;
                $display("ISZERO: %h == 0 = %h", stack0, stack0 == 0);
            end
            `POP: begin
                stack_ptr_next <= stack_ptr - 1;
                $display("POP: %h", stack0);
            end
            `JUMPI: begin
                stack_ptr_next <= stack_ptr - 2;
                $display("JUMPI: %h if %h", stack0, stack1);
            end
            `PUSH0: begin
                stack[stack_ptr] <= 0;
                stack_ptr_next   <= stack_ptr + 1;
                $display("PUSH0: 0");
            end
            `PUSH1: begin
                stack[stack_ptr] <= rom[pc+1];
                stack_ptr_next   <= stack_ptr + 1;
                $display("PUSH1: %h", rom[pc+1]);
            end
            `DUP1: begin
                stack[stack_ptr] <= stack0;
                stack_ptr_next   <= stack_ptr + 1;
                $display("DUP1: %h", stack0);
            end
            default: undefined;
        endcase

        case (opcode)
            `JUMPI:  pc_next <= (stack1) ? stack0 : pc + 1;
            `PUSH1:  pc_next <= pc + 2;
            default: pc_next <= pc + 1;
        endcase
    end

    //* Clock
    always @(posedge clk) begin
        if (rst) begin
            stack_ptr = 0;
            pc = 0;
        end else begin
            stack_ptr = stack_ptr_next;
            pc = pc_next;
        end
    end
endmodule
