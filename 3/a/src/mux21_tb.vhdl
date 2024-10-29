library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX21_TB is
end MUX21_TB;

architecture TESTBENCH1 of MUX21_TB is
    -- Component Declaration
    component MUX21
        port (
            a0, a1, sel: in std_logic;
            y: out std_logic
        );
    end component;
    
    -- Signal Declaration
    signal a0_tb, a1_tb, sel_tb: std_logic;
    signal y_tb: std_logic;
    
begin
    -- Unit Under Test
    UUT: MUX21 port map (
        a0 => a0_tb,
        a1 => a1_tb,
        sel => sel_tb,
        y => y_tb
    );
    
    -- Stimulus Process
    stim_proc: process
    begin
        -- Test Case 1: sel = '0'
        a0_tb <= '0';
        a1_tb <= '1';
        sel_tb <= '0';
        wait for 10 ns;
        assert y_tb = '0' report "Test 1 failed" severity ERROR;
        
        -- Test Case 2: sel = '1'
        a0_tb <= '0';
        a1_tb <= '1';
        sel_tb <= '1';
        wait for 10 ns;
        assert y_tb = '1' report "Test 2 failed" severity ERROR;
        
        -- Test Case 3: Undefined input on a0
        a0_tb <= 'U';
        a1_tb <= '1';
        sel_tb <= '0';
        wait for 10 ns;
        
        -- Test Case 4: Undefined input on a1
        a0_tb <= '0';
        a1_tb <= 'X';
        sel_tb <= '1';
        wait for 10 ns;
        
        -- Test Case 5: Undefined select
        a0_tb <= '0';
        a1_tb <= '1';
        sel_tb <= 'X';
        wait for 10 ns;
        
        -- Print a note & finish simulation now
        assert false report "Simulation finished" severity note;
        -- End simulation
        wait;
    end process;
    
end TESTBENCH1;