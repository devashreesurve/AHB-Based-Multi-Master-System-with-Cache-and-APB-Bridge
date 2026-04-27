class ahb_txn extends uvm_sequence_item;

    rand bit [3:0] addr;
    rand bit [7:0] data;
    rand bit write;
    bit [7:0] rdata;

    `uvm_object_utils(ahb_txn)

    function new(string name="ahb_txn");
        super.new(name);
    endfunction

endclass
