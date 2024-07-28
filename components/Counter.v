//? Counter that supports increments and direct assignment.
module Counter #(
    parameter WIDTH = 11
) (
    input                clk,
    input                rst,
    input                load_sig,  //? Load signal
    input                inc_sig,   //? Increment signal
    input      [WIDTH:0] load_val,  //? Load Value
    output reg [WIDTH:0] ctr
);
    always @(posedge clk or posedge rst) begin
        if (rst == 1) begin
            ctr <= 0;
        end else begin
            if (load_sig == 1) begin
                ctr <= load_val;
            end else if (inc_sig == 1) begin
                ctr <= ctr + 1;
            end
        end
    end
endmodule
