onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_add/instruction_test
add wave -noupdate /tb_add/rst_n_test
add wave -noupdate /tb_add/clk_test
add wave -noupdate /tb_add/read_data_test
add wave -noupdate /tb_add/pc_out_test
add wave -noupdate /tb_add/mem_address_test
add wave -noupdate /tb_add/data_to_write_test
add wave -noupdate /tb_add/memwrite_test
add wave -noupdate /tb_add/memread_test
add wave -noupdate -expand -subitemconfig {/tb_add/uut/registers/reg_memory(11) {-radix unsigned}} /tb_add/uut/registers/reg_memory
add wave -noupdate /tb_add/uut/comtrol/aluop
add wave -noupdate -radix unsigned /tb_add/uut/alu_i/operand1
add wave -noupdate -radix unsigned /tb_add/uut/alu_i/sum_input2
add wave -noupdate /tb_add/uut/alu_i/alusrc
add wave -noupdate /tb_add/uut/registers/reg_file_add2_in
add wave -noupdate /tb_add/uut/registers/reg_file_out1
add wave -noupdate /tb_add/uut/registers/reg_file_out2
add wave -noupdate -radix decimal /tb_add/uut/alu_i/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30932 ps} 0}
configure wave -namecolwidth 234
configure wave -valuecolwidth 100
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
WaveRestoreZoom {5439 ps} {51151 ps}
