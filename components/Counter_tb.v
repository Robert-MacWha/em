`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"Counter_tb.vcd`"

module Counter_tb ();

    localparam WIDTH = 11;

    reg clk = 0;
    reg rst = 0;
    reg load_pc = 0;
    reg inc_pc = 0;
    reg [WIDTH : 0] pc_val = 0;
    wire [WIDTH:0] pc;

    // generate 12 mHz clock signal (1 / (2 * 41.67) * 1ns) = 11,999,040.08 mHz
    localparam DURATION = 1_000;
    localparam CLK_FREQUENCY = 41.67;
    always begin
        #(CLK_FREQUENCY) clk <= ~clk;
    end

    // run simulation
    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, Counter_tb);

        rst <= 1;
        #(CLK_FREQUENCY) rst <= 0;

        // Test 1 - set inc_PC to 1 and make sure the program counter increases
        inc_pc <= 1;
        #(8 * CLK_FREQUENCY)

        if (pc != 4) begin
            $display("Test 1 failed: pc != 4, pc = %d", pc);
            $fatal;
        end else begin
            $display("Test 1 passed: pc = %d", pc);
        end

        // Test 2 - set load_pc to 1 and assign a value with pc_val
        load_pc <= 1;
        pc_val  <= 261;
        #(4 * CLK_FREQUENCY)

        if (pc !== 261) begin
            $display("Test 2 failed: pc != 261, pc = %d", pc);
            $fatal;
        end else begin
            $display("Test 2 passed: pc = %d", pc);
        end

        // Tests complete
        #(DURATION) $display("Finished!");
        $finish;
    end

    Counter #(
        .WIDTH(WIDTH)
    ) programCounter (
        .clk(clk),
        .rst(rst),
        .load_sig(load_pc),
        .inc_sig(inc_pc),
        .load_val(pc_val),
        .ctr(pc)
    );

endmodule
