onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_andi/rst_n_test
add wave -noupdate /tb_andi/read_data_test
add wave -noupdate /tb_andi/pc_out_test
add wave -noupdate /tb_andi/mem_address_test
add wave -noupdate /tb_andi/data_to_write_test
add wave -noupdate /tb_andi/memwrite_test
add wave -noupdate /tb_andi/memread_test
add wave -noupdate -expand -subitemconfig {/tb_andi/uut/registers/reg_memory(20) {-height 15 -radix hexadecimal} /tb_andi/uut/registers/reg_memory(14) {-height 15 -radix hexadecimal} /tb_andi/uut/registers/reg_memory(1) {-height 15 -radix hexadecimal}} /tb_andi/uut/registers/reg_memory
add wave -noupdate /tb_andi/clk_test
add wave -noupdate -radix hexadecimal /tb_andi/instruction_test
add wave -noupdate /tb_andi/read_data_test
add wave -noupdate /tb_andi/dm_test/dm
add wave -noupdate -radix hexadecimal /tb_andi/uut/alu_i/operand1
add wave -noupdate -radix hexadecimal /tb_andi/uut/alu_i/sum_input2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37998 ps} 0}
configure wave -namecolwidth 238
configure wave -valuecolwidth 206
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
WaveRestoreZoom {22468 ps} {48945 ps}
