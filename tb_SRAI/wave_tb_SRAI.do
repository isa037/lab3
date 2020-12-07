onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_srai/instruction_test
add wave -noupdate /tb_srai/rst_n_test
add wave -noupdate /tb_srai/clk_test
add wave -noupdate /tb_srai/read_data_test
add wave -noupdate /tb_srai/pc_out_test
add wave -noupdate /tb_srai/mem_address_test
add wave -noupdate /tb_srai/data_to_write_test
add wave -noupdate /tb_srai/memwrite_test
add wave -noupdate /tb_srai/memread_test
add wave -noupdate /tb_srai/uut/registers/reg_memory
add wave -noupdate /tb_srai/uut/alu_i/operand1
add wave -noupdate /tb_srai/uut/alu_i/sum_input2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23903 ps} 0}
configure wave -namecolwidth 204
configure wave -valuecolwidth 153
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
WaveRestoreZoom {21140 ps} {27873 ps}
