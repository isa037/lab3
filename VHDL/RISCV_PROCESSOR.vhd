LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity RISCV_PROCESSOR is
	port (INSTRUCTION		: in std_logic_vector(31 downto 0);--Instrucion memory output
			read_data		: in std_logic_vector(31 downto 0);--Data memory output
			
			clk,rst_n		: in 	std_logic;
			
			PC_OUT			: out std_logic_vector(31 downto 0);--Points to instruction memory
			
			MemWrite			: out std_logic;	--DM control signal (write)
			MemRead			: out std_logic;		--DM control signal (read)
			mem_address		: out std_logic_vector(31 downto 0);	--Points to DM
			data_to_write	: out std_logic_vector(31 downto 0)		--Data to be written in DM
	);
end entity;

architecture rtl of RISCV_PROCESSOR is
SIGNAL AluCommand : ALU_INSTRUCTION;

signal pipe1_in,pipe1_out : pipe1_signal;
signal pipe2_in,pipe2_out : pipe2_signal;
signal pipe2_in_tmp: pipe2_signal;
signal pipe3_in,pipe3_out : pipe3_signal;
signal pipe4_in,pipe4_out : pipe4_signal;
signal branch_ctrl: std_logic;
signal IF_ID_write_int, PC_write_int, NOP_mux_sel : std_logic;
signal ForwardA_int, ForwardB_int : std_logic_vector(2 downto 0);
signal operand1_tmp, operand2_tmp: std_logic_vector(31 downto 0);

signal write_register	: std_logic_vector(31 downto 0);
begin
PC_OUT<=pipe1_in.PC;
branch_ctrl<=pipe3_out.branch and pipe3_out.Zero;			
			
pc: work.riscv_pkg.PROGRAM_COUNTER_MANAGER 
		port map(   branch_address	=>pipe3_out.BRANCH_ADDRESS,
						branch_ctrl		=> branch_ctrl,
						clk 			=>	clk,
						rst_n			=>	rst_n,
						PC_OUT		=>	pipe1_in.PC,
						PC_next		=>	pipe1_in.PC_next,
						PC_enable=> PC_write_int);

pipe1_in.INSTRUCTION <= INSTRUCTION;

PIPE1 : WORK.riscv_pkg.PIPE1_REG
					PORT MAP (	R 			=>pipe1_in,
								ENABLE		=>IF_ID_write_int, 
								CLOCK		=>clk, 
								RESETN		=>rst_n,
								Q 			=>pipe1_out);
								
Control: WORK.riscv_pkg.RISC_V_CONTROL_UNIT
	port map(	op_code		=>pipe1_out.INSTRUCTION(6 downto 0),
				AluOp		=>pipe2_in_tmp.AluOp,
				Branch_ctrl	=>pipe2_in_tmp.Branch,
				ALUsrc		=>pipe2_in_tmp.AluSrc,
				regWrite	=>pipe2_in_tmp.regWrite,
				MemRead		=>pipe2_in_tmp.MemRead,
				MemWrite	=>pipe2_in_tmp.MemWrite,
				WDataMux    =>pipe2_in_tmp.WDataMux);

	NOP_mux: process (NOP_mux_sel, pipe2_in_tmp)
	begin
		if NOP_mux_sel='1'
		then
			pipe2_in.AluOp		<=	 pipe2_in_tmp.AluOp		;
			pipe2_in.Branch     <=   pipe2_in_tmp.Branch    ;
			pipe2_in.AluSrc     <=   pipe2_in_tmp.AluSrc    ;
			pipe2_in.regWrite   <=   pipe2_in_tmp.regWrite  ;
			pipe2_in.MemRead    <=   pipe2_in_tmp.MemRead   ;
			pipe2_in.MemWrite   <=   pipe2_in_tmp.MemWrite  ;
			pipe2_in.WDataMux   <=   pipe2_in_tmp.WDataMux  ;
		else
			pipe2_in.AluOp		<=	idle;
			pipe2_in.Branch     <=	'0';
			pipe2_in.AluSrc     <=	'0'; --don't care
			pipe2_in.regWrite   <=	'0';
			pipe2_in.MemRead    <=	'0';
			pipe2_in.MemWrite   <=	'0';
			pipe2_in.WDataMux   <=	"000";
		end if;
	end process;

