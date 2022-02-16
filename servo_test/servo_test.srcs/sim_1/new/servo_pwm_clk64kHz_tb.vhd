----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2020 07:43:38 PM
-- Design Name: 
-- Module Name: servo_pwm_clk64kHz_tb - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY servo_pwm_clk64kHz_tb IS
END servo_pwm_clk64kHz_tb;
 
ARCHITECTURE behavior OF servo_pwm_clk64kHz_tb IS
    -- Unit under test.
    COMPONENT servo_pwm_clk64kHz
        PORT(
            clk   : IN  std_logic;
            reset : IN  std_logic;
            pos   : IN  std_logic_vector(9 downto 0);
            servo : OUT std_logic
        );
    END COMPONENT;

    -- Inputs.
    signal clk  : std_logic := '0';
    signal reset: std_logic := '0';
    signal pos  : std_logic_vector(9 downto 0) := (others => '0');
    -- Outputs.
    signal servo : std_logic;
    -- Clock definition.
    constant clk_period : time := 10 ns;
BEGIN
    -- Instance of the unit under test.
    uut: servo_pwm_clk64kHz PORT MAP (
        clk => clk,
        reset => reset,
        pos => pos,
        servo => servo
    );

   -- Definition of the clock process.
   clk_process :process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;
 
    -- Stimuli process.
    stimuli: process begin
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
        wait for 50 ns;
        pos <= "0000000000";
        wait for 10 ms;
        pos <= "0000101000";
        wait for 20 ms;
        pos <= "0001010000";
        wait for 20 ms;
        pos <= "0001111000";
        wait for 20 ms;
        pos <= "0001111111";
        wait;
    end process;
END;