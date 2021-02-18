onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_lui/instruction_test
add wave -noupdate /tb_lui/rst_n_test
add wave -noupdate /tb_lui/clk_test
add wave -noupdate /tb_lui/read_data_test
add wave -noupdate /tb_lui/pc_out_test
add wave -noupdate /tb_lui/memwrite_test
add wave -noupdate /tb_lui/memread_test
add wave -noupdate /tb_lui/uut/registers/reg_memory
add wave -noupdate /tb_lui/uut/comtrol/aluop
add wave -noupdate /tb_lui/uut/immediate_generator/imm_field
add wave -noupdate /tb_lui/uut/wb/wb_value
add wave -noupdate /tb_lui/uut/wb/wdatamux
add wave -noupdate /tb_lui/uut/comtrol/op_code
add wave -noupdate /tb_lui/uut/pipe2/q.wdatamux
add wave -noupdate /tb_lui/uut/registers/reg_file_add3_in
add wave -noupdate /tb_lui/uut/registers/reg_file_data_in
add wave -noupdate -expand /tb_lui/uut/registers/reg_memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16973 ps} 0}
configure wave -namecolwidth 184
configure wave -valuecolwidth 145
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
WaveRestoreZoom {0 ps} {11658 ps}
