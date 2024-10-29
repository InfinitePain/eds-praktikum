library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        a, b: in std_logic_vector(31 downto 0);  -- data input
        op: in std_logic_vector(2 downto 0);     -- operation
        opmod: in std_logic;                     -- operation modifier
        force_add: in std_logic;                 -- add in any case
        y: out std_logic_vector(31 downto 0);    -- data output
        equal: out std_logic                     -- indicates whether a = b
    );
end ALU;

architecture behavioral of ALU is
begin
    -- Equal comparison (independent of operation)
    equal <= '1' when a = b else '0';

    -- Main ALU process
    process(a, b, op, opmod, force_add)
        variable op_result: std_logic_vector(31 downto 0);
        variable shift_amount: natural;
    begin
        -- Default assignment
        op_result := (others => '0');
        
        -- Convert shift amount (using only lower 5 bits of b)
        shift_amount := to_integer(unsigned(b(4 downto 0)));

        -- Operation selection
        if force_add = '1' then
            -- Force addition regardless of op/opmod
            op_result := std_logic_vector(unsigned(a) + unsigned(b));
        else
            case op is
                when "000" =>
                    if opmod = '0' then
                        -- Add
                        op_result := std_logic_vector(unsigned(a) + unsigned(b));
                    else
                        -- Sub
                        op_result := std_logic_vector(unsigned(a) - unsigned(b));
                    end if;

                when "100" =>
                    -- XOR
                    op_result := a xor b;

                when "110" =>
                    -- OR
                    op_result := a or b;

                when "111" =>
                    -- AND
                    op_result := a and b;

                when "001" =>
                    -- SLL (Shift Left Logical)
                    op_result := std_logic_vector(shift_left(unsigned(a), shift_amount));

                when "101" =>
                    if opmod = '0' then
                        -- SRL (Shift Right Logical)
                        op_result := std_logic_vector(shift_right(unsigned(a), shift_amount));
                    else
                        -- SRA (Shift Right Arithmetic)
                        op_result := std_logic_vector(shift_right(signed(a), shift_amount));
                    end if;

                when "010" =>
                    -- SLT (Set Less Than, signed)
                    if signed(a) < signed(b) then
                        op_result := (0 => '1', others => '0');
                    else
                        op_result := (others => '0');
                    end if;

                when "011" =>
                    -- SLTU (Set Less Than, unsigned)
                    if unsigned(a) < unsigned(b) then
                        op_result := (0 => '1', others => '0');
                    else
                        op_result := (others => '0');
                    end if;

                when others =>
                    op_result := (others => '0');
            end case;
        end if;

        -- Assign result to output
        y <= op_result;
    end process;
end behavioral;