LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity register_file_32x32 is
	port (  reg_file_add1_in: in std_logic_vector(4 downto 0);
			reg_file_add2_in: in std_logic_vector(4 downto 0);
			
			reg_file_add3_in: in std_logic_vector(4 downto 0);--write address
			reg_file_data_in: in std_logic_vector(31 downto 0);			
			
			reg_write: in std_logic;
			clk,rst : in std_logic;
			
			reg_file_out1: out std_logic_vector(31 downto 0);
			reg_file_out2: out std_logic_vector(31 downto 0)
	);
end entity;

architecture rtl of register_file_32x32 is
type mem32x32 is array (31 downto 0) of std_logic_vector(31 downto 0);
signal reg_memory : mem32x32;
begin
REGISTER_file: process(rst, clk,reg_write)
					begin
						if rst = '0' then 
							reg_memory <= (others =>"00000000000000000000000000000000");
						else 
							if  reg_write = '1' then 
								if rising_edge(clk) then
									reg_memory(to_integer(unsigned(reg_file_add3_in)))<=reg_file_data_in;
								end if;
							end if;
						end if;
					end process;
					
reg_file_out1<=reg_memory(to_integer(unsigned(reg_file_add1_in)));
reg_file_out2<=reg_memory(to_integer(unsigned(reg_file_add2_in)));
end architecture rtl;