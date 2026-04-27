module ahb_master2 (
    input clk,
    output reg req,
    output reg [3:0] HADDR,
    output reg HWRITE,
    output reg [7:0] HWDATA,
    output reg [1:0] HTRANS
);

initial begin HADDR=4; req=0; end

always @(posedge clk) begin
    req<=1;
    HWRITE<=1;
    HTRANS<=2'b10;

    HADDR<=HADDR+1;
    HWDATA<=HADDR+8;
end

endmodule