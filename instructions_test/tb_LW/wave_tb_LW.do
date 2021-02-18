onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_lw/instruction_test
add wave -noupdate /tb_lw/rst_n_test
add wave -noupdate /tb_lw/clk_test
add wave -noupdate /tb_lw/read_data_test
add wave -noupdate /tb_lw/pc_out_test
add wave -noupdate /tb_lw/mem_address_test
add wave -noupdate /tb_lw/data_to_write_test
add wave -noupdate /tb_lw/memwrite_test
add wave -noupdate /tb_lw/memread_test
add wave -noupdate -radix unsigned /tb_lw/uut/alu_i/operand1
add wave -noupdate /tb_lw/uut/alu_i/sum_input2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20621 ps} 0}
configure wave -namecolwidth 219
configure wave -valuecolwidth 197
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
WaveRestoreZoom {18430 ps} {25346 ps}
