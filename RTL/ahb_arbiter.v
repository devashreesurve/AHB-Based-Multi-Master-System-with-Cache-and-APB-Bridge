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
