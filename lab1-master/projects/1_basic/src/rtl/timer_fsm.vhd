-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_fsm                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    Automat za upravljanje radom stoperice                                              
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY timer_fsm IS PORT (
                          clk_i             : IN  STD_LOGIC; -- ulazni takt signal
                          rst_i             : IN  STD_LOGIC; -- reset signal
                          reset_switch_i    : IN  STD_LOGIC; -- prekidac za resetovanje brojaca
                          start_switch_i    : IN  STD_LOGIC; -- prekidac za startovanje brojaca
                          stop_switch_i     : IN  STD_LOGIC; -- prekidac za zaustavljanje brojaca
                          continue_switch_i : IN  STD_LOGIC; -- prekidac za nastavak brojanja brojaca
                          cnt_en_o          : OUT STD_LOGIC; -- izlazni signal koji sluzi kao signal dozvole brojanja
                          cnt_rst_o         : OUT STD_LOGIC  -- izlazni signal koji sluzi kao signal resetovanja brojaca (clear signal)
                         );
END timer_fsm;

ARCHITECTURE rtl OF timer_fsm IS

component reg is
	generic(
		WIDTH    : positive := 2;
		RST_INIT : integer := 0
	);
	port(
		i_clk  : in  std_logic;
		in_rst : in  std_logic;
		i_d    : in  std_logic_vector(WIDTH-1 downto 0);
		o_q    : out std_logic_vector(WIDTH-1 downto 0)
	);
end component reg;

TYPE   STATE_TYPE IS (IDLE, COUNT, STOP); -- stanja automata

SIGNAL current_state, next_state : STATE_TYPE; -- trenutno i naredno stanje automata

SIGNAL sD: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL sQ: STD_LOGIC_VECTOR(1 downto 0);

BEGIN

myReg: reg
	port map(
		i_clk => clk_i,
		in_rst => rst_i,
		i_d => sD,
		o_q => sQ
		);
		
		current_state <= IDLE when (sQ = "00") else
								COUNT when (sQ = "01") else
								STOP when (sQ = "10");

	next_state <= IDLE when ((current_state = IDLE and reset_switch_i = '1')
						or (current_state = STOP and reset_switch_i = '1')
						or (current_state = COUNT and reset_switch_i = '1')
						or rst_i = '0')
						else COUNT when ( (current_state = IDLE and start_switch_i = '1')
						or (current_state = STOP and continue_switch_i = '1') )
						else STOP when (current_state = COUNT and stop_switch_i = '1') ;
						
	sD <= "00" when (next_state = IDLE) else
			"01" when (next_state = COUNT) else
			"10" when (next_state = STOP);
						
	cnt_en_o <= '1' when next_state = COUNT;
	cnt_rst_o <= '0' when reset_switch_i = '1';
	


-- DODATI :
-- automat sa konacnim brojem stanja koji upravlja brojanjem sekundi na osnovu stanja prekidaca


END rtl;