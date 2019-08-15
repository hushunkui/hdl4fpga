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

library hdl4fpga;
use hdl4fpga.std.all;

entity scopeio_btof is
	port (
		clk      : in  std_logic;
		bin_frm  : in  std_logic_vector;
		bin_irdy : in  std_logic_vector;
		bin_trdy : out std_logic_vector;
		bin_flt  : in  std_logic;
		bin_di   : in  std_logic_vector;
		width    : in  std_logic_vector := b"1000";
		neg      : in  std_logic;
		sign     : in  std_logic;
		align    : in  std_logic;
		unit     : in  std_logic_vector := b"0000";
		prec     : in  std_logic_vector := b"1101";
		bcd_frm  : out std_logic_vector;
		bcd_irdy : out std_logic_vector;
		bcd_trdy : in  std_logic_vector;
		bcd_end  : out std_logic;
		bcd_do   : out std_logic_vector);
end;

architecture def of scopeio_btof is
	signal btof_req     : std_logic_vector(bin_frm'range);
	signal btof_gnt     : std_logic_vector(bin_frm'range);

	signal btofbin_frm  : std_logic_vector(0 to 0);
	signal btofbin_irdy : std_logic_vector(0 to 0);
	signal btofbin_trdy : std_logic;
	signal btofbin_di   : std_logic_vector(bin_di'length/bin_frm'length-1 downto 0);
	signal btofbcd_irdy : std_logic;
	signal btofbcd_trdy : std_logic_vector(0 to 0);
	signal btofbcd_do   : std_logic_vector(4-1 downto 0);
begin

	btof_req <= bin_frm;
	arbiter_e : entity hdl4fpga.arbiter
	port map (
		clk     => clk,
		bus_req => btof_req,
		bus_gnt => btof_gnt);

	bin_trdy     <= btof_gnt and (btof_gnt'range => btofbin_trdy);
	btofbin_frm  <= wirebus(bin_frm,  btof_gnt);
	btofbin_irdy <= wirebus(bin_irdy, btof_gnt);
	btofbin_di   <= wirebus(bin_di,   btof_gnt);
		
	btof_e : entity hdl4fpga.btof
	port map (
		clk       => clk,
		frm       => btofbin_frm(0),
		bin_irdy  => btofbin_irdy(0),
		bin_trdy  => btofbin_trdy,
		bin_di    => btofbin_di,
		bin_flt   => bin_flt,
		bin_sign  => sign,
		bin_neg   => neg,
		bcd_align => align,
		bcd_width => width,
		bcd_unit  => unit,
		bcd_prec  => prec,
		bcd_irdy  => btofbcd_irdy,
		bcd_trdy  => btofbcd_trdy(0),
		bcd_end   => bcd_end,
		bcd_do    => btofbcd_do);

	btofbcd_trdy <= wirebus(bcd_trdy, btof_gnt);
	bcd_irdy <= btof_gnt and (btof_gnt'range => btofbcd_irdy);
	bcd_do   <= btofbcd_do;

end;
