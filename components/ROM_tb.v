`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"ROM_tb.vcd`"

module ROM_tb ();
    localparam SELECT_WIDTH = 4;
    localparam REG_WIDTH = 8;

    reg clk = 0;
    reg [10:0] addr = 0;
    wire [15:0] data;

    localparam DURATION = 10_000;
    localparam CLK_FREQUENCY = 41.67;

    // generate 12 mHz clock signal (1 / (2 * 41.67) * 1ns) = 11,999,040.08 mHz
    always begin
        #(CLK_FREQUENCY) clk <= ~clk;
    end

    // run simulation
    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, ROM_tb);

        // Test 1 - load addr 0
        addr <= 0;
        #(CLK_FREQUENCY * 2)
        if (data !== 16'b0111000100000000) begin
            $display("Test 1 failed: data != 'b0111000100000000, data = %d", data);
            $fatal;
        end else begin
            $display("Test 1 passed: data = %d", data);
        end

        // Test 2 - load addr 1
        addr <= 1;
        #(CLK_FREQUENCY * 2)
        if (data !== 16'b0111000100000011) begin
            $display("Test 2 failed: data != 'b0111000100000011, data = %d", data);
            $fatal;
        end else begin
            $display("Test 2 passed: data = %d", data);
        end


        // Tests complete
        #(DURATION) $display("Finished!");
        $finish;
    end

    ROM #(
        .INIT_FILE("ROM_tb.mem")
    ) rom (
        .clk (clk),
        .addr(addr),
        .data(data)
    );

endmodule
