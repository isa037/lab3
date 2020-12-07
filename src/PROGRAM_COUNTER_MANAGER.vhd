LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;


entity PROGRAM_COUNTER_MANAGER is
	port (  	branch_address			: in 	std_logic_vector(31 downto 0);
				branch_ctrl					: in 	std_logic;
				clk,rst_n					: in 	std_logic;
				PC_OUT	: out 	std_logic_vector(31 downto 0);
				PC_next	: out 	std_logic_vector(31 downto 0)
	);
end entity;



architecture rtl of PROGRAM_COUNTER_MANAGER is
	COMPONENT REGN_EN_FP IS
		GENERIC ( N : INTEGER:=8); 
		PORT (	R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				ENABLE, CLOCK, RESETN : IN STD_LOGIC;
				Q :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
	
	signal PC_IN,PC_next_i		: unsigned(31 downto 0);
	signal PC_OUT_i				: std_LOGIC_VECTOR(31 downto 0);
	constant pc_update_value   :integer := 4;
begin
	Program_counter: REGN_EN_FP 
		generic map(32)
		port map (R=>std_logic_vector(PC_IN), ENABLE=>'1', CLOCK=>clk, RESETN=>rst_n,
		Q=>PC_OUT_i); 

	PC_next_i <= unsigned(PC_OUT_i) + to_unsigned(pc_update_value, PC_OUT_i'length);

	branch_mux: process(branch_ctrl,branch_address,PC_next_i)
					begin 
						if branch_ctrl='0' then 
							PC_IN <= PC_next_i;
						else 
							PC_IN <= unsigned(branch_address);
						end if;
					end process;
					

	PC_next<= std_logic_vector(pc_next_i);
	PC_OUT  <= PC_OUT_i;
end architecture rtl;