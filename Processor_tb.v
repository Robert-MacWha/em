`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"Processor_tb.vcd`"

module Processor_tb ();

    reg clk = 0;
    reg rst = 0;

    // generate 12 mHz clock signal (1 / (2 * 41.67) * 1ns) = 11,999,040.08 mHz
    localparam DURATION = 300;
    localparam CLK_FREQUENCY = 10;
    always begin
        #(CLK_FREQUENCY) clk <= ~clk;
    end

    // run simulation
    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, Processor_tb);

        $display("Starting simulation...");

        // rst <= 1;
        // #(CLK_FREQUENCY * 2) rst <= 0;

        // Tests complete
        #(CLK_FREQUENCY * DURATION) $display("Finished!");
        $finish;
    end

    Processor processor (
        .clk(clk),
        .rst(rst)
    );

endmodule
