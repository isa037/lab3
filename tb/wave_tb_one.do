onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_one/instruction_test
add wave -noupdate /tb_one/rst_n_test
add wave -noupdate /tb_one/clk_test
add wave -noupdate /tb_one/read_data_test
add wave -noupdate -radix hexadecimal /tb_one/pc_out_test
add wave -noupdate /tb_one/mem_address_test
add wave -noupdate /tb_one/data_to_write_test
add wave -noupdate /tb_one/memwrite_test
add wave -noupdate /tb_one/memread_test
add wave -noupdate -expand -subitemconfig {/tb_one/uut/registers/reg_memory(16) {-height 15 -radix unsigned} /tb_one/uut/registers/reg_memory(13) {-height 15 -radix decimal} /tb_one/uut/registers/reg_memory(10) {-height 15 -radix hexadecimal} /tb_one/uut/registers/reg_memory(8) {-height 15 -radix hexadecimal} /tb_one/uut/registers/reg_memory(5) {-height 15 -radix hexadecimal} /tb_one/uut/registers/reg_memory(4) {-height 15 -radix hexadecimal}} /tb_one/uut/registers/reg_memory
add wave -noupdate /tb_one/uut/forwarding_u/rd_ex_mem
add wave -noupdate /tb_one/uut/forwarding_u/forwarda
add wave -noupdate /tb_one/uut/forwarding_u/forwardb
add wave -noupdate -radix unsigned /tb_one/uut/alu_i/result
add wave -noupdate /tb_one/uut/wb/wdatamux
add wave -noupdate /tb_one/uut/alu_i/alucommands
add wave -noupdate /tb_one/uut/alu_i/alusrc
add wave -noupdate /tb_one/uut/alu_i/operand1
add wave -noupdate /tb_one/uut/alu_i/sum_input2
add wave -noupdate /tb_one/dm_test/dm
add wave -noupdate -radix hexadecimal /tb_one/uut/pc/branch_address
add wave -noupdate /tb_one/uut/pc/branch_ctrl
add wave -noupdate /tb_one/uut/hazard_du/pc_write
add wave -noupdate /tb_one/uut/hazard_du/rd_id_ex
add wave -noupdate /tb_one/uut/hazard_du/rs1
add wave -noupdate /tb_one/uut/hazard_du/rs2
add wave -noupdate -radix hexadecimal /tb_one/uut/pc/branch_address
add wave -noupdate -radix hexadecimal /tb_one/uut/pc/pc_next
add wave -noupdate /tb_one/uut/control/branch_ctrl
add wave -noupdate /tb_one/uut/control/op_code
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58978 ps} 0}
configure wave -namecolwidth 225
configure wave -valuecolwidth 195
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {54827 ps} {75925 ps}
