library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_TB is
end ALU_TB;

architecture TESTBENCH1 of ALU_TB is
    -- Component declaration
    component ALU is
        port (
            a, b: in std_logic_vector(31 downto 0);
            op: in std_logic_vector(2 downto 0);
            opmod: in std_logic;
            force_add: in std_logic;
            y: out std_logic_vector(31 downto 0);
            equal: out std_logic
        );
    end component;

    -- Test signals
    signal a_tb, b_tb: std_logic_vector(31 downto 0);
    signal op_tb: std_logic_vector(2 downto 0);
    signal opmod_tb, force_add_tb: std_logic;
    signal y_tb: std_logic_vector(31 downto 0);
    signal equal_tb: std_logic;

    -- Test procedure
    procedure test_all_ops (
        a, b: in std_logic_vector(31 downto 0)
    ) is
        variable expected_result: std_logic_vector(31 downto 0);
        variable expected_equal: std_logic;
    begin
        -- Set input values
        a_tb <= a;
        b_tb <= b;
        expected_equal := '1' when a = b else '0';
        
        -- Test each operation
        for i in 0 to 7 loop
            op_tb <= std_logic_vector(to_unsigned(i, 3));
            
            -- Test with opmod = 0 and force_add = 0
            opmod_tb <= '0';
            force_add_tb <= '0';
            wait for 10 ns;
            
            -- Verify equal signal
            assert equal_tb = expected_equal
                report "Equal signal incorrect for op " & integer'image(i) 
                severity error;
            
            -- Calculate and verify expected result
            case i is
                when 0 => -- ADD
                    expected_result := std_logic_vector(unsigned(a) + unsigned(b));
                when 1 => -- SLL
                    expected_result := std_logic_vector(shift_left(unsigned(a), 
                                     to_integer(unsigned(b(4 downto 0)))));
                when 2 => -- SLT
                    if signed(a) < signed(b) then
                        expected_result := (0 => '1', others => '0');
                    else
                        expected_result := (others => '0');
                    end if;
                when 3 => -- SLTU
                    if unsigned(a) < unsigned(b) then
                        expected_result := (0 => '1', others => '0');
                    else
                        expected_result := (others => '0');
                    end if;
                when 4 => -- XOR
                    expected_result := a xor b;
                when 5 => -- SRL
                    expected_result := std_logic_vector(shift_right(unsigned(a), 
                                     to_integer(unsigned(b(4 downto 0)))));
                when 6 => -- OR
                    expected_result := a or b;
                when 7 => -- AND
                    expected_result := a and b;
                when others =>
                    expected_result := (others => '0');
            end case;
            
            assert y_tb = expected_result
                report "Incorrect result for op " & integer'image(i) 
                severity error;
            
            -- Test operations with opmod = 1 where applicable
            if i = 0 or i = 5 then  -- SUB or SRA
                opmod_tb <= '1';
                wait for 10 ns;
                
                if i = 0 then  -- SUB
                    expected_result := std_logic_vector(unsigned(a) - unsigned(b));
                else  -- SRA
                    expected_result := std_logic_vector(shift_right(signed(a), 
                                     to_integer(unsigned(b(4 downto 0)))));
                end if;
                
                assert y_tb = expected_result
                    report "Incorrect result for op " & integer'image(i) & 
                           " with opmod=1"
                    severity error;
            end if;
            
            -- Test force_add
            force_add_tb <= '1';
            wait for 10 ns;
            
            expected_result := std_logic_vector(unsigned(a) + unsigned(b));
            assert y_tb = expected_result
                report "Incorrect result with force_add=1"
                severity error;
        end loop;
    end procedure;

begin
    -- Instantiate ALU
    UUT: ALU port map (
        a => a_tb,
        b => b_tb,
        op => op_tb,
        opmod => opmod_tb,
        force_add => force_add_tb,
        y => y_tb,
        equal => equal_tb
    );

    -- Test process
    process
    begin
        -- Test case 1: Simple positive numbers
        test_all_ops(X"00000005", X"00000003");
        
        -- Test case 2: Zero and positive number
        test_all_ops(X"00000000", X"00000001");
        
        -- Test case 3: Equal numbers
        test_all_ops(X"00000004", X"00000004");
        
        -- Test case 4: Negative numbers
        test_all_ops(X"FFFFFFFF", X"FFFFFFFE");
        
        -- Test case 5: Large numbers
        test_all_ops(X"7FFFFFFF", X"80000000");
        
        -- Test case 6: Shift operations specific test
        test_all_ops(X"0000FFFF", X"00000004");
        
        report "Test completed";
        wait;
    end process;
end TESTBENCH1;