class ahb_monitor extends uvm_monitor;

    `uvm_component_utils(ahb_monitor)

    virtual ahb_if vif;
    uvm_analysis_port #(ahb_txn) ap;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        ap = new("ap",this);
    endfunction

    function void build_phase(uvm_phase phase);
        void'(uvm_config_db#(virtual ahb_if)::get(this,"","vif",vif));
    endfunction

    task run_phase(uvm_phase phase);

        ahb_txn tx;

        forever begin
            @(posedge vif.clk);

            if(vif.HSEL && vif.HTRANS==2'b10) begin
                tx = ahb_txn::type_id::create("tx");

                tx.addr  = vif.HADDR;
                tx.write = vif.HWRITE;

                if(vif.HWRITE)
                    tx.data = vif.HWDATA;
                else begin
                    @(posedge vif.clk);
                    tx.rdata = vif.HRDATA;
                end

                ap.write(tx);
            end
        end

    endtask

endclass
