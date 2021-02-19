onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_jal/rst_n_test
add wave -noupdate /tb_jal/read_data_test
add wave -noupdate /tb_jal/mem_address_test
add wave -noupdate /tb_jal/data_to_write_test
add wave -noupdate /tb_jal/memwrite_test
add wave -noupdate /tb_jal/memread_test
add wave -noupdate -expand -subitemconfig {/tb_jal/uut/registers/reg_memory(6) {-height 15 -radix unsigned}} /tb_jal/uut/registers/reg_memory
add wave -noupdate /tb_jal/clk_test
add wave -noupdate -radix hexadecimal /tb_jal/instruction_test
add wave -noupdate -radix unsigned /tb_jal/pc_out_test
add wave -noupdate -radix decimal /tb_jal/uut/immediate_generator/imm_field
add wave -noupdate /tb_jal/uut/immediate_generator/instruction
add wave -noupdate /tb_jal/uut/immediate_generator/opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {64492 ps} 0}
configure wave -namecolwidth 237
configure wave -valuecolwidth 100
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
WaveRestoreZoom {45645 ps} {65890 ps}
