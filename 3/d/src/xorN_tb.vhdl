library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR_N_TB is
end XOR_N_TB;

architecture TESTBENCH1 of XOR_N_TB is
    -- Component Declaration
    component XOR_N
        port (
            a: in std_logic_vector(0 to 7);
            y: out std_logic
        );
    end component;
    
    -- Signal Declaration
    signal a_tb: std_logic_vector(0 to 7);
    signal y_tb: std_logic;
    
    -- Helper function to calculate expected XOR result
    function calc_xor(vec: std_logic_vector) return std_logic is
        variable result: std_logic;
    begin
        result := vec(vec'left);
        for i in vec'left + 1 to vec'right loop
            result := result xor vec(i);
        end loop;
        return result;
    end function;
    
begin
    -- Unit Under Test
    UUT: XOR_N port map (
        a => a_tb,
        y => y_tb
    );
    
    -- Stimulus Process
    stim_proc: process
    begin
        -- Test Case 1: All zeros
        a_tb <= "00000000";
        wait for 10 ns;
        assert y_tb = '0'
            report "Test failed for all zeros"
            severity ERROR;
            
        -- Test Case 2: All ones
        a_tb <= "11111111";
        wait for 10 ns;
        assert y_tb = '0'
            report "Test failed for all ones"
            severity ERROR;
            
        -- Test Case 3: Alternating pattern
        a_tb <= "10101010";
        wait for 10 ns;
        assert y_tb = '0'
            report "Test failed for alternating pattern"
            severity ERROR;
            
        -- Test Case 4: Single one
        a_tb <= "00000001";
        wait for 10 ns;
        assert y_tb = '1'
            report "Test failed for single one"
            severity ERROR;
            
        -- Test Case 5: Multiple ones
        a_tb <= "10001000";
        wait for 10 ns;
        assert y_tb = calc_xor(a_tb)
            report "Test failed for multiple ones"
            severity ERROR;
            
        -- Test Case 6: Undefined values
        a_tb <= "1U001000";
        wait for 10 ns;
        -- Expected output is 'U'
        
        -- Test Case 7: Unknown values
        a_tb <= "1X001000";
        wait for 10 ns;
        -- Expected output is 'X'
        
        -- Test Case 8: Mixed undefined/unknown values
        a_tb <= "1UX01000";
        wait for 10 ns;
        -- Expected output is 'U' or 'X'
        
        -- Print a note & finish simulation now
        assert false report "Simulation finished" severity note;
        -- End simulation
        wait;
    end process;
    
end TESTBENCH1;