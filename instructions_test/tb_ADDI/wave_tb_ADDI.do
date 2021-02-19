onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_addi/instruction_test
add wave -noupdate /tb_addi/rst_n_test
add wave -noupdate /tb_addi/clk_test
add wave -noupdate /tb_addi/read_data_test
add wave -noupdate /tb_addi/pc_out_test
add wave -noupdate /tb_addi/mem_address_test
add wave -noupdate /tb_addi/data_to_write_test
add wave -noupdate /tb_addi/memwrite_test
add wave -noupdate /tb_addi/memread_test
add wave -noupdate -expand -subitemconfig {/tb_addi/uut/registers/reg_memory(20) {-height 15 -radix unsigned} /tb_addi/uut/registers/reg_memory(8) {-height 15 -radix unsigned}} /tb_addi/uut/registers/reg_memory
add wave -noupdate -radix decimal /tb_addi/uut/immediate_generator/imm_field
add wave -noupdate -radix unsigned /tb_addi/uut/alu_i/operand1
add wave -noupdate -radix unsigned /tb_addi/uut/alu_i/result
add wave -noupdate -radix decimal /tb_addi/uut/alu_i/sum_input2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29000 ps} 0}
configure wave -namecolwidth 249
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
WaveRestoreZoom {24814 ps} {32105 ps}
