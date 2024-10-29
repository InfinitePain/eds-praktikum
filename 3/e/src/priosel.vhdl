library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRIOSEL is
    port (
        req: in std_logic_vector(0 to 7);
        ack: out std_logic_vector(0 to 7)
    );
end PRIOSEL;

architecture Behavioral of PRIOSEL is
begin
    process(req)
        variable ack_temp: std_logic_vector(0 to 7);
    begin
        -- Initialize acknowledge signals to '0'
        ack_temp := (others => '0');
        
        -- Check for undefined or unknown values
        if (req = "UUUUUUUU") or (req = "XXXXXXXX") then
            ack_temp := (others => 'X');
        else
            -- Find first request (priority to lowest index)
            for i in req'range loop
                if req(i) = '1' then
                    ack_temp(i) := '1';
                    exit;  -- Exit after first match
                elsif req(i) = 'U' or req(i) = 'X' then
                    ack_temp := (others => 'X');
                    exit;
                end if;
            end loop;
        end if;
        
        ack <= ack_temp;
    end process;
end Behavioral;
