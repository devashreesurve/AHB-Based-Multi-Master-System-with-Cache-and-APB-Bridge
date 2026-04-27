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
