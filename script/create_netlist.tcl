analyze -f vhdl -lib WORK ../src/riscv_pkg.vhd
analyze -f vhdl -lib WORK ../src/REGN.vhd
analyze -f vhdl -lib WORK ../src/REGN_PRES.vhd
analyze -f vhdl -lib WORK ../src/ALU.vhd
analyze -f vhdl -lib WORK ../src/ALU_CONTROL.vhd
analyze -f vhdl -lib WORK ../src/BRANCH_VALUE_PROVIDER.vhd
analyze -f vhdl -lib WORK ../src/COMPARATOR_ID.vhd
analyze -f vhdl -lib WORK ../src/CONTROL.vhd
analyze -f vhdl -lib WORK ../src/DATA_MEMORY.vhd
analyze -f vhdl -lib WORK ../src/FORWARDING_UNIT.vhd
analyze -f vhdl -lib WORK ../src/HAZARD_UNIT.vhd
analyze -f vhdl -lib WORK ../src/IMM_GEN.vhd
analyze -f vhdl -lib WORK ../src/INSTRUCTION_MEMORY.vhd
analyze -f vhdl -lib WORK ../src/PIPE1_REG.vhd
analyze -f vhdl -lib WORK ../src/PIPE2_REG.vhd
analyze -f vhdl -lib WORK ../src/PIPE3_REG.vhd
analyze -f vhdl -lib WORK ../src/PIPE4_REG.vhd
analyze -f vhdl -lib WORK ../src/PROGRAM_COUNTER_MANAGER.vhd
analyze -f vhdl -lib WORK ../src/REGISTER_FILE.vhd
analyze -f vhdl -lib WORK ../src/WRITE_BACK_SELECTOR.vhd
analyze -f vhdl -lib WORK ../src/RISCV_PROCESSOR.vhd


#Before completing the reading of source we set one parameter to preserve rtl names in the netlist to ease the procedure for power consumption estimation.
set power_preserve_rtl_hier_names true
#Launch elaborate command to load the components
#elaborate <top entity name> -arch <architecture name> -lib WORK > ./elaborate.txt
elaborate  RISCV_PROCESSOR -arch rtl -lib WORK > ./elaborate_results.txt
#uniquify #optional command to addres to only 1 specific architecture
link

#*******  Applying constraints   ***************
#create 100 Mhz clock
create_clock -name MY_CLK -period 12.5 clk
set_dont_touch_network MY_CLK

#jitter simulation
set_clock_uncertainty 0.07 [get_clocks MY_CLK]

#input/output delay
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]

#set output load (buffer x4 used)
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

#flatten the hiercarchy
ungroup -all -flatten
#implement the pparch multiplier
#set_implementation DW02_mult/pparch [find cell *mult*]

#*********    Start the syntesis    *************
compile >  ./analysis_results/compilation_results.txt

#compile ultra
#compile_ultra >  ./analysis_results/ultra_compilation_results.txt

#*********    Save the results      *************
report_timing  >  ./analysis_results/timing_results.txt
report_area    >  ./analysis_results/area_results.txt
report_resources > ./analysis_results/resource_report.txt


#Finally, we can save the data required to complete the design and to perform switchingactivity-based power estimation.
#ungroup -all -flatten 
#Then, we have to export the netlist in verilog. So that we impose verilog rules for the names of the internal signals. This is obtained with
change_names -hierarchy -rules verilog
#We also save a file describing the delay of the netlist:
write_sdf ../netlist/myfir.sdf
#We can now save the netlist in verilog:
write -f verilog -hierarchy -output ../netlist/myfir.v
#and the constraints to the input and output ports in a standard format:
write_sdc ../netlist/myfir.sdc

exit
