module ROM #(
    parameter INIT_FILE = "",
    parameter WIDTH = 15,  //? Width of a single rom word in bits.
    parameter DEPTH = 1023,  //? Maximum number of words in the rom.
    parameter PREVIEW_DEPTH = 31  //? Number of words to preview.
) (
    input                                         clk,
    input       [                $clog2(DEPTH):0] addr,
    output reg  [                        WIDTH:0] data,
    output wire [(PREVIEW_DEPTH+1)*(WIDTH+1)-1:0] preview
);
    reg [WIDTH:0] rom[DEPTH:0];

    always @(posedge clk) begin
        data <= rom[addr];
    end

    // Initialize memory
    initial begin
        if (INIT_FILE != "") begin
            $readmemb(INIT_FILE, rom);
        end
    end

    // Generate block to create continuous assignments for preview
    genvar i;
    generate
        for (i = 0; i <= PREVIEW_DEPTH; i = i + 1) begin : gen_preview
            assign preview[(i+1)*(WIDTH+1)-1:i*(WIDTH+1)] = ((addr + i) <= DEPTH) ? rom[addr+i] : 0;
        end
    endgenerate
endmodule
