module testbench;

    logic clk=0;
    always #5 clk = ~clk;

    ahb_if vif(clk);

    ahb_system_dut dut(
        .clk(clk),
        .HADDR(vif.HADDR),
        .HWDATA(vif.HWDATA),
        .HWRITE(vif.HWRITE),
        .HTRANS(vif.HTRANS),
        .HSEL(vif.HSEL),
        .HRDATA(vif.HRDATA)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,testbench);
    end

    initial begin
        uvm_config_db#(virtual ahb_if)::set(null,"*","vif",vif);
        run_test("ahb_test");
    end

endmodule
