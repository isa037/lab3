LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

library work;
use work.riscv_pkg.all;

entity ALU_CONTROL is
	port (funct3		: in std_logic_vector(2 downto 0);
			AluOp			: in ALU_OPERATION;
			AluCommands	: out ALU_INSTRUCTION
	);
end entity;

architecture rtl of ALU_CONTROL is
begin
CONTROL_GENERATOR: process(AluOp,funct3)
					begin
						case AluOp is
							when LUI =>	
										AluCommands <= NOP;
							when AUIPC =>	
										AluCommands <= NOP;
							when JAL =>	
										AluCommands <= UNCONDITIONAL_JUMP;
							when BRANCH =>	
										AluCommands <= CONFRONTO_IF_EQUAL;
							when LOAD =>	
										AluCommands <= SUM;
							when STORE =>	
										AluCommands <= SUM;
							when OP_IMM =>
										case funct3 is 
											when "000" => AluCommands <= SUM; 		--ADDI
											when "111" => AluCommands <= ALU_AND;	--ANDI
											when "101" => AluCommands <= SHIFT; 	--SRAI
											when others => AluCommands <= NOP;
										end case;
							when OP =>							
										case funct3 is 
											when "000" => AluCommands <= SUM;			--ADD
											when "010" => AluCommands <= CONFRONTO_SLT;	--SLT
											when "100" => AluCommands <= ALU_XOR;		--XOR
											when "101" => AluCommands <= ALU_ABS;		--ABS
											when others => AluCommands <= NOP;
										end case;
							when others => AluCommands <= NOP;	
							
						end case;
					end process;


end architecture rtl;