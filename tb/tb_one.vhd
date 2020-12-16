--Testbench prima implementazione, con un lenzuolo di NOP

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity tb_one is
end entity;

architecture tb of tb_one is
  
 	component RISCV_PROCESSOR is
	port (	INSTRUCTION		: in std_logic_vector(31 downto 0);--Instrucion memory output
			read_data		: in std_logic_vector(31 downto 0);--Data memory output
			
			clk,rst_n		: in 	std_logic;
			
			PC_OUT			: out std_logic_vector(31 downto 0);--Points to instruction memory
			
			MemWrite		: out std_logic;	--DM control signal (write)
			MemRead			: out std_logic;		--DM control signal (read)
			mem_address		: out std_logic_vector(31 downto 0);	--Points to DM
			data_to_write	: out std_logic_vector(31 downto 0)		--Data to be written in DM
	);
	end component;
	
	component DATA_MEMORY is
	port(
	 ADDR: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	 DATA_IN: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	 RD, WR: IN STD_LOGIC; 						 
	 clk: IN STD_LOGIC; 						
	 DATA_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	end component;
	
	component INSTRUCTION_MEMORY IS
	PORT(
	 ADDR: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 				 						
	 DATA_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END component;


	signal INSTRUCTION_test: std_logic_vector(31 downto 0);
	signal rst_n_test: std_logic :='1';
	signal clk_test: std_logic := '0';
	signal read_data_test, PC_OUT_test,	mem_address_test,data_to_write_test: std_logic_vector(31 downto 0);
	signal MemWrite_test, MemRead_test: std_logic;
	
	constant Tc: time := 2 ns;
	
begin
	
	UUT: RISCV_PROCESSOR
		port map (INSTRUCTION_test, read_data_test, clk_test, rst_n_test, PC_OUT_test, MemWrite_test, MemRead_test, mem_address_test, data_to_write_test);
	
	dm_test: DATA_MEMORY
		port map (mem_address_test, data_to_write_test, MemRead_test, MemWrite_test, clk_test, read_data_test);
	
	im_test: INSTRUCTION_MEMORY
		port map (PC_OUT_test,INSTRUCTION_test);


	clk_test<=not clk_test after Tc/2;
	
	stimuli: process
	begin
		wait for 4 ns;
		rst_n_test<='0';
		wait for 2 ns;
		rst_n_test<='1';
		wait;
	end process;
	
end tb;