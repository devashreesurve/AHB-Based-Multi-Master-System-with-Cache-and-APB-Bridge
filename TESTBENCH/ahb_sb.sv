class ahb_sb extends uvm_component;

    `uvm_component_utils(ahb_sb)

    uvm_analysis_imp #(ahb_txn, ahb_sb) imp;

    bit [7:0] mem_model[16];
    int pass, fail;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        imp = new("imp",this);
    endfunction

    function void write(ahb_txn tx);

        if(tx.write)
            mem_model[tx.addr] = tx.data;
        else if(mem_model[tx.addr] == tx.rdata)
            pass++;
        else begin
            fail++;
            `uvm_error("SB",$sformatf("Mismatch at addr %0d", tx.addr))
        end

    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("RESULT",$sformatf("PASS=%0d FAIL=%0d",pass,fail),UVM_NONE)
    endfunction

endclass
