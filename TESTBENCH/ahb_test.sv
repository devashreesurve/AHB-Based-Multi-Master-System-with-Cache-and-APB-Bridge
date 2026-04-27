class ahb_test extends uvm_test;

    `uvm_component_utils(ahb_test)

    ahb_env env;

    function new(string name="ahb_test", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = ahb_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);

        ahb_seq seq;   

        phase.raise_objection(this);

        seq = ahb_seq::type_id::create("seq");
        seq.start(env.seqr);

        #1000;

        phase.drop_objection(this);

    endtask

endclass
