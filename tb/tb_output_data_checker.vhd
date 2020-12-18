library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity tb_output_data_checker is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
	MemWrite, RegWrite: in std_logic;
    Mem_addr : in std_logic_vector(31 downto 0);
	RF_addr  : in std_logic_vector(4 downto 0);
	Mem_data : in std_logic_vector(31 downto 0);
	RF_data  : in std_logic_vector(31 downto 0));
end tb_output_data_checker;

architecture beh of tb_output_data_checker is

begin  -- beh

 process (CLK, RST_n, MemWrite, RegWrite, Mem_addr, RF_addr, Mem_data, RF_data  )--tb process
	--Open results output file  --------------------------------------
    file res_fp : text open WRITE_MODE is "C:/Users/costa/Desktop/5.1/ISArchitecture/Labs/Lab 3/VHDL_branch_taken/tb/results.csv";
    variable line_out, line_out1, line_out2 : line;    
	
	variable write_first_line_in_csv : std_logic := '0';
	variable wait_for_output : integer := 0;
	   

 begin  -- process
	if write_first_line_in_csv = '0' then 
		write(line_out, string'("Mem Type, Address, Data"));
      	writeline(res_fp, line_out);
		write_first_line_in_csv := '1';
	end if;

		
    if RST_n = '0' then                 -- asynchronous reset (active low)
      null;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      	wait_for_output := wait_for_output + 1;
	if(wait_for_output > -1) then
			if rising_edge(CLK) and MemWrite = '1' then
				write(line_out1, string'("DM: "));
				write(line_out1, conv_integer(unsigned(Mem_addr)));
				write(line_out1, string'(", "));
				write(line_out1, conv_integer(unsigned(Mem_data)));
				writeline(res_fp, line_out1);
			end if;
			
			if RegWrite = '1' then
				write(line_out2, string'("RF: "));
				write(line_out2, conv_integer(unsigned(RF_addr)));
				write(line_out2, string'(", "));
				write(line_out2, conv_integer(unsigned(RF_data)));
				writeline(res_fp, line_out2);
			end if;
    end if;

--	if END_SIM = '1' THEN
--		if signal_error=0 then
--			write(line_out, string'("SIMULATION ENDED SUCCESSFULLY"));
--			writeline(res_fp, line_out);
--		else
--			write(line_out, string'("ERROR, WRONG RESULT PRODUCED"));
--			writeline(res_fp, line_out);
--		end if;			
	end if;
  end process;
end beh;
