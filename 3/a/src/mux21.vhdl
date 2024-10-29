library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX21 is
    port (
        a0, a1, sel: in std_logic;
        y: out std_logic
    );
end MUX21;

architecture Behavioral of MUX21 is
begin
    process(a0, a1, sel)
    begin
        case sel is
            when '0' => y <= a0;
            when '1' => y <= a1;
            when others => y <= 'X';  -- Handling undefined states
        end case;
    end process;
end Behavioral;
