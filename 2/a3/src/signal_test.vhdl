library IEEE;
use IEEE.std_logic_1164.all;

entity TEST is
  port (clk: in std_logic);
end TEST;

architecture BEHAVIOR of TEST is
begin
  process
    variable a, b, c: std_logic := '0';  -- Variables declared here inside process
  begin
    wait until rising_edge(clk);
    a := '1';
    b := not (a or c);
    c := not b;
  end process;
end BEHAVIOR;