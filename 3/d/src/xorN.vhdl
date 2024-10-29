library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR_N is
    port (
        a: in std_logic_vector(0 to 7);
        y: out std_logic
    );
end XOR_N;

architecture Behavioral of XOR_N is
begin
    process(a)
        variable temp: std_logic;
    begin
        -- Initialize with first element
        temp := a(a'left);
        
        -- XOR all remaining elements using range attribute
        for i in a'left + 1 to a'right loop
            temp := temp xor a(i);
        end loop;
        
        y <= temp;
    end process;
end Behavioral;