LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

library work;
use work.riscv_pkg.all;

entity RISC_V_CONTROL_UNIT is
	port (  op_code	: in 	std_logic_vector(6 downto 0);
			AluOp	: out 	ALU_OPERATION;
			Branch_ctrl	: out	std_logic;
			ALUsrc		: out	std_logic;
			regWrite		: out	std_logic;
			MemRead		: out	std_logic;
			MemWrite		: out	std_logic;
			Uncond_jmp	: out std_logic;
			WDataMux    : out std_logic_vector(2 downto 0)
			);
end entity;

architecture rtl of RISC_V_CONTROL_UNIT is

begin
CONTROL_GENERATOR: process(op_code)
					begin
					AluOp  <= idle;
					ALUsrc <= 'X';
					Branch_ctrl <= 'X';
					regWrite		<= 'X';
					MemRead		<= 'X';
					MemWrite		<= 'X';
					WDataMux		<= (others =>'X');
						case op_code is
								when "0110111" =>	AluOp<= LUI;
														ALUsrc <= '1';--The data to be written is taken from the MuxALU
														Branch_ctrl <= '0';
														regWrite		<= '1';
														MemRead		<= '0';
														MemWrite		<= '0';
														WDataMux		<= "100";
														Uncond_jmp <= '0';
														
								when "0010111" =>	AluOp<= AUIPC;
														ALUsrc <= '0';--dont care
														Branch_ctrl <= '0';
														regWrite		<= '1';
														MemRead		<= '0';
														MemWrite		<= '0';
														WDataMux		<= "001";
														Uncond_jmp <= '0';
														
								when "1101111" =>	AluOp<= idle;	--JAL
														ALUsrc <= '0';--dont care
														Branch_ctrl <= '1';
														regWrite		<= '1';
														MemRead		<= '0';
														MemWrite		<= '0';
														WDataMux		<= "000";
														Uncond_jmp <= '1';
														
								when "1100011" =>	AluOp<= idle;	--Beq
														ALUsrc <= '0';
														Branch_ctrl <= '1';
														regWrite		<= '0';
														MemRead		<= '0';
														MemWrite		<= '0';
														WDataMux		<= "111";--dont care
														Uncond_jmp <= '0';
														
								when "0000011" =>	AluOp<= LOAD;
														ALUsrc <= '1';
														Branch_ctrl <= '0';
														regWrite		<= '1';
														MemRead		<= '1';
														MemWrite		<= '0';
														WDataMux		<= "010";
														Uncond_jmp <= '0';
														
								when "0100011" =>	AluOp<= STORE;
														ALUsrc <= '1';
														Branch_ctrl <= '0';
														regWrite		<= '0';
														MemRead		<= '0';
														MemWrite		<= '1';
														WDataMux		<= "111";--dont care
														Uncond_jmp <= '0';
														
								when "0010011" =>	AluOp<= OP_IMM;
														ALUsrc <= '1';
														Branch_ctrl <= '0';
														regWrite		<= '1';
														MemRead		<= '0';
														MemWrite		<= '0';
														WDataMux		<= "011";
														Uncond_jmp <= '0';
														
								when "0110011" =>	AluOp<= OP;
														ALUsrc <= '0';
														Branch_ctrl <= '0';
														regWrite		<= '1';
														MemRead		<= '0';
														MemWrite		<= '0';
														WDataMux		<= "011";
														Uncond_jmp <= '0';
														
								when others => AluOp<= idle;
													Uncond_jmp <= '0';
													ALUsrc <= '0';
													Branch_ctrl <= '0';
													regWrite		<= '0';
													MemRead		<= '0';
													MemWrite		<= '0';
													WDataMux		<= "000";
						end case;
					end process;
end architecture rtl;