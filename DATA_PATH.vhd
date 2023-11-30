    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 05/20/2021 10:18:32 PM
    -- Design Name: 
    -- Module Name: DATA_PATH_CONV_1EP - Behavioral
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
    
    entity DATA_PATH is
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
        TX_DATA : out STD_LOGIC_VECTOR (n downto 0) := (others => '0');
        LED_TRUE : out STD_LOGIC;
        LED_FALSE : out STD_LOGIC
        );
    end DATA_PATH;
    
    architecture Behavioral of DATA_PATH is
    
    COMPONENT BUFF_MASUKAN is
      generic (n : integer := 7);
      Port (
        Data_in : in std_logic_vector(n downto 0);
        RX_DATA_VALID : in STD_LOGIC;
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Buff_masukan_Active : in STD_LOGIC;
        Input_complete : out std_logic := '0';
        Data_Out : out STD_LOGIC_VECTOR(n downto 0) := (others => '0')
      );
    end COMPONENT;
    
    COMPONENT Verificator is 
        port (
            Clk     : in STD_LOGIC;
            Reset   : in STD_LOGIC;
            Button1 : in STD_LOGIC;
            Button2 : in STD_LOGIC;
            Send_Active : in STD_LOGIC;
            LED_TRUE : out STD_LOGIC;
            LED_FALSE: out STD_LOGIC
    --        Input_complete : out STD_LOGIC
        );
    end COMPONENT;
    
    --signal Data : STD_LOGIC_VECTOR;
    
    begin
    
    Unit_Buff_Masukan : BUFF_MASUKAN
      Port map (
        Data_in             => RX_DATA,
        RX_DATA_VALID       => RX_DATA_VALID,
        Clk                 => Clk,
        Reset               => Reset,
        Buff_masukan_Active => Buff_masukan_Active,
        Input_complete      => Input_complete,
        Data_Out            => TX_DATA
        );
        
    Unit_Verificator : Verificator
      Port map (
        Clk         => Clk,
        Reset       => Reset,
        Button1     => Input_Verif1,
        Button2     => Input_Verif2,
        Send_Active => Send_Active,
        LED_TRUE    => LED_TRUE,
        LED_FALSE   => LED_FALSE
    --    Input_complete => Input_complete
      );
    
    end Behavioral;
