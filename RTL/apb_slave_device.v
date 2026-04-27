module apb_slave_device(
    input clk,
    input PSEL, PENABLE, PWRITE,
    input [3:0] PADDR,
    input [7:0] PWDATA,
    output reg [7:0] PRDATA
);

reg [7:0] memory [0:15];
integer i;

initial begin
    for(i=0;i<16;i=i+1)
        memory[i] = i + 20;
end

always @(posedge clk) begin
    if (PSEL && PENABLE) begin
        if (PWRITE)
            memory[PADDR] <= PWDATA;
        else
            PRDATA <= memory[PADDR];
    end
end

endmodule

