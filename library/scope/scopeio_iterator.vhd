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

entity scopeio_iterator is
	port (
		clk   : in  std_logic;
		init  : in  std_logic;
		start : in  signed;
		stop  : in  signed;
		step  : in  signed;
		ended : buffer std_logic;
		value : buffer signed);
end;

architecture def of scopeio_iterator is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if init='0' then
				value <= start;
			elsif ended='0' then
				value <= value + step;
			end if;
		end if;
	end process;
	ended <= '0' when (step > 0 and value < stop) or (step < 0 and value > stop) else '1';
end;
