library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DEMUX18 is
    port (
        a: in std_logic;
        sel: in std_logic_vector(2 downto 0);
        y: out std_logic_vector(0 to 7)
    );
end DEMUX18;

architecture Behavioral of DEMUX18 is
begin
    process(a, sel)
        variable y_temp: std_logic_vector(0 to 7) := (others => '0');
    begin
        -- First set all outputs to '0'
        y_temp := (others => '0');
        
        -- Check for undefined select values
        if (sel = "UUU") or (sel = "XXX") or 
           (sel(0) = 'U') or (sel(1) = 'U') or (sel(2) = 'U') or
           (sel(0) = 'X') or (sel(1) = 'X') or (sel(2) = 'X') then
            y_temp := (others => 'X');
        else
            -- Route input to selected output
            y_temp(to_integer(unsigned(sel))) := a;
        end if;
        
        y <= y_temp;
    end process;
end Behavioral;
