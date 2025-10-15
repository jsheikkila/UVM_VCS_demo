//`include "example_data_item.svh"

`ifndef __EXAMPLE_SEQ_SV__
 `define __EXAMPLE_SEQ_SV__

class example_seq extends uvm_sequence;
  `uvm_object_utils(example_seq)
  function new(string name="example_seq");
    super.new(name);
  endfunction

  rand int num; 	// Config total number of items to be sent

  constraint c1 { num inside {[2:5]}; }

  virtual task body();
    for (int i = 0; i < num; i ++) begin
    	//example_data_item m_item = example_data_item::type_id::create("m_item");
    	example_data_item m_item = example_data_item::type_id::create("m_item");
    	start_item(m_item);
    	m_item.randomize();
    	`uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
    	m_item.print();
      	finish_item(m_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass

`endif
