LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity IMM_GEN is
	port (	instruction: in std_logic_vector(31 downto 0);
			
			imm_field: out std_logic_vector(31 downto 0)
	
	);
end entity;

architecture behavioral of IMM_GEN is

	signal OPCODE: std_logic_vector(6 downto 0);

begin

	OPCODE<=instruction(6 downto 0);

	imm_field_gen: process (OPCODE, instruction)
	begin
		case OPCODE IS 
			when "0110111" | "0010111" 	=> --LUI/AUIPC
								imm_field <= instruction(31 downto 12) & "000000000000";
		
			when "1101111" => --JAL
								imm_field <= (31 downto 20=>instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';
											
			when "1100011" => --BEQ
								imm_field <= (31 downto 12=>instruction(31)) & instruction(7) & instruction (30 downto 25) & instruction (11 downto 8) & '0';
								
			when "0100011" =>  --SW
								imm_field <= (31 downto 11=>instruction(31)) & instruction(30 downto 25) & instruction(11 downto 7);
								
			when "0010011" =>  --ADDI/ANDi/SRAI
								if instruction(14 downto 12) = "101" then	--check on funct3
									imm_field <= (31 downto 5 => '0') & instruction  (24 downto 20);	--SRAI							
								else
									imm_field <= (31 downto 11 => instruction(31)) & instruction(30 downto 20); --ADDI/ANDi
								end if;
								
			when others => imm_field <= (others => '0');
		end case;
	end process;
	

end architecture;