class ahb_cov extends uvm_component;

    `uvm_component_utils(ahb_cov)

    uvm_analysis_imp #(ahb_txn, ahb_cov) imp;
    ahb_txn tx;

    covergroup cg;
        option.per_instance = 1;

        ADDR  : coverpoint tx.addr  { bins all[] = {[0:15]}; }
        WRITE : coverpoint tx.write { bins r={0}; bins w={1}; }
        CROSS : cross ADDR, WRITE;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name,parent);
        imp = new("imp",this);
        cg = new();
    endfunction

    function void write(ahb_txn t);
        tx = t;
        cg.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("COV",$sformatf("Coverage = %0.2f %%", cg.get_inst_coverage()),UVM_NONE)
    endfunction

endclass
