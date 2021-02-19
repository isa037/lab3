onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_sw/instruction_test
add wave -noupdate /tb_sw/rst_n_test
add wave -noupdate /tb_sw/clk_test
add wave -noupdate /tb_sw/read_data_test
add wave -noupdate /tb_sw/pc_out_test
add wave -noupdate /tb_sw/mem_address_test
add wave -noupdate /tb_sw/data_to_write_test
add wave -noupdate /tb_sw/memwrite_test
add wave -noupdate /tb_sw/memread_test
add wave -noupdate /tb_sw/uut/registers/reg_memory
add wave -noupdate /tb_sw/dm_test/dm
add wave -noupdate -radix unsigned /tb_sw/dm_test/addr
add wave -noupdate -radix unsigned /tb_sw/dm_test/data_in
add wave -noupdate /tb_sw/dm_test/wr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30038 ps} 0}
configure wave -namecolwidth 105
configure wave -valuecolwidth 122
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {1411 ps} {9177 ps}
