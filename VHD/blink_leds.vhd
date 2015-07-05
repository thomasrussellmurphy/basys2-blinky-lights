library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity blink_leds is
  port (
    -- Clock input
    CLK : in std_logic;
    -- Clock enable, synchronous to CLK
    c_en : in boolean;
    -- LED outputs
    c_led : out std_logic_vector(7 downto 0)
  );
end blink_leds;

architecture RTL of blink_leds is
  -- internal signals
  signal c_led_state : std_logic_vector(7 downto 0) := B"0000_0001";
  signal c_led_state_next : std_logic_vector(7 downto 0);
  
  signal c_dir_left : boolean := true;
  signal c_dir_left_next : boolean;
begin
  -- logic and processes
  registers: process (CLK)
  begin
    if rising_edge(CLK) then
      c_led_state <= c_led_state_next;
      c_dir_left <= c_dir_left_next;
    end if;
  end process registers;
  
  -- Determining next state
  next_state: process(c_en, c_led_state, c_dir_left)
  begin
    -- Default to retaining state
    c_led_state_next <= c_led_state;
    
    -- Determine next state when there should be a change
    if c_en then
      if c_dir_left then
        c_led_state_next <= c_led_state(6 downto 0) & c_led_state(7);
      else
        c_led_state_next <= c_led_state(0) & c_led_state(7 downto 1);
      end if;
    end if;
  end process next_state;
  
  -- Determine direction to move
  shift_direction: process(c_led_state)
  begin
    -- Default to retain current shifting direction
    c_dir_left_next <= c_dir_left;
    
    if c_led_state(0) = '1' then
      c_dir_left_next <= true;
    elsif c_led_state(7) = '1' then
      c_dir_left_next <= false;
    end if;
  end process shift_direction;
  
  -- Assign the output
  c_led <= c_led_state;
end RTL;