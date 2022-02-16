----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2020 07:37:11 PM
-- Design Name: 
-- Module Name: servo_pwm_clk64kHz - Behavioral
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

entity servo_pwm_clk128kHz is
    PORT(
        clk  : IN  STD_LOGIC;
        reset: IN  STD_LOGIC;
        pos  : IN  STD_LOGIC_VECTOR(9 downto 0);
        servo: OUT STD_LOGIC
    );
end servo_pwm_clk128kHz;

architecture Behavioral of servo_pwm_clk128kHz is
    COMPONENT clk128kHz
        PORT(
            clk    : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            clk_out: out STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT servo_pwm
        PORT (
            clk   : IN  STD_LOGIC;
            reset : IN  STD_LOGIC;
            pos   : IN  STD_LOGIC_VECTOR(9 downto 0);
            servo : OUT STD_LOGIC
        );
    END COMPONENT;
    
    signal clk_out : STD_LOGIC := '0';
begin
    clk128kHz_m: clk128kHz PORT MAP(
        clk, reset, clk_out
    );
    
    servo_pwm_m: servo_pwm PORT MAP(
        clk_out, reset, pos, servo
    );
end Behavioral;