library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX81 is
    port (
        a: in std_logic_vector(0 to 7);
        sel: in std_logic_vector(2 downto 0);
        y: out std_logic
    );
end MUX81;

architecture Behavioral of MUX81 is
begin
    process(a, sel)
    begin
        -- Check if sel contains any undefined values
        if (sel = "UUU") or (sel = "XXX") or 
           (sel(0) = 'U') or (sel(1) = 'U') or (sel(2) = 'U') or
           (sel(0) = 'X') or (sel(1) = 'X') or (sel(2) = 'X') then
            y <= 'X';
        else
            -- Use to_integer for selection
            y <= a(to_integer(unsigned(sel)));
        end if;
    end process;
end Behavioral;