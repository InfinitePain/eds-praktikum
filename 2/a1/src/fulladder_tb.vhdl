library IEEE;
use IEEE.std_logic_1164.all;


entity FULL_ADDER_TB is
end FULL_ADDER_TB;


architecture TESTBENCH2 of FULL_ADDER_TB is

  -- Component declaration...
  component FULL_ADDER is
    port (a, b, carry_in: in std_logic; sum, carry_out: out std_logic);
  end component;

  -- Configuration...
  for SPEC: FULL_ADDER use entity WORK.FULL_ADDER(BEHAVIOR);
  for IMPL: FULL_ADDER use entity WORK.FULL_ADDER(STRUCTURE);

  -- Internal signals...
  signal a, b, carry_in, sum_spec, carry_spec, sum_impl, carry_impl: std_logic;

begin

  -- Instantiate half adder...
  SPEC: FULL_ADDER port map (a => a, b => b, carry_in => carry_in, sum => sum_spec, carry_out => carry_spec);
  IMPL: FULL_ADDER port map (a => a, b => b, carry_in => carry_in, sum => sum_impl, carry_out => carry_impl);

  -- Main process...
  process
  begin
    a <= '0'; b <= '0'; carry_in <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=0)";

    a <= '0'; b <= '1'; carry_in <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=1)";

    a <= '1'; b <= '0'; carry_in <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=0)";

    a <= '1'; b <= '1'; carry_in <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=1)";


    a <= '0'; b <= '0'; carry_in <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=0)";

    a <= '0'; b <= '1'; carry_in <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=1)";

    a <= '1'; b <= '0'; carry_in <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=0)";

    a <= '1'; b <= '1'; carry_in <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=1)";

    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait;               -- end simulation

  end process;

end architecture;


architecture TESTBENCH1 of FULL_ADDER_TB is

  -- Component declaration
  component FULL_ADDER is
    port (a, b, carry_in: in std_logic; sum, carry_out: out std_logic);
  end component;

  -- Configuration...
  for IMPL: FULL_ADDER use entity WORK.FULL_ADDER(BEHAVIOR);

  -- Internal signals...
  signal a, b, carry_in, sum, carry: std_logic;

begin

  -- Instantiate half adder
  IMPL: FULL_ADDER port map (a => a, b => b, carry_in => carry_in, sum => sum, carry_out => carry);

  -- Main process...
  process
  begin
    a <= '0'; b <= '0'; carry_in <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum = '0' and carry = '0' report "0 + 0 + 0 is not 0/0!";

    a <= '0'; b <= '1'; carry_in <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum = '1' and carry = '0' report "0 + 1 + 0 is not 1/0!";

    a <= '1'; b <= '0'; carry_in <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum = '1' and carry = '0' report "1 + 0 + 0 is not 1/0!";

    a <= '1'; b <= '1'; carry_in <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum = '0' and carry = '1' report "1 + 1 + 0 is not 0/1!";

    a <= '0'; b <= '0'; carry_in <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum = '0' and carry = '0' report "0 + 0 + 1 is not 0/0!";

    a <= '0'; b <= '1'; carry_in <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum = '1' and carry = '0' report "0 + 1 + 1 is not 1/0!";

    a <= '1'; b <= '0'; carry_in <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum = '1' and carry = '0' report "1 + 0 + 1 is not 1/0!";

    a <= '1'; b <= '1'; carry_in <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum = '0' and carry = '1' report "1 + 1 + 1 is not 0/1!";

    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait;               -- end simulation

  end process;

end architecture;
