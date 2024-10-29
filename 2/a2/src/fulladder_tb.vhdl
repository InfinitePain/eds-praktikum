library IEEE;
use IEEE.std_logic_1164.all;

entity FULL_ADDER_TB is
end FULL_ADDER_TB;

architecture TESTBENCH2 of FULL_ADDER_TB is
  -- Define maximum delay constant
  constant DMAX : time := 1 ns;  -- adjust this value as needed

  -- Component declaration
  component FULL_ADDER is
    port (a, b, carry_in: in std_logic; sum, carry_out: out std_logic);
  end component;

  -- Configuration
  for SPEC: FULL_ADDER use entity WORK.FULL_ADDER(BEHAVIOR);
  for IMPL: FULL_ADDER use entity WORK.FULL_ADDER(STRUCTURE);

  -- Internal signals
  signal a, b, carry_in, sum_spec, carry_spec, sum_impl, carry_impl: std_logic;

begin
  -- Instantiate full adder
  SPEC: FULL_ADDER port map (a => a, b => b, carry_in => carry_in, 
                            sum => sum_spec, carry_out => carry_spec);
  IMPL: FULL_ADDER port map (a => a, b => b, carry_in => carry_in, 
                            sum => sum_impl, carry_out => carry_impl);

  -- Main process
  stimulus: process
    -- Store the start time for checking
    variable start_time: time;
    
    procedure apply_and_check(constant in_a, in_b, in_cin: std_logic; constant msg: string) is
      variable observed_delay: time;
    begin
      -- Apply inputs and record start time
      start_time := now;
      a <= in_a;
      b <= in_b;
      carry_in <= in_cin;
      
      -- Wait a small delta to let outputs start changing
      wait for 0 ns;
      
      -- Wait until outputs match specification or DMAX is exceeded
      while (sum_impl /= sum_spec or carry_impl /= carry_spec) and 
            ((now - start_time) <= DMAX) loop
        wait for 1 ns;
      end loop;
      
      -- Calculate observed delay
      observed_delay := now - start_time;
      
      -- Check if we exceeded DMAX
      assert observed_delay <= DMAX
        report "Timing violation! Delay = " & time'image(observed_delay) & 
               " exceeds DMAX = " & time'image(DMAX) & " " & msg
        severity error;
        
      -- Check final values
      assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! " & msg
        severity error;
        
      -- Add some separation between test cases
      wait for 1 ns;
    end procedure;

  begin
    -- Initialize
    wait for 1 ns;
    
    -- Test all combinations
    apply_and_check('0', '0', '0', "(a=0, b=0, cin=0)");
    apply_and_check('0', '1', '0', "(a=0, b=1, cin=0)");
    apply_and_check('1', '0', '0', "(a=1, b=0, cin=0)");
    apply_and_check('1', '1', '0', "(a=1, b=1, cin=0)");
    apply_and_check('0', '0', '1', "(a=0, b=0, cin=1)");
    apply_and_check('0', '1', '1', "(a=0, b=1, cin=1)");
    apply_and_check('1', '0', '1', "(a=1, b=0, cin=1)");
    apply_and_check('1', '1', '1', "(a=1, b=1, cin=1)");

    -- Print note & finish simulation
    assert false report "Simulation finished - All timing checks completed" 
      severity note;
    wait;

  end process;

end architecture;