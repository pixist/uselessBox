----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 12:55:21 AM
-- Design Name: 
-- Module Name: topModule - Behavioral
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

entity topModule is
    Port ( switch : in STD_LOGIC;
           touch : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           touch_state : in STD_LOGIC;
           servo_a : out STD_LOGIC;
           servo_b : out STD_LOGIC;
           led_one : out STD_LOGIC_VECTOR ( 2 downto 0 );
           led : out STD_LOGIC_VECTOR ( 7 downto 0 ));
end topModule;

architecture Behavioral of topModule is

component servo_pwm_clk128kHz is
    PORT(
        clk  : IN  STD_LOGIC;
        reset: IN  STD_LOGIC;
        pos  : IN  STD_LOGIC_VECTOR(9 downto 0);
        servo: OUT STD_LOGIC
    );
end component;

component states is
    port(
        clk, reset : in std_logic;
        servopos_a, servopos_b : out STD_LOGIC_VECTOR (9 downto 0);
        touch, lever : in STD_LOGIC;
        led : out STD_LOGIC_VECTOR ( 2 downto 0 );
        touch_enable : in STD_LOGIC;
        curr_state: out STD_LOGIC_VECTOR ( 7 downto 0 )
    );
end component;

signal servopos_a : STD_LOGIC_VECTOR (9 downto 0);
signal servopos_b : STD_LOGIC_VECTOR (9 downto 0);

begin

ST : states port map( clk => clk,
                      reset => reset,
                      servopos_a => servopos_a,
                      servopos_b => servopos_b,
                      touch => touch,
                      lever => switch,
                      led => led_one,
                      curr_state => led,
                      touch_enable => touch_state);

S1 : servo_pwm_clk128kHz port map( clk => clk,
                                  reset => reset,
                                  pos => servopos_a,
                                  servo => servo_a);

S2 : servo_pwm_clk128kHz port map( clk => clk,
                                  reset => reset,
                                  pos => servopos_b,
                                  servo => servo_b);


end Behavioral;
