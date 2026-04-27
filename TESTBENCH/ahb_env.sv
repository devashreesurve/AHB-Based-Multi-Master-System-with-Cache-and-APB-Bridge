class ahb_env extends uvm_env;

    `uvm_component_utils(ahb_env)

    ahb_driver drv;
    ahb_monitor mon;
    ahb_sb sb;
    ahb_cov cov;
    uvm_sequencer #(ahb_txn) seqr;

    function new(string name="ahb_env", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        drv  = ahb_driver::type_id::create("drv",this);
        mon  = ahb_monitor::type_id::create("mon",this);
        sb   = ahb_sb::type_id::create("sb",this);
        cov  = ahb_cov::type_id::create("cov",this);
        seqr = uvm_sequencer#(ahb_txn)::type_id::create("seqr",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
        mon.ap.connect(sb.imp);
        mon.ap.connect(cov.imp);
    endfunction

endclass
