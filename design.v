// =====================================================
// DECODER
// =====================================================
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


// =====================================================
// AHB RAM SLAVE
// =====================================================
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


// =====================================================
// APB SLAVE
// =====================================================
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


// =====================================================
// AHB → APB BRIDGE
// =====================================================
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


// =====================================================
// CACHE (WITH CORRECT REFILL)
// =====================================================
module ahb_cache_controller(
    input clk,
    input HSEL,
    input [3:0] HADDR,
    input HWRITE,
    input [7:0] HWDATA,
    input [1:0] HTRANS,

    input [7:0] RAM_DATA,   // delayed RAM input

    output reg [7:0] HRDATA,
    output reg hit
);

reg [7:0] cache_data [0:3];
reg [1:0] tag [0:3];
reg valid [0:3];

integer i;

initial begin
    for(i=0;i<4;i=i+1) begin
        valid[i]=0;
        cache_data[i]=0;
        tag[i]=0;
    end
end

wire [1:0] index = HADDR[1:0];
wire [1:0] tag_in = HADDR[3:2];

always @(posedge clk) begin
    if (HSEL && HTRANS==2'b10) begin

        if (HWRITE) begin
            cache_data[index] <= HWDATA;
            tag[index] <= tag_in;
            valid[index] <= 1;
            HRDATA <= HWDATA;
            hit <= 1;
        end
        else begin
            if (valid[index] && tag[index]==tag_in) begin
                HRDATA <= cache_data[index];
                hit <= 1;
            end else begin
                // FIXED REFILL
                cache_data[index] <= RAM_DATA;
                tag[index] <= tag_in;
                valid[index] <= 1;
                HRDATA <= RAM_DATA;
                hit <= 0;
            end
        end
    end
end

endmodule


// =====================================================
// ARBITER
// =====================================================
module ahb_arbiter (
    input clk,
    input req1, req2,
    output reg grant1, grant2
);

reg turn;

initial turn = 0;

always @(posedge clk) begin
    if (req1 && req2)
        turn <= ~turn;
end

always @(*) begin
    if (req1 && req2)
        {grant1, grant2} = turn ? 2'b10 : 2'b01;
    else if (req1)
        {grant1, grant2} = 2'b10;
    else if (req2)
        {grant1, grant2} = 2'b01;
    else
        {grant1, grant2} = 2'b00;
end

endmodule


// =====================================================
// MASTER 1 (READ)
// =====================================================
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


// =====================================================
// MASTER 2 (WRITE)
// =====================================================
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


// =====================================================
// TOP SYSTEM (FINAL FIXED)
// =====================================================
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
