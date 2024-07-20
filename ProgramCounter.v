//? Program Counter that supports increments and direct assignment.
module ProgramCounter #(
    parameter WIDTH = 11
) (
    input                clk,
    input                rst,
    input                load_pc,  //? Load PC signal
    input                inc_pc,   //? Increment PC signal
    input      [WIDTH:0] pc_val,   //? PC Load Value
    output reg [WIDTH:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst == 1) begin
            pc <= 0;
        end else begin
            if (load_pc == 1) begin
                pc <= pc_val;
            end else if (inc_pc == 1) begin
                pc <= pc + 1;
            end
        end
    end
endmodule
