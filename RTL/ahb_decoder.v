module ahb_decoder (
    input  [3:0] HADDR,
    output reg sel_cache,
    output reg sel_ram,
    output reg sel_apb
);

always @(*) begin
    sel_cache = 0;
    sel_ram   = 0;
    sel_apb   = 0;

    if (HADDR < 4)
        sel_cache = 1;
    else if (HADDR < 8)
        sel_ram = 1;
    else
        sel_apb = 1;
end

endmodule