----------------------------------------------------------------------------------------------
Registers: register_file_32x32 
	port map(reg_file_add1_in=>	pipe1_out.INSTRUCTION(19 downto 15),
			reg_file_add2_in=>	pipe1_out.INSTRUCTION(24 downto 20),
			
			reg_file_add3_in=>	pipe4_out.RD,
			reg_file_data_in=>	write_register,			
			
			reg_write		=> pipe4_out.regWrite,
			clk				=> clk,
			rst				=> rst_n, 
			
			reg_file_out1=>	pipe2_in.read_data_1,
			reg_file_out2=>	pipe2_in.read_data_2);
-----------------------------------------------------------------------------------------------
				
immediate_generator: IMM_GEN 
		port map(instruction => pipe1_out.instruction,
					imm_field	=> pipe2_in.immediate);
					
pipe2_in.PC <= pipe1_out.PC;
pipe2_in.PC_next <= pipe1_out.PC_next;
pipe2_in.funct3 <= pipe1_out.instruction(14 downto 12);
pipe2_in.RD 	<= pipe1_out.instruction(11 downto 7);
pipe2_in.rs1<=pipe1_out.instruction(19 downto 15);
pipe2_in.rs2<=pipe1_out.instruction(24 downto 20);
	
PIPE2 : WORK.riscv_pkg.PIPE2_REG
					PORT MAP (	R 			=>pipe2_in,
								ENABLE		=>'1', 
								CLOCK		=>clk, 
								RESETN		=>rst_n,
								Q 			=>pipe2_out);
								
alu_control:  work.riscv_pkg.ALU_CONTROL
				port map(   funct3		=>	 pipe2_out.funct3,
								AluOp			=>  pipe2_out.AluOp,
								AluCommands	=>	 AluCommand);
								
branch_calculator: work.riscv_pkg.BRANCH_VALUE_PROVIDER 
		port map(  	IMMEDIATE_VALUE_x2	=>	pipe2_out.immediate,
						PC_VALUE					=>	pipe2_out.PC,
						BRANCH_ADDRESS			=>pipe3_in.BRANCH_ADDRESS);
						
	muxALU_forwarding_unit: process(ForwardA_int, ForwardB_int, pipe2_out,pipe3_out,write_register)
	begin
		case ForwardA_int is
			when "000" =>	--Normal Operation (from RF)
				operand1_tmp<=pipe2_out.read_data_1;
			when "001"=>		--From MEM (sampled from pipe4)
				operand1_tmp<=write_register;
			when "011" =>	--LUI: from sum_input 2
				operand1_tmp<=	pipe3_out.muxALU;
			when "100"=>	--AUIPC: from AddSUM
				operand1_tmp<= pipe3_out.BRANCH_ADDRESS;
			when others =>	-- "010" From ALU
				operand1_tmp<=pipe3_out.ALU_RESULT;
		end case;
		
		case ForwardB_int is
			when "000" =>	--Normal Operation (from RF)
				operand2_tmp<=pipe2_out.read_data_2;
			when "001" =>	--From MEM (sampled from pipe4)
				operand2_tmp<=write_register;
			when "011" =>	--LUI: from sum_input 2
				operand2_tmp<=	pipe3_out.muxALU;
			when "100"=>	--AUIPC: from AddSUM
				operand2_tmp<= pipe3_out.BRANCH_ADDRESS;
			when others =>	-- "010" From ALU
				operand2_tmp<=pipe3_out.ALU_RESULT;
		end case;
	end process;

