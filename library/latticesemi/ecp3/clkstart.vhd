--                                                                            --
-- Author(s):                                                                 --
--   Miguel Angel Sagreras                                                    --
--                                                                            --
-- Copyright (C) 2015                                                         --
--    Miguel Angel Sagreras                                                   --
--                                                                            --
-- This source file may be used and distributed without restriction provided  --
-- that this copyright statement is not removed from the file and that any    --
-- derivative work contains  the original copyright notice and the associated --
-- disclaimer.                                                                --
--                                                                            --
-- This source file is free software; you can redistribute it and/or modify   --
-- it under the terms of the GNU General Public License as published by the   --
-- Free Software Foundation, either version 3 of the License, or (at your     --
-- option) any later version.                                                 --
--                                                                            --
-- This source is distributed in the hope that it will be useful, but WITHOUT --
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or      --
-- FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for   --
-- more details at http://www.gnu.org/licenses/.                              --
--                                                                            --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_start is
	port (
		rst  : in  std_logic;
		sclk : in  std_logic;
		eclk : in  std_logic;
		eclksynca_start : out std_logic;
		dqsbufd_rst : out std_logic);
end;

architecture ecp3 of clk_start is
	signal xxx : std_logic;
	signal drst : std_logic;
begin

	process (rst, sclk)
		variable q : std_logic;
	begin
		if rst='1' then
			xxx <= '0';
		elsif rising_edge(sclk) then
			if drst='1' then
				xxx <= '1';
			end if;
		end if;
	end process;

	process (rst, eclk)
		variable q : std_logic_vector(0 to 4-1);
	begin
		if rst='1' then
			q := (others => '0');
		elsif falling_edge(eclk) then
			q := q(1 to q'right) & xxx;
		end if;
		eclksynca_start <= q(0);
		drst <= not q(1);
	end process;
	dqsbufd_rst <= drst;

end;
