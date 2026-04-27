module ahb_system_dut(
    input  logic        clk,
    input  logic [3:0]  HADDR,
    input  logic [7:0]  HWDATA,
    input  logic        HWRITE,
    input  logic [1:0]  HTRANS,
    input  logic        HSEL,
    output logic [7:0]  HRDATA
);

    logic [7:0] mem [0:15];

    always_ff @(posedge clk) begin
        if (HSEL && HTRANS == 2'b10) begin
            if (HWRITE)
                mem[HADDR] <= HWDATA;
            else
                HRDATA <= mem[HADDR];
        end
    end

endmodule
