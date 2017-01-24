----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:27:47 01/10/2017 
-- Design Name: 
-- Module Name:    watchdog_timer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;

entity watchdog_timer is
	Port (	clk : in  STD_LOGIC;
				clear : in  STD_LOGIC;
				reset : out  STD_LOGIC);
end watchdog_timer;

architecture Behavioral of watchdog_timer is
	constant bits : integer := 32;
	signal deadline : unsigned(bits-1 downto 0) := to_unsigned(500,bits);
	signal counter: unsigned(bits-1 downto 0) := to_unsigned(0,bits);
	signal internal_reset : STD_LOGIC := '0';
	
begin
--	count clock cycles, as long as CPU does not set clear bit
--	and as long as deadline is not met. If interval expires,
-- reset CPU. If clear bit is set, do not restart CPU, clear
-- the counter and begin anew
restartCPU: process(clk)
	begin
		if clk'event and clk = '1' then			
			if (clear = '1') then				-- clear 1 reset 0
				internal_reset <= '0';
				counter <= to_unsigned(0,bits);
									-- clear = 1 ^ reset = 1 --> ERROR
			else 	
				if (counter = deadline) then		-- clear 0 reset 1
				internal_reset <= '1';
				else 					-- clear 0 reset 0
					counter <= counter + 1;
					internal_reset <= '0';
				end if;
			end if;
		end if;		
	end process;
	reset <= internal_reset;	
end Behavioral;
