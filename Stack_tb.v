`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"Stack_tb.vcd`"

module Stack_tb ();

    localparam WIDTH = 16;

    reg clk = 0;
    reg push_sig = 0;
    reg [2:0] pop_sig = 0;
    reg [WIDTH:0] stack_in = 0;
    wire [WIDTH:0] stack_preview0;
    wire [WIDTH:0] stack_preview1;

    // generate 12 MHz clock signal (period = 83.33 ns)
    localparam CLK_PERIOD = 83.33;
    always begin
        #(CLK_PERIOD / 2) clk <= ~clk;
    end

    // run simulation
    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, Stack_tb);

        // Test 1 - read from the stack and assert zero
        #(CLK_PERIOD)

        if (stack_preview0 !== 0) begin
            $display("Test 1 failed: stack_preview0 != 0, = %d", stack_preview0);
            // $fatal;
        end

        if (stack_preview1 !== 0) begin
            $display("Test 1 failed: stack_preview1 != 0, = %d", stack_preview1);
            // $fatal;
        end

        // Test 2 - push three values onto the stack and read the top two values
        push_sig <= 1;
        stack_in <= 1;
        #(CLK_PERIOD) push_sig <= 0;
        #(CLK_PERIOD) push_sig <= 1;
        stack_in <= 2;
        #(CLK_PERIOD) push_sig <= 0;
        #(CLK_PERIOD) push_sig <= 1;
        stack_in <= 3;
        #(CLK_PERIOD) push_sig <= 0;
        #(CLK_PERIOD)

        if (stack_preview0 !== 3) begin
            $display("Test 2 failed: stack_preview0 != 3, = %d", stack_preview0);
            // $fatal;
        end

        if (stack_preview1 !== 2) begin
            $display("Test 2 failed: stack_preview1 != 2, = %d", stack_preview1);
            // $fatal;
        end

        // Test 3 - pop the top value from the stack and read the top two values
        push_sig <= 0;
        pop_sig  <= 1;
        #(CLK_PERIOD) pop_sig <= 0;
        #(CLK_PERIOD)

        if (stack_preview0 !== 2) begin
            $display("Test 3 failed: stack_preview0 != 2, = %d", stack_preview0);
            // $fatal;
        end

        if (stack_preview1 !== 1) begin
            $display("Test 3 failed: stack_preview1 != 1, = %d", stack_preview1);
            // $fatal;
        end

        // Test 4 - pop remaining two values from the stack and read the top two values
        pop_sig <= 2;
        #(CLK_PERIOD) pop_sig <= 0;
        #(CLK_PERIOD)

        if (stack_preview0 !== 0) begin
            $display("Test 4 failed: stack_preview0 != 0, = %d", stack_preview0);
            // $fatal;
        end

        if (stack_preview1 !== 0) begin
            $display("Test 4 failed: stack_preview1 != 0, = %d", stack_preview1);
            // $fatal;
        end

        // Tests complete
        #(10 * CLK_PERIOD) $display("Finished!");
        $finish;
    end

    Stack #(
        .DEPTH(127),
        .WIDTH(WIDTH)
    ) stack (
        .clk(clk),
        .push(push_sig),
        .pop(pop_sig),
        .push_data(stack_in),
        .preview0(stack_preview0),
        .preview1(stack_preview1)
    );

endmodule
