--ATTENZIONE, L'INDIRIZZO DI PARTENZA DELLA DM E' CAMBIATO
--Carica "11011000101001000111" in R3 (dato,rs2) con la LUI e poi memorizza in "00010000000000010000" R5 (base,rs1) l'offset è (4)

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity tb_SW is
end entity;

architecture tb of tb_SW is
  
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


	signal INSTRUCTION_test: std_logic_vector(31 downto 0);
	signal rst_n_test: std_logic :='1';
	signal clk_test: std_logic := '0';
	signal read_data_test, PC_OUT_test, mem_address_test,data_to_write_test: std_logic_vector(31 downto 0);
	signal MemWrite_test, MemRead_test: std_logic;
	
	constant Tc: time := 2 ns;
	
begin
	
	UUT: RISCV_PROCESSOR
		port map (INSTRUCTION_test, read_data_test, clk_test, rst_n_test, PC_OUT_test, MemWrite_test, MemRead_test, mem_address_test, data_to_write_test);
	
	dm_test: DATA_MEMORY
		port map (mem_address_test, data_to_write_test, MemRead_test, MemWrite_test, clk_test, read_data_test);
	
	
	clk_test<=not clk_test after Tc/2;
	
	stimuli: process
	begin
		wait for 4 ns;
		rst_n_test<='0';
		wait for 2 ns;
		rst_n_test<='1';
		wait for 2 ns;
		--LUI carica dato
		INSTRUCTION_test(31 downto 12)<= "11011000101001000111";		--imm field
		
		INSTRUCTION_test(11 downto 7)<="00011";  --rd:R3
		
		INSTRUCTION_test(6 downto 0)<="0110111"; --OPCODE: LUI
		wait for 2 ns;
		--LUI carica base
		INSTRUCTION_test(31 downto 12)<= "00010000000000010000";		--imm field
		
		INSTRUCTION_test(11 downto 7)<="00101";  --rd:R5
		
		INSTRUCTION_test(6 downto 0)<="0110111"; --OPCODE: LUI
		wait for 12 ns; --DATA DEPENDENCY wait
		--SW
		INSTRUCTION_test(31 downto 25)<=(others=>'0'); --offset MSBs
		INSTRUCTION_test(24 downto 20)<="00011";  --rs2 (dato):R3
		INSTRUCTION_test(19 downto 15)<="00101";  --rs1 (base):R5
		INSTRUCTION_test(14 downto 12)<="010"; --funct3: SW
		INSTRUCTION_test(11 downto 7)<="00100"; --offset LSBs: 4
		INSTRUCTION_test(6 downto 0)<="0100011"; --OPCODE: SW
		wait for 2 ns;
		--NOP: ADDI x0,x0,0
		INSTRUCTION_test(31 downto 7)<= (others=> '0'); -- x0,x0,0
		INSTRUCTION_test(6 downto 0)<= "0010011"; -- ADDI OPCODE (NOP)
		wait;
		
	end process;
	
end tb;