LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.NUMERIC_STD.ALL;


entity WRITE_BACK_SELECTOR is
	port ( 	muxALU				: in 	std_logic_vector(31 downto 0);
				AddSum				: in 	std_logic_vector(31 downto 0);
				Add					: in 	std_logic_vector(31 downto 0);
				DataMemory			: in 	std_logic_vector(31 downto 0);
				Alu					: in 	std_logic_vector(31 downto 0);
			
			WDataMux				: in 	std_logic_vector(2 downto 0);
			WB_VALUE				: out 	std_logic_vector(31 downto 0)
	);
end entity;



architecture rtl of WRITE_BACK_SELECTOR is
begin
wb_mux: process(WDataMux, muxALU, AddSum,Add,DataMemory,Alu)
				begin 
				case WDataMux is 
					when "100" => 	WB_VALUE <= muxALU;
					when "001" => 	WB_VALUE <= AddSum;
					when "000" => 	WB_VALUE <= Add;
					when "010" => 	WB_VALUE <= DataMemory;
					when "011" => 	WB_VALUE <= Alu;
					when others => WB_VALUE <= (others=>'X');
				end case;
				end process;
end architecture rtl;