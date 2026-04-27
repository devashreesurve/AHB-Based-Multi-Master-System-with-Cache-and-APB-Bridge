module ahb_apb_bridge (
    input clk,
    input [3:0] HADDR,
    input HWRITE,
    input [7:0] HWDATA,
    input [1:0] HTRANS,
    input HSEL,

    output reg [7:0] HRDATA,

    output reg [3:0] PADDR,
    output reg PWRITE,
    output reg [7:0] PWDATA,
    output reg PENABLE,
    output reg PSEL,
    input [7:0] PRDATA
);

reg state;

initial state = 0;

always @(posedge clk) begin
    case(state)

    0: begin
        if (HSEL && HTRANS==2'b10) begin
            PADDR  <= HADDR;
            PWRITE <= HWRITE;
            PWDATA <= HWDATA;
            PSEL   <= 1;
            PENABLE<= 0;
            state  <= 1;
        end
    end

    1: begin
        PENABLE <= 1;

        if (!HWRITE)
            HRDATA <= PRDATA;

        PSEL <= 0;
        state <= 0;
    end

    endcase
end

endmodule
