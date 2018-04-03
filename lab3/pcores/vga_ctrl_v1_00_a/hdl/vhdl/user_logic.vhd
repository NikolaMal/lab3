------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Tue Mar 27 11:00:40 2018 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_CS                    -- Bus to IP chip select
--   Bus2IP_RNW                   -- Bus to IP read/not write
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 1;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(0 to 31);
    Bus2IP_CS                      : in  std_logic_vector(0 to 0);
    Bus2IP_RNW                     : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
	 clk_in                         : in std_logic;
	 rst_in 									: in std_logic;
	 vga_sync_h_out							: out std_logic;
	 vga_sync_v_out						: out std_logic;
	 blank_out								: out std_logic;
	 pixel_clk_out							: out std_logic;
	 vga_rst_out							: out std_logic;
	 psave_out 								: out std_logic;
	 sync_out								: out std_logic;
	 red_out									: out std_logic_vector (7 downto 0);
	 green_out								: out std_logic_vector (7 downto 0);
	 blue_out								: out std_logic_vector (7 downto 0);
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

component vga_top is 
  generic (
    H_RES                : natural := 640;
    V_RES                : natural := 480;
    MEM_ADDR_WIDTH       : natural := 32;
    GRAPH_MEM_ADDR_WIDTH : natural := 32;
    TEXT_MEM_DATA_WIDTH  : natural := 32;
    GRAPH_MEM_DATA_WIDTH : natural := 32;
    RES_TYPE             : natural := 0;       
    MEM_SIZE             : natural := 4800
    );
  port (
    clk_i               : in  std_logic;
	 
    reset_n_i           : in  std_logic;
	  write_clk 				: in std_logic;
    --
    direct_mode_i       : in  std_logic; -- 0 - text and graphics interface mode, 1 - direct mode (direct force RGB component)
    dir_red_i           : in  std_logic_vector(7 downto 0);
    dir_green_i         : in  std_logic_vector(7 downto 0);
    dir_blue_i          : in  std_logic_vector(7 downto 0);
    dir_pixel_column_o  : out std_logic_vector(10 downto 0);
    dir_pixel_row_o     : out std_logic_vector(10 downto 0);
    -- mode interface
    display_mode_i      : in  std_logic_vector(1 downto 0);  -- 01 - text mode, 10 - graphics mode, 11 - text and graphics
    -- text mode interface
    text_addr_i         : in  std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
    text_data_i         : in  std_logic_vector(TEXT_MEM_DATA_WIDTH-1 downto 0);
    text_we_i           : in  std_logic;
    -- graphics mode interface
    graph_addr_i        : in  std_logic_vector(GRAPH_MEM_ADDR_WIDTH-1 downto 0);
    graph_data_i        : in  std_logic_vector(GRAPH_MEM_DATA_WIDTH-1 downto 0);
    graph_we_i          : in  std_logic;
    -- cfg
    font_size_i         : in  std_logic_vector(3 downto 0);
    show_frame_i        : in  std_logic;
    foreground_color_i  : in  std_logic_vector(23 downto 0);
    background_color_i  : in  std_logic_vector(23 downto 0);
    frame_color_i       : in  std_logic_vector(23 downto 0);
    -- vga
    vga_hsync_o         : out std_logic;
    vga_vsync_o         : out std_logic;
    blank_o             : out std_logic;
    pix_clock_o         : out std_logic;
    vga_rst_n_o         : out std_logic;
    psave_o             : out std_logic;
    sync_o              : out std_logic;
    red_o               : out std_logic_vector(7 downto 0); 
    green_o             : out std_logic_vector(7 downto 0); 
    blue_o              : out std_logic_vector(7 downto 0)
  );
end component;

  --USER signal declarations added here, as needed for user logic
  
  signal 

begin

vga_top_i:vga_top
generic (
    H_RES                : natural := 640;
    V_RES                : natural := 480;
    MEM_ADDR_WIDTH       : natural := 32;
    GRAPH_MEM_ADDR_WIDTH : natural := 32;
    TEXT_MEM_DATA_WIDTH  : natural := 32;
    GRAPH_MEM_DATA_WIDTH : natural := 32;
    RES_TYPE             : natural := 0;       
    MEM_SIZE             : natural := 4800
    )
port map(
	clk_i => clk_in,
	 write_clk 	=> Bus2IP_Clk,
	reset_n_i => rst_in,
	vga_hsync_o => vga_sync_h_out,
   vga_vsync_o => vga_sync_v_out,
   blank_o     => blank_out,
   pix_clock_o => pixel_clk_out,
   vga_rst_n_o => vga_rst_out,
   psave_o     => psave_out,
   sync_o      => sync_out,
   red_o       => red_out, 
   green_o     => green_out, 
   blue_o      => blue_out



);

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= (others => '0');

  IP2Bus_WrAck <= '0';
  IP2Bus_RdAck <= '0';
  IP2Bus_Error <= '0';

end IMP;
