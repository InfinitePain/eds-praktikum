library IEEE;
use IEEE.std_logic_1164.all;

entity TEST_tb is
end TEST_tb;

architecture TESTBENCH of TEST_tb is
    -- Component declaration
    component TEST
        port (
            clk: in std_logic
        );
    end component;
    
    -- Testbench signals
    signal clk_tb: std_logic := '0';
    
    -- Signals for monitoring internal signals
    signal a, b, c: std_logic;
    
    -- Time constants
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- Component instantiation
    test_inst: TEST port map (
        clk => clk_tb
    );
    
    -- Stimulus process
    stimulus: process
    begin
        -- Initialization
        clk_tb <= '0';
        wait for CLK_PERIOD;
        
        -- Set clock to '1'
        clk_tb <= '1';
        wait for CLK_PERIOD;
        
        -- End of simulation
        wait;
    end process stimulus;
    
end TESTBENCH;