onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_slt/instruction_test
add wave -noupdate /tb_slt/rst_n_test
add wave -noupdate /tb_slt/clk_test
add wave -noupdate /tb_slt/read_data_test
add wave -noupdate -radix unsigned /tb_slt/pc_out_test
add wave -noupdate /tb_slt/mem_address_test
add wave -noupdate /tb_slt/data_to_write_test
add wave -noupdate /tb_slt/memwrite_test
add wave -noupdate /tb_slt/memread_test
add wave -noupdate -expand /tb_slt/uut/registers/reg_memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1050949 ps} 0}
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
WaveRestoreZoom {1038143 ps} {1131196 ps}
