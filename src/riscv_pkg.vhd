library ieee;
use ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

package riscv_pkg is
  type ALU_INSTRUCTION is (SUM, SHIFT, CONFRONTO_SLT, ALU_AND, ALU_XOR, ALU_ABS, NOP);
  type ALU_OPERATION is (OP_IMM,LUI,AUIPC,LOAD,STORE,OP, idle);
  
  component PROGRAM_COUNTER_MANAGER is
		port (  branch_address				: in 	std_logic_vector(31 downto 0);
				branch_ctrl					: in 	std_logic;
				clk,rst_n					: in 	std_logic;
				PC_OUT	: out 	std_logic_vector(31 downto 0);
				PC_next	: out 	std_logic_vector(31 downto 0);
				PC_enable: in std_logic
		);
	end component;
	
	component IMM_GEN is
		port (	instruction: in std_logic_vector(31 downto 0);
				
				imm_field: out std_logic_vector(31 downto 0)
		
		);
	end component;

	component ALU is
		port (  AluCommands : in ALU_INSTRUCTION;
				ALUsrc		: in std_logic;
				operand1		: in std_logic_vector(31 downto 0);
				operand2		: in std_logic_vector(31 downto 0);
				immediate	: in std_logic_vector(31 downto 0);
				
				muxALU		: out std_logic_vector(31 downto 0);		
				result		: out std_logic_vector(31 downto 0)
		);
	end component;

	component RISC_V_CONTROL_UNIT is
		port (  op_code	: in 	std_logic_vector(6 downto 0);
				AluOp	: out 	ALU_OPERATION;
				Branch_ctrl	: out	std_logic;
				ALUsrc	: out	std_logic;
				regWrite : out std_logic;
				MemRead		: out	std_logic;
				MemWrite		: out	std_logic;
				Uncond_jmp  : out std_logic;
				WDataMux    : out std_logic_vector(2 downto 0)
				);
	end component;

	component COMPARATOR_ID is
	port ( rs1, rs2: in std_logic_vector(31 downto 0);
			zero: out std_logic);
	end component;

	component ALU_CONTROL is
		port (  funct3		: in std_logic_vector(2 downto 0);
				AluOp		: in ALU_OPERATION;
				AluCommands	: out ALU_INSTRUCTION
		);
	end component;

	component BRANCH_VALUE_PROVIDER is
		port (  IMMEDIATE_VALUE_x2		: in 	std_logic_vector(31 downto 0);
				PC_VALUE				: in 	std_logic_vector(31 downto 0);
				
				BRANCH_ADDRESS			: out 	std_logic_vector(31 downto 0)
		);
	end component;
	
	component REGN_EN_FP IS
		GENERIC ( N : INTEGER:=8); --dimensione generica
		PORT (	R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END component;
	
	component register_file_32x32 is
	port (  reg_file_add1_in: in std_logic_vector(4 downto 0);
			reg_file_add2_in: in std_logic_vector(4 downto 0);
			
			reg_file_add3_in: in std_logic_vector(4 downto 0);--write address
			reg_file_data_in: in std_logic_vector(31 downto 0);			
			
			reg_write: in std_logic;
			clk,rst : in std_logic;
			
			reg_file_out1: out std_logic_vector(31 downto 0);
			reg_file_out2: out std_logic_vector(31 downto 0)
	);
end component;
	
	component WRITE_BACK_SELECTOR is
	port (muxALU				: in 	std_logic_vector(31 downto 0);
			AddSum				: in 	std_logic_vector(31 downto 0);
			Add					: in 	std_logic_vector(31 downto 0);
			DataMemory			: in 	std_logic_vector(31 downto 0);
			Alu					: in 	std_logic_vector(31 downto 0);
			
			WDataMux				: in 	std_logic_vector(2 downto 0);
			WB_VALUE				: out 	std_logic_vector(31 downto 0)
	);
	end component;

	COMPONENT HAZARD_UNIT is
	port(	MemRead_ID_EX: in std_logic;
		branch_ctrl: in std_logic;
		Rs1, Rs2: in std_logic_vector(4 downto 0);
		rd_ID_EX: in std_logic_vector(4 downto 0);
		IF_ID_write, PC_write, IF_Flush: out std_logic;
		NOP_sel: out std_logic);
	end COMPONENT;

	COMPONENT FORWARDING_UNIT is
	port( Rs1, Rs2: in   std_logic_vector(4 downto 0);
		rd_EX_MEM:in   std_logic_vector(4 downto 0);
		rd_MEM_WB:in   std_logic_vector(4 downto 0);
		RegWrite_EX_MEM, RegWrite_MEM_WB: in std_logic;
		AluOp_EX_MEM: ALU_OPERATION;
		ForwardA, ForwardB: out std_logic_vector(2 downto 0));
	end COMPONENT;
	
--------------------PIPE 1 -------------------------------	
	type pipe1_signal is record
		PC: std_logic_vector(31 downto 0);
		PC_next		: std_logic_vector(31 downto 0);
		instruction: std_logic_vector(31 downto 0);
	end record;
	
	component PIPE1_REG IS
	PORT (	R : IN pipe1_signal;
				ENABLE, CLOCK, RESETN, SYN_RESETN : IN STD_LOGIC;
				Q :	OUT pipe1_signal);
	END component;
----------------------------------------------------------
--------------------PIPE 2 -------------------------------
	type pipe2_signal is record
		PC				: std_logic_vector(31 downto 0);
		PC_next		: std_logic_vector(31 downto 0);
		read_data_1	: std_logic_vector(31 downto 0);
		read_data_2	: std_logic_vector(31 downto 0);
		immediate	: std_logic_vector(31 downto 0);
		funct3 		: std_logic_vector(2 downto 0);
		RD				: std_logic_vector(4 downto 0);
		rs1, rs2: std_logic_vector(4 downto 0);
		BRANCH_ADDRESS: std_logic_vector(31 downto 0);
		--CONTROL SIGNALS
		ALUsrc		: std_logic;
--		Branch		: std_logic;
		WDataMux		: std_logic_vector(2 downto 0);
		RegWrite		: std_logic;
		MemRead		: std_logic;
		MemWrite		: std_logic;
		AluOp			: ALU_OPERATION;
	end record;
	
	component PIPE2_REG IS
	PORT (	R : IN pipe2_signal;
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT pipe2_signal);
	END component;
----------------------------------------------------------
--------------------PIPE 3 -------------------------------
	type pipe3_signal is record
		--DATAPATH SIGNALS
		PC_next		: std_logic_vector(31 downto 0);
		BRANCH_ADDRESS	: std_logic_vector(31 downto 0);
--		ZERO			: std_logic;
		ALU_RESULT		: std_logic_vector(31 downto 0);
		READ_DATA_2		: std_logic_vector(31 downto 0);
		muxALU			: std_logic_vector(31 downto 0);
		RD					: std_logic_vector(4 downto 0);
		--CONTROL SIGNALS
--		Branch		: std_logic;
		WDataMux		: std_logic_vector(2 downto 0);
		MemRead		: std_logic;
		MemWrite		: std_logic;
		RegWrite		: std_logic;
		AluOp			: ALU_OPERATION;
	end record;
	
	component PIPE3_REG IS
	PORT (		R : IN pipe3_signal;
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT pipe3_signal);
	END component;
----------------------------------------------------------
--------------------PIPE 4 -------------------------------
	type pipe4_signal is record
		BRANCH_ADDRESS	: std_logic_vector(31 downto 0);
		PC_next			: std_logic_vector(31 downto 0);
		ALU_RESULT		: std_logic_vector(31 downto 0);
		read_data		: std_logic_vector(31 downto 0);
		WDataMux			: std_logic_vector(2 downto 0);
		muxALU			: std_logic_vector(31 downto 0);
		RD					: std_logic_vector(4 downto 0);
		RegWrite			: std_logic;
	end record;
	
	component PIPE4_REG IS
	PORT (	R : IN pipe4_signal;
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT pipe4_signal);
	END component;
	
end package;

package body riscv_pkg is
end package body;