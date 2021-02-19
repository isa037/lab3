onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_beq/instruction_test
add wave -noupdate /tb_beq/rst_n_test
add wave -noupdate /tb_beq/clk_test
add wave -noupdate /tb_beq/read_data_test
add wave -noupdate -radix unsigned /tb_beq/pc_out_test
add wave -noupdate /tb_beq/mem_address_test
add wave -noupdate /tb_beq/data_to_write_test
add wave -noupdate /tb_beq/memwrite_test
add wave -noupdate /tb_beq/memread_test
add wave -noupdate -expand -subitemconfig {/tb_beq/uut/registers/reg_memory(5) {-radix hexadecimal} /tb_beq/uut/registers/reg_memory(3) {-radix hexadecimal}} /tb_beq/uut/registers/reg_memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {121621 ps} 0}
configure wave -namecolwidth 295
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
WaveRestoreZoom {35865 ps} {48921 ps}
