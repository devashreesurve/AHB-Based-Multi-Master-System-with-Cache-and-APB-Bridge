class ahb_seq extends uvm_sequence #(ahb_txn);

    `uvm_object_utils(ahb_seq)

    function new(string name="ahb_seq");
        super.new(name);
    endfunction

    task body();
        ahb_txn tx;

        // Write all addresses
        for(int i=0;i<16;i++) begin
            tx = ahb_txn::type_id::create("wr");
            start_item(tx);
            tx.addr = i;
            tx.data = $urandom_range(1,255);
            tx.write = 1;
            finish_item(tx);
        end

        // Read all addresses
        for(int i=0;i<16;i++) begin
            tx = ahb_txn::type_id::create("rd");
            start_item(tx);
            tx.addr = i;
            tx.write = 0;
            finish_item(tx);
        end

        // Random stress
        repeat(20) begin
            tx = ahb_txn::type_id::create("rand");
            start_item(tx);
            assert(tx.randomize());
            finish_item(tx);
        end
    endtask

endclass
