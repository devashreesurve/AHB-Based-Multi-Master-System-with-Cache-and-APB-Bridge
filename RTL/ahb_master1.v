module ahb_master1 (
    input clk,
    output reg req,
    output reg [3:0] HADDR,
    output reg HWRITE,
    output reg [7:0] HWDATA,
    output reg [1:0] HTRANS
);

initial begin HADDR=0; req=0; end

always @(posedge clk) begin
    req<=1;
    HWRITE<=0;
    HTRANS<=2'b10;

    if(HADDR==3) HADDR<=2;
    else HADDR<=HADDR+1;
end

endmodule
