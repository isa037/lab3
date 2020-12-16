LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity COMPARATOR_ID is
port ( rs1, rs2: in std_logic_vector(31 downto 0);
		zero: out std_logic);
end entity;

architecture beh of COMPARATOR_ID is

begin
	
	comparation: process (rs1, rs2)
	begin
		if rs1 = rs2 then
			zero<='1';
		else
			zero<='0';
		end if;
	end process;

end beh;