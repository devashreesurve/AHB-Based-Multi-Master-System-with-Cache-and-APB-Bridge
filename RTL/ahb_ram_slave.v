module ahb_ram_slave (
    input clk,
    input HSEL,
    input HWRITE,
    input [3:0] HADDR,
    input [7:0] HWDATA,
    output reg [7:0] HRDATA
);

reg [7:0] memory [0:15];
integer i;

initial begin
    for(i=0;i<16;i=i+1)
        memory[i] = i;
end

always @(posedge clk) begin
    if (HSEL) begin
        if (HWRITE)
            memory[HADDR] <= HWDATA;
        else
            HRDATA <= memory[HADDR];
    end
end

endmodule
