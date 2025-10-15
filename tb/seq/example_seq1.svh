`ifndef __EXAMPLE_SEQ1_SV__
 `define __EXAMPLE_SEQ1_SV__

class example_seq1 extends uvm_sequence;
  `uvm_object_utils(example_seq1)
  function new(string name="example_seq1");
    super.new(name);
  endfunction

  int num = 1000; 	// Config total number of items to be sent


  virtual task body();
    for (int i = 0; i < num; i ++) begin
      // this won't work because driver uses only	example_data_item type 
    	//example_data_item2 m_item = example_data_item2::type_id::create("m_item");
    	example_data_item m_item = example_data_item::type_id::create("m_item");
    	start_item(m_item);
    	m_item.randomize();
    	`uvm_info("SEQ1", $sformatf("Generate new item: "), UVM_LOW)
    	m_item.print();
      	finish_item(m_item);
    end
    `uvm_info("SEQ1", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass

`endif