alu_i:work.riscv_pkg.ALU 
		port map (  AluCommands =>	AluCommand,
						ALUsrc		=>	pipe2_out.ALUsrc,
						operand1=>	operand1_tmp,
						operand2=>	operand2_tmp,
						immediate	=>	pipe2_out.immediate,
						
						muxALU		=>	pipe3_in.muxALU,
						result		=>	pipe3_in.ALU_RESULT,
						zero		=>	pipe3_in.ZERO);


pipe3_in.RD				<=pipe2_out.RD;
pipe3_in.MemWrite		<= pipe2_out.MemWrite;
pipe3_in.regWrite		<= pipe2_out.regWrite;
pipe3_in.MemRead		<= pipe2_out.MemRead;
pipe3_in.branch			<= pipe2_out.Branch;
pipe3_in.WDataMux		<= pipe2_out.WDataMux;
pipe3_in.read_data_2	<= pipe2_out.read_data_2;
pipe3_in.PC_next 		<= pipe2_out.PC_next;
pipe3_in.AluOP			<= pipe2_out.AluOP;

PIPE3 : work.riscv_pkg.PIPE3_REG
					PORT MAP (	R 			=>pipe3_in,
								ENABLE		=>'1', 
								CLOCK		=>clk, 
								RESETN		=>rst_n,
								Q 			=>pipe3_out);
------------------------------------------------------------------------------------------------------------------------
MemWrite			<= pipe3_out.MemWrite;
MemRead			<= pipe3_out.MemRead;
mem_address		<= pipe3_out.ALU_RESULT;
data_to_write	<= pipe3_out.read_data_2;
------------------------------------------------------------------------------------------------------------------------
pipe4_in.RD					<=pipe3_out.RD;
pipe4_in.muxALU 			<= pipe3_out.muxALU;
pipe4_in.BRANCH_ADDRESS <= pipe3_out.BRANCH_ADDRESS;
pipe4_in.PC_next 			<= pipe3_out.PC_next;
pipe4_in.regWrite			<= pipe3_out.regWrite;
pipe4_in.WDataMux			<= pipe3_out.WDataMux;	
pipe4_in.read_data		<= read_data;	
pipe4_in.ALU_RESULT		<= pipe3_out.Alu_Result;						
PIPE4 : work.riscv_pkg.PIPE4_REG
					PORT MAP (	R =>pipe4_in,	ENABLE=>'1', CLOCK=>clk, RESETN=>rst_n,	Q=>pipe4_out);
					
wb: work.riscv_pkg.WRITE_BACK_SELECTOR
	port map (		muxALU		=>pipe4_out.muxALU,
					AddSum		=>	pipe4_out.BRANCH_ADDRESS,
					Add			=>	pipe4_out.PC_next,
					DataMemory	=>	pipe4_out.read_data,
					Alu			=> pipe4_out.ALU_RESULT,
			
					WDataMux		=> pipe4_out.WDataMux,
					WB_VALUE		=> write_register);
					

hazard_du: work.riscv_pkg.HAZARD_UNIT
	port map (  MemRead_ID_EX => pipe2_out.MemRead,
				Rs1=> pipe1_out.instruction(19 downto 15),
				Rs2=> pipe1_out.instruction(24 downto 20),
				rd_ID_EX=> pipe2_out.RD ,
				IF_ID_write=>IF_ID_write_int,
				PC_write=> PC_write_int,
				NOP_sel=>NOP_mux_sel);
				
forwarding_u: work.riscv_pkg.FORWARDING_UNIT
	port map (	Rs1				=> pipe2_out.rs1,
				Rs2             => pipe2_out.rs2,
	            rd_EX_MEM       => pipe3_out.RD,
	            rd_MEM_WB       => pipe4_out.RD,
	            RegWrite_EX_MEM => pipe3_out.RegWrite,
				RegWrite_MEM_WB => pipe4_out.RegWrite,
				AluOP_EX_MEM	=> pipe3_out.AluOP,
	            ForwardA        => ForwardA_int,
				ForwardB        => ForwardB_int);
				
								
end architecture rtl;