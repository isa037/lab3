--Carichiamo "11001101001001000100" in R5, shiftiamo verso destra di "00101" (5) bit e memorizziamo in R11

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity tb_SRAI is
end entity;

architecture tb of tb_SRAI is
  
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

	--Meaningful
	signal INSTRUCTION_test: std_logic_vector(31 downto 0);
	signal rst_n_test: std_logic :='1';
	signal clk_test: std_logic := '0';
	
	--MeaningLESS
	signal read_data_test, PC_OUT_test, mem_address_test,data_to_write_test: std_logic_vector(31 downto 0);
	signal MemWrite_test, MemRead_test: std_logic;
	
	constant Tc: time := 2 ns;
	
begin
	
	UUT: RISCV_PROCESSOR
		port map (INSTRUCTION_test, read_data_test, clk_test, rst_n_test, PC_OUT_test, MemWrite_test, MemRead_test, mem_address_test, data_to_write_test);
	
	
	clk_test<=not clk_test after Tc/2;
	
	stimuli: process
	begin
		wait for 4 ns;
		rst_n_test<='0';
		wait for 2 ns;
		rst_n_test<='1';
		wait for 2 ns;
		--LUI "11001101001001000100", R5
		INSTRUCTION_test(31 downto 12)<= "11001101001001000100";		--imm field
		
		INSTRUCTION_test(11 downto 7)<="00101";  --rd: R5
		
		INSTRUCTION_test(6 downto 0)<="0110111"; --OPCODE : LUI
		wait for 12 ns;	--ATTENZIONE ALLA DATA DEPENDECY: se aspetto 5 colpi di clock sono sicuro 100% che non ho problemi
		--SRAI R6, 5(R5)
		INSTRUCTION_test(31 downto 30)<="01"; --funct7
		INSTRUCTION_test(29 downto 25)<=(others =>'0');
		INSTRUCTION_test(24 downto 20)<="00101"; --shamt: 5
		INSTRUCTION_test(19 downto 15)<="00101"; --rs1: R5
		INSTRUCTION_test(14 downto 12)<="101"; --funct3
		INSTRUCTION_test(11 downto 7)<="01011"; --rd: R11
		INSTRUCTION_test(6 downto 0)<="0010011"; --OPCODE: SRAI 
		wait for 2 ns;
		--NOP: ADDI x0,x0,0
		INSTRUCTION_test(31 downto 7)<= (others=> '0'); -- x0,x0,0
		INSTRUCTION_test(6 downto 0)<= "0010011"; -- ADDI OPCODE (NOP)
		wait;
		
	end process;
	
end tb;