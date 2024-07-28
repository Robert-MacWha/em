module Stack #(
    parameter DEPTH = 127,  //? Number of stack elements.
    parameter WIDTH = 31    //? Width of a stack element.
) (
    input clk,
    input push,  //? Push signal. Takes priority over pop signal.
    input [WIDTH:0] push_data,
    input [2:0] pop,  //? Pop amount. Supports popping up to 8 elements per clock cycle.
    output [WIDTH:0] preview0,  //? Preview the top element of the stack.
    output [WIDTH:0] preview1  //? Preview the second top element of the stack.
);
    // stack_ptr points to the next free stack index.
    reg [$clog2(DEPTH):0] stack_ptr = 0;
    reg [WIDTH:0] stack[DEPTH:0];

    // Update the stack based on push or pop signals.
    always @(posedge clk) begin
        if ((push == 1) && (stack_ptr < DEPTH)) begin  // TODO: Handle overflow
            stack[stack_ptr] <= push_data;
            stack_ptr <= stack_ptr + 1;
        end else if (stack_ptr >= pop) begin  // TODO: Handle underflow
            stack_ptr <= stack_ptr - pop;
        end
    end

    // Assign the top two elements of the stack to the preview outputs
    assign preview0 = (stack_ptr > 0) ? stack[stack_ptr-1] : 0;
    assign preview1 = (stack_ptr > 1) ? stack[stack_ptr-2] : 0;

endmodule
