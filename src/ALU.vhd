LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity ALU is
	port (  AluCommands : in ALU_INSTRUCTION;
			ALUsrc		: in std_logic;
			operand1		: in std_logic_vector(31 downto 0);
			operand2		: in std_logic_vector(31 downto 0);
			immediate	: in std_logic_vector(31 downto 0);
			
			muxALU		: out std_logic_vector(31 downto 0);		
			result		: out std_logic_vector(31 downto 0)
	);
end entity;



architecture rtl of ALU is
signal sum_input2		: std_logic_vector(31 downto 0);

signal tmp_sum	: std_logic_vector(31 downto 0);


begin

input_mux:process(ALUsrc,immediate,operand2)
			begin
				if ALUsrc = '1' then 
					sum_input2<= immediate;
				else
					sum_input2<= operand2;
				end if;
			end process;
muxALU<= sum_input2;
ALU_DATAPATH:process(AluCommands,operand1,sum_input2)
			variable shft : integer;
			begin
					tmp_sum<=(others=>'X');
				case AluCommands is
					when SUM =>	
								tmp_sum <= std_logic_vector(signed(operand1) + signed(sum_input2));
								
--					when CONFRONTO_IF_EQUAL =>	
--								if operand1 = sum_input2 then
--									zero<='1';
--								else
--									zero<='0';
--								end if;
								
					when SHIFT =>	
									shft := to_integer(signed(sum_input2));
									tmp_sum <= std_logic_vector(shift_right(signed(operand1), shft));								
																	
					when CONFRONTO_SLT =>	
							if signed(operand1) < signed(sum_input2) then
								tmp_sum<=std_logic_vector(to_signed(1,tmp_sum'length));
							else
								tmp_sum<=std_logic_vector(to_signed(0,tmp_sum'length)) ;
							end if;
							
					when ALU_AND =>	
							tmp_sum <= operand1 and sum_input2;
							
					when ALU_XOR =>	
							tmp_sum <= operand1 xor sum_input2;
					
					when ALU_ABS=>
							if operand1(31)='0' then
								tmp_sum<=operand1;
							else
								tmp_sum<= std_logic_vector(signed(not(operand1)) + 1);
							end if;
--					when UNCONDITIONAL_JUMP =>
--							zero<='1';
					
					when NOP => tmp_sum<= (others => '0') ;--do nothing
											
				end case;
			end process;
result<=tmp_sum(31 downto 0);
end architecture rtl;