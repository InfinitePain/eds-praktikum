library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRIOSEL_TB is
end PRIOSEL_TB;

architecture TESTBENCH1 of PRIOSEL_TB is
    -- Component Declaration
    component PRIOSEL
        port (
            req: in std_logic_vector(0 to 7);
            ack: out std_logic_vector(0 to 7)
        );
    end component;
    
    -- Signal Declaration
    signal req_tb: std_logic_vector(0 to 7);
    signal ack_tb: std_logic_vector(0 to 7);
    
    -- Helper function to check if only one acknowledge is set
    function check_single_ack(vec: std_logic_vector) return boolean is
        variable count: integer := 0;
    begin
        for i in vec'range loop
            if vec(i) = '1' then
                count := count + 1;
            end if;
        end loop;
        return count = 1;
    end function;
    
    -- Helper function to find expected acknowledge position
    function find_first_req(vec: std_logic_vector) return integer is
    begin
        for i in vec'range loop
            if vec(i) = '1' then
                return i;
            end if;
        end loop;
        return -1;  -- No request found
    end function;
    
begin
    -- Unit Under Test
    UUT: PRIOSEL port map (
        req => req_tb,
        ack => ack_tb
    );
    
    -- Stimulus Process
    stim_proc: process
    begin
        -- Test Case 1: Single request
        req_tb <= "10000000";
        wait for 10 ns;
        assert ack_tb = "10000000"
            report "Test failed for single request at position 0"
            severity ERROR;
            
        -- Test Case 2: Multiple requests (example from specification)
        req_tb <= "00110100";
        wait for 10 ns;
        assert ack_tb = "00100000"
            report "Test failed for multiple requests (spec example)"
            severity ERROR;
            
        -- Test Case 3: All requests
        req_tb <= "11111111";
        wait for 10 ns;
        assert ack_tb = "10000000"
            report "Test failed for all requests"
            severity ERROR;
            
        -- Test Case 4: No requests
        req_tb <= "00000000";
        wait for 10 ns;
        assert ack_tb = "00000000"
            report "Test failed for no requests"
            severity ERROR;
            
        -- Test Case 5: Scattered requests
        req_tb <= "10100101";
        wait for 10 ns;
        assert ack_tb = "10000000"
            report "Test failed for scattered requests"
            severity ERROR;
            
        -- Test Case 6: Single request at last position
        req_tb <= "00000001";
        wait for 10 ns;
        assert ack_tb = "00000001"
            report "Test failed for single request at last position"
            severity ERROR;
            
        -- Test Case 7: Undefined request
        req_tb <= "U0000000";
        wait for 10 ns;
        -- Expected: All outputs 'X'
        
        -- Test Case 8: Request after undefined
        req_tb <= "0U100000";
        wait for 10 ns;
        -- Expected: All outputs 'X'
        
        -- Print a note & finish simulation now
        assert false report "Simulation finished" severity note;
        -- End simulation
        wait;
    end process;
    
end TESTBENCH1;
