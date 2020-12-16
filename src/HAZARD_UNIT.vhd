LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity HAZARD_UNIT is
port(	MemRead_ID_EX: in std_logic;
	Rs1, Rs2: in std_logic_vector(4 downto 0);
	rd_ID_EX: in std_logic_vector(4 downto 0);
	IF_ID_write, PC_write: out std_logic;
	NOP_sel: out std_logic);
end entity;

architecture beh of HAZARD_UNIT is

begin

	process(Rs1, Rs2, rd_ID_EX, MemRead_ID_EX)
	begin
		if (Rs1=rd_ID_EX or Rs2=rd_ID_EX) and  MemRead_ID_EX='1' and unsigned(rd_ID_EX) /= 0
		then
			IF_ID_write<='0';
			PC_write<='0';
			NOP_sel<='0';
		else
			IF_ID_write<='1';
			PC_write<='1';
			NOP_sel<='1';
		end if;
	end process;

end beh;