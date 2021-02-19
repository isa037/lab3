onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_xor/instruction_test
add wave -noupdate /tb_xor/rst_n_test
add wave -noupdate /tb_xor/clk_test
add wave -noupdate /tb_xor/read_data_test
add wave -noupdate /tb_xor/pc_out_test
add wave -noupdate /tb_xor/mem_address_test
add wave -noupdate /tb_xor/data_to_write_test
add wave -noupdate /tb_xor/memwrite_test
add wave -noupdate /tb_xor/memread_test
add wave -noupdate -expand -subitemconfig {/tb_xor/uut/registers/reg_memory(11) {-radix unsigned} /tb_xor/uut/registers/reg_memory(10) {-radix unsigned} /tb_xor/uut/registers/reg_memory(5) {-radix unsigned}} /tb_xor/uut/registers/reg_memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
