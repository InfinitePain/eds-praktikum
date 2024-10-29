library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX81_TB is
end MUX81_TB;

architecture TESTBENCH1 of MUX81_TB is
    -- Component Declaration
    component MUX81
        port (
            a: in std_logic_vector(0 to 7);
            sel: in std_logic_vector(2 downto 0);
            y: out std_logic
        );
    end component;
    
    -- Signal Declaration
    signal a_tb: std_logic_vector(0 to 7);
    signal sel_tb: std_logic_vector(2 downto 0);
    signal y_tb: std_logic;
    
begin
    -- Unit Under Test
    UUT: MUX81 port map (
        a => a_tb,
        sel => sel_tb,
        y => y_tb
    );
    
    -- Stimulus Process
    stim_proc: process
    begin
        -- Initialize test pattern
        a_tb <= "10101010";
        
        -- Test Case 1: Test all select combinations
        for i in 0 to 7 loop
            sel_tb <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
            assert y_tb = a_tb(i) 
                report "Test failed for select = " & integer'image(i)
                severity ERROR;
        end loop;
        
        -- Test Case 2: Test with all inputs high
        a_tb <= "11111111";
        sel_tb <= "000";
        wait for 10 ns;
        assert y_tb = '1' report "Test failed for all inputs high" severity ERROR;
        
        -- Test Case 3: Test with all inputs low
        a_tb <= "00000000";
        sel_tb <= "111";
        wait for 10 ns;
        assert y_tb = '0' report "Test failed for all inputs low" severity ERROR;
        
        -- Test Case 4: Test with undefined select value
        a_tb <= "10101010";
        sel_tb <= "UUU";
        wait for 10 ns;
        -- Expected output is 'X'
        
        -- Test Case 5: Test with X select value
        sel_tb <= "XXX";
        wait for 10 ns;
        -- Expected output is 'X'
        
        -- Test Case 6: Test with undefined input values
        a_tb <= "UUUUUUUU";
        sel_tb <= "000";
        wait for 10 ns;
        -- Expected output is 'U'
        
        -- Test Case 7: Test with mixed undefined input values
        a_tb <= "10UX1U0X";
        sel_tb <= "011";
        wait for 10 ns;
        -- Expected output depends on selected input
        
        -- Print a note & finish simulation now
        assert false report "Simulation finished" severity note;
        -- End simulation
        wait;
    end process;

end TESTBENCH1;