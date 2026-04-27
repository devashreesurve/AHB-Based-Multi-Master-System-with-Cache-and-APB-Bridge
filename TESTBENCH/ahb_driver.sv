class ahb_driver extends uvm_driver #(ahb_txn);

    `uvm_component_utils(ahb_driver)

    virtual ahb_if vif;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual ahb_if)::get(this,"","vif",vif))
            `uvm_fatal("DRV","No VIF")
    endfunction

    task run_phase(uvm_phase phase);

        ahb_txn tx;

        forever begin
            seq_item_port.get_next_item(tx);

            @(posedge vif.clk);
            vif.HADDR  <= tx.addr;
            vif.HWDATA <= tx.data;
            vif.HWRITE <= tx.write;
            vif.HTRANS <= 2'b10;
            vif.HSEL   <= 1;

            @(posedge vif.clk);
            vif.HSEL   <= 0;
            vif.HTRANS <= 0;

            seq_item_port.item_done();
        end

    endtask

endclass
