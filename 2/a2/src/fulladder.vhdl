library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity FULL_ADDER is
  port (a, b, carry_in: in std_logic; sum, carry_out: out std_logic);
end FULL_ADDER;



architecture BEHAVIOR of FULL_ADDER is
begin

  process (a, b, carry_in)
    variable a2, b2, carry_in2, result: unsigned (1 downto 0);
  begin
    a2 := '0' & a;                 -- extend 'a' to 2 bit
    b2 := '0' & b;                 -- extend 'b' to 2 bit
    carry_in2 := '0' & carry_in;   -- extend 'carry_in' to 2 bit
    result := a2 + b2 + carry_in2; -- add them
    sum <= result(0);              -- output 'sum' = lower bit
    carry_out <= result(1);        -- output 'carry_out' = upper bit
  end process;

end BEHAVIOR;



architecture DATAFLOW of FULL_ADDER is
begin
  sum <= (a xor b) xor carry_in;
  carry_out <= (a and b) or ((a xor b) and carry_in);
end DATAFLOW;



architecture STRUCTURE of FULL_ADDER is

  component HALF_ADDER
    port (a, b: in std_logic; sum, carry: out std_logic);
  end component;

  component OR2
    port (x, y: in std_logic; z: out std_logic);
  end component;

  signal sum1, carry1, carry2: std_logic;

  for HA0: HALF_ADDER use entity WORK.HALF_ADDER(DATAFLOW);
  for HA1: HALF_ADDER use entity WORK.HALF_ADDER(DATAFLOW);
  for OR0: OR2 use entity WORK.OR2(DATAFLOW);

begin
  HA0: HALF_ADDER port map(a => a, b => b, sum => sum1, carry => carry1);
  HA1: HALF_ADDER port map(a => sum1, b => carry_in, sum => sum, carry => carry2);
  OR0: OR2 port map(x => carry1, y => carry2, z => carry_out);
end STRUCTURE;
