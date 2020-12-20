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
			data_to_write	: out std_logic_vector(31 downto 0);		--Data to be written in DM
			RF_address		: out std_logic_vector(4 downto 0);		--Used for the testbench
			RF_data_in		: out std_logic_vector(31 downto 0);	--Used for the testbench
			RegWrite		: out std_logic			--Used for the testbench
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
	
	component tb_output_data_checker is
	  port (
		CLK   : in std_logic;
		RST_n : in std_logic;
		MemWrite, RegWrite: in std_logic;
		Mem_addr : in std_logic_vector(31 downto 0);
		RF_addr  : in std_logic_vector(4 downto 0);
		Mem_data : in std_logic_vector(31 downto 0);
		RF_data  : in std_logic_vector(31 downto 0));
	end component;


	signal INSTRUCTION_test: std_logic_vector(31 downto 0);
	signal rst_n_test: std_logic :='1';
	signal clk_test: std_logic := '0';
	signal read_data_test, PC_OUT_test,	mem_address_test,data_to_write_test, RF_data_test: std_logic_vector(31 downto 0);
	signal MemWrite_test, MemRead_test, RegWrite_test: std_logic;
	signal RF_address_test: std_logic_vector(4 downto 0);
	
	constant Tc: time := 13 ns;
	
begin
	
	UUT: RISCV_PROCESSOR
		port map (INSTRUCTION_test, read_data_test, clk_test, rst_n_test, PC_OUT_test, MemWrite_test, MemRead_test, mem_address_test,
					data_to_write_test, RF_address_test, RF_data_test, RegWrite_test);
	
	dm_test: DATA_MEMORY
		port map (mem_address_test, data_to_write_test, MemRead_test, MemWrite_test, clk_test, read_data_test);
	
	im_test: INSTRUCTION_MEMORY
		port map (PC_OUT_test,INSTRUCTION_test);
		
	data_check: tb_output_data_checker
		port map (clk_test, rst_n_test, MemWrite_test, RegWrite_test, mem_address_test, RF_address_test,  data_to_write_test, RF_data_test );


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
