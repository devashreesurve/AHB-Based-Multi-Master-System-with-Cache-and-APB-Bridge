module testbench;

reg clk;
ahb_system_top uut(clk);

always #5 clk = ~clk;

initial begin
    clk = 0;

    $monitor("T=%0t ADDR=%d DATA=%d",
        $time, uut.A_s2, uut.HRDATA);

    #200 $finish;
end

endmodule
