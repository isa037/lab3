LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;


entity BRANCH_VALUE_PROVIDER is
	port (  IMMEDIATE_VALUE_x2		: in 	std_logic_vector(31 downto 0);
				PC_VALUE				: in 	std_logic_vector(31 downto 0);
			
				BRANCH_ADDRESS			: out 	std_logic_vector(31 downto 0)
	);
end entity;

architecture rtl of BRANCH_VALUE_PROVIDER is
	signal BRANCH_ADDRESS_signed : signed(31 downto 0);
begin
BRANCH_ADDRESS_signed <= signed(IMMEDIATE_VALUE_x2)+ signed(PC_VALUE);
BRANCH_ADDRESS<= std_logic_vector(BRANCH_ADDRESS_signed);
end architecture rtl;