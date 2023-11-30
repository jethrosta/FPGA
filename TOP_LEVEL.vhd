----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2023 11:17:00
-- Design Name: 
-- Module Name: TOP_LEVEL - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP_LEVEL is
  generic (n : integer := 7);
  Port (
        Clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        rx_line : in STD_LOGIC;
        Input_Verif1 : in STD_LOGIC;
        Input_Verif2 : in STD_LOGIC;
        tx_line : out STD_LOGIC;
--        LED_done : out STD_LOGIC;
        LED_TRUE : out STD_LOGIC;
        LED_FALSE : out STD_LOGIC;
        LED_DATA : out STD_LOGIC_VECTOR(n downto 0);
        TX_DONE : out STD_LOGIC;
        JETSON_TRUE : out STD_LOGIC
--        Input_complete : IN std_logic
  );
end TOP_LEVEL;

architecture Behavioral of TOP_LEVEL is

COMPONENT UART_RX is
    generic (g_CLKS_PER_BIT : integer := 10417;
             g_CLKS_PER_HALF_BIT : integer := 5208 );
    Port ( CLK : in STD_LOGIC;
           CLR : in STD_LOGIC;
           RX_LINE : in STD_LOGIC;
           RX_DATA_VALID : out  STD_LOGIC;
           RX_DATA : out  STD_LOGIC_VECTOR(7 downto 0)
           );
end COMPONENT;

COMPONENT UART_TX is
    generic (g_CLKS_PER_BIT : integer := 10417);
    Port ( CLK : in STD_LOGIC;
           CLR : in STD_LOGIC;
           TX_DATA_VALID : in STD_LOGIC;
           TX_DATA : in STD_LOGIC_VECTOR(7 downto 0);
           TX_LINE : out STD_LOGIC;
           TX_ACTIVE : out STD_LOGIC;
           TX_DONE : out STD_LOGIC);
end COMPONENT;

COMPONENT DATA_PATH is
  generic (n : integer := 7);
  Port ( 
    RX_DATA : in std_logic_vector(n downto 0); --
    RX_DATA_VALID : in STD_LOGIC; --
    Clk : in STD_LOGIC;--
    Reset : in STD_LOGIC;--
    Buff_masukan_Active : in STD_LOGIC; --
    Input_Verif1 : in STD_LOGIC;
    Input_Verif2 : in STD_LOGIC;
    Send_Active : in STD_LOGIC;
    -- output persis BUFF_MASUKAN karena isi datapath cuman BUFF_MASUKAN
    Input_complete : out std_logic := '0';
--    Input_Conv_0 : out STD_LOGIC_VECTOR(n downto 0) := (others => '0');
    TX_DATA : out STD_LOGIC_VECTOR (n downto 0);
    LED_TRUE : out STD_LOGIC;
    LED_FALSE : out STD_LOGIC
    );
end COMPONENT;

COMPONENT CONTROL_UNIT is
  Port ( 
    Clk : in STD_LOGIC;
    Reset : in STD_LOGIC;
    Input_complete : in std_logic; 
    LED_TRUE : in std_logic;
    Buff_masukan_Active : out STD_LOGIC; -- masuk case
    Send_Active : out STD_LOGIC; -- masuk case
    TX_Data_Valid : out STD_LOGIC; -- masuk case
    Sys_Reset : out STD_LOGIC -- masuk case
--    TX_DONE : out STD_LOGIC -- masuk case
    );
end COMPONENT;

--signal signal complete
signal Input_complete : std_logic := '0';  --Penyimpanan nilai masukan selesai, lanjut ke conv
--signal signal uart
Signal RX_DATA_VALID : STD_LOGIC := '1'; 
Signal TX_DATA_VALID : STD_LOGIC := '0'; 
Signal TX_ACTIVE : STD_LOGIC := '0'; 
Signal RX_DATA : std_logic_vector(n downto 0); 
Signal TX_DATA : std_logic_vector(n downto 0);
--signal signal BUFF_MASUKAN
signal Buff_masukan_Active : STD_LOGIC := '0';

signal Sys_Reset : STD_LOGIC := '0';
signal true_signal : STD_LOGIC;
signal Send_Active : STD_LOGIC := '0';
--signal byte : std_logic_vector (7 downto 0);

begin
UART_Recieve : UART_RX
    Port map(
        CLK         => Clk,
        CLR         => reset,
        RX_LINE     => rx_line,
        RX_DATA_VALID => RX_DATA_VALID,
        RX_DATA     => RX_DATA
--        RX_VALID    => RX_VALID
        );
        
UART_Transmite : UART_TX
    Port map(
        CLK         => Clk,
        CLR         => reset,
        TX_DATA_VALID => TX_DATA_VALID,
        TX_DATA     => TX_DATA,
        TX_LINE     => tx_line,
        TX_DONE     => TX_DONE
        );

Unit_Data_Path : DATA_PATH
    Port map(
        RX_DATA             => RX_DATA            ,
        RX_DATA_VALID       => RX_DATA_VALID      ,
        Clk                 => Clk                ,
        Reset               => Reset              ,
        Buff_masukan_Active => Buff_masukan_Active,
        Input_Verif1        => Input_Verif1       ,
        Input_Verif2        => Input_Verif2       ,
        Send_Active         => Send_Active        ,
        Input_complete      => Input_complete     ,
        TX_DATA             => TX_DATA            ,
        LED_TRUE            => true_signal        ,
        LED_FALSE           => LED_FALSE        
        );
        
Unit_Control_Unit : CONTROL_UNIT
    Port map(
        Clk                 => Clk,
        Reset               => Reset,
        Input_complete      => Input_complete,
        LED_TRUE            => true_signal,
        Buff_masukan_Active => Buff_masukan_Active,
        Send_Active         => Send_Active,
        TX_Data_Valid       => TX_Data_Valid,
        Sys_Reset           => Sys_Reset
--        TX_DONE             => TX_DONE
        );

LED_TRUE <= true_signal;
JETSON_TRUE <= true_signal;
LED_DATA <= TX_DATA;

end Behavioral;
