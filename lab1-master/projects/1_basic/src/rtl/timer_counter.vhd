-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul broji sekunde i prikazuje na LED diodama                                         
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY timer_counter IS PORT (
                               clk_i     : IN STD_LOGIC; -- ulazni takt
                               rst_i     : IN STD_LOGIC; -- reset signal 
                               one_sec_i : IN STD_LOGIC; -- signal koji predstavlja proteklu jednu sekundu vremena 
                               cnt_en_i  : IN STD_LOGIC; -- signal dozvole brojanja                              
                               cnt_rst_i : IN STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               led_o     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- izlaz ka led diodama
                             );
END timer_counter;

ARCHITECTURE rtl OF timer_counter IS

component reg is
	generic(
		WIDTH    : positive := 8;
		RST_INIT : integer := 0
	);
	port(
		i_clk  : in  std_logic;
		in_rst : in  std_logic;
		i_d    : in  std_logic_vector(WIDTH-1 downto 0);
		o_q    : out std_logic_vector(WIDTH-1 downto 0)
	);
end component reg;

SIGNAL counter_value_r : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL sD: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL sQ: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL sLED: STD_LOGIC_VECTOR(7 downto 0);




BEGIN

myReg: reg
	port map(
		i_clk => clk_i,
		in_rst => rst_i,
		i_d => sD,
		o_q => sQ
		);
		
		sD <= (others => '0') when cnt_rst_i = '0' else
				sD when (cnt_en_i = '1' and one_sec_i = '0') else
				sD+1 when (cnt_en_i = '1' and one_sec_i = '1');
				
		sLED <= sQ;
		
		
		
		led_o <= sLED;



-- DODATI :
-- brojac koji na osnovu izbrojanih sekundi pravi izlaz na LE diode



END rtl;