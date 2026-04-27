module ahb_system_top(input clk);

// Master signals
wire req1, req2, g1, g2;
wire [3:0] A1,A2;
wire [7:0] D1,D2;
wire W1,W2;
wire [1:0] T1,T2;

// Pipeline
reg [3:0] A_s1,A_s2;
reg [7:0] D_s1,D_s2;
reg W_s1,W_s2;
reg [1:0] T_s1,T_s2;

wire [3:0] HADDR = g1 ? A1 : A2;
wire [7:0] HWDATA = g1 ? D1 : D2;
wire HWRITE = g1 ? W1 : W2;
wire [1:0] HTRANS = g1 ? T1 : T2;

always @(posedge clk) begin
    A_s1<=HADDR; D_s1<=HWDATA; W_s1<=HWRITE; T_s1<=HTRANS;
    A_s2<=A_s1;  D_s2<=D_s1;  W_s2<=W_s1;  T_s2<=T_s1;
end

ahb_master1 MASTER1(clk,req1,A1,W1,D1,T1);
ahb_master2 MASTER2(clk,req2,A2,W2,D2,T2);
ahb_arbiter ARBITER(clk,req1,req2,g1,g2);

// Decoder
wire sel_cache, sel_ram, sel_apb;
ahb_decoder DECODER(A_s2, sel_cache, sel_ram, sel_apb);

// RAM
wire [7:0] RAM_DATA;
ahb_ram_slave RAM(clk, sel_ram, W_s2, A_s2, D_s2, RAM_DATA);

// FIX: delay RAM
reg [7:0] RAM_DATA_d;
always @(posedge clk) RAM_DATA_d <= RAM_DATA;

// Cache
wire [7:0] CACHE_DATA;
wire hit;
ahb_cache_controller CACHE(
    clk, sel_cache, A_s2, W_s2, D_s2, T_s2,
    RAM_DATA_d,
    CACHE_DATA, hit
);

// APB
wire [7:0] APB_DATA;
wire [3:0] PADDR;
wire PWRITE,PENABLE,PSEL;
wire [7:0] PWDATA,PRDATA;

ahb_apb_bridge BRIDGE(
    clk, A_s2, W_s2, D_s2, T_s2, sel_apb,
    APB_DATA,
    PADDR, PWRITE, PWDATA, PENABLE, PSEL, PRDATA
);

apb_slave_device APB(clk,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA);

// FIX: delay APB
reg [7:0] APB_DATA_d;
always @(posedge clk) APB_DATA_d <= APB_DATA;

// FINAL OUTPUT
reg [7:0] HRDATA;

always @(*) begin
    if (sel_cache)
        HRDATA = CACHE_DATA;
    else if (sel_ram)
        HRDATA = RAM_DATA_d;
    else
        HRDATA = APB_DATA_d;
end

endmodule