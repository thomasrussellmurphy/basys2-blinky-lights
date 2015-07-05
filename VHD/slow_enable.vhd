library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity slow_enable is
  port (
    -- Clock input
    CLK : in std_logic;
    -- Clock enable, synchronous to CLK
    c_en : in boolean;
    c_en_out : out boolean
  );
end slow_enable;

architecture RTL of slow_enable is
  -- internal signals
  signal counter : unsigned(25 downto 0) := (others => '0');
begin
  -- logic and processes
  registers: process (CLK)
  begin
    if rising_edge(CLK) then
      if c_en then
      counter <= counter + 1;
      c_en_out <= counter = 0;
    else
      counter <= counter;
      c_en_out <= false;
    end if;
    end if;
  end process registers;
end RTL;
