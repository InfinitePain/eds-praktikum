library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DEMUX18_TB is
end DEMUX18_TB;

architecture TESTBENCH1 of DEMUX18_TB is
    -- Component Declaration
    component DEMUX18
        port (
            a: in std_logic;
            sel: in std_logic_vector(2 downto 0);
            y: out std_logic_vector(0 to 7)
        );
    end component;
    
    -- Signal Declaration
    signal a_tb: std_logic;
    signal sel_tb: std_logic_vector(2 downto 0);
    signal y_tb: std_logic_vector(0 to 7);
    
    -- Helper function to check if only one output is set
    function check_single_output(vec: std_logic_vector; pos: integer; val: std_logic) return boolean is
        variable result: boolean := true;
    begin
        for i in vec'range loop
            if i = pos then
                if vec(i) /= val then
                    result := false;
                end if;
            elsif vec(i) /= '0' then
                result := false;
            end if;
        end loop;
        return result;
    end function;
    
begin
    -- Unit Under Test
    UUT: DEMUX18 port map (
        a => a_tb,
        sel => sel_tb,
        y => y_tb
    );
    
    -- Stimulus Process
    stim_proc: process
    begin
        -- Test Case 1: Input '1', test all select combinations
        a_tb <= '1';
        for i in 0 to 7 loop
            sel_tb <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
            assert check_single_output(y_tb, i, '1')
                report "Test failed for select = " & integer'image(i) & " with input '1'"
                severity ERROR;
        end loop;
        
        -- Test Case 2: Input '0', test all select combinations
        a_tb <= '0';
        for i in 0 to 7 loop
            sel_tb <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
            assert y_tb = "00000000"
                report "Test failed for select = " & integer'image(i) & " with input '0'"
                severity ERROR;
        end loop;
        
        -- Test Case 3: Undefined input
        a_tb <= 'U';
        sel_tb <= "000";
        wait for 10 ns;
        -- Expected: Only selected output should be 'U', others '0'
        
        -- Test Case 4: Unknown input
        a_tb <= 'X';
        sel_tb <= "001";
        wait for 10 ns;
        -- Expected: Only selected output should be 'X', others '0'
        
        -- Test Case 5: Undefined select
        a_tb <= '1';
        sel_tb <= "UUU";
        wait for 10 ns;
        -- Expected: All outputs should be 'X'
        
        -- Test Case 6: Partially undefined select
        a_tb <= '1';
        sel_tb <= "0UX";
        wait for 10 ns;
        -- Expected: All outputs should be 'X'
        
        -- Print a note & finish simulation now
        assert false report "Simulation finished" severity note;
        -- End simulation
        wait;
    end process;
    
end TESTBENCH1;