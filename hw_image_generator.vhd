--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY hw_image_generator IS
	GENERIC(
		pixels_y0 : INTEGER := 200;
		pixels_y1 :	INTEGER := 533;    --row that first color will persist until
		pixels_y2 : INTEGER := 866;
		pixels_y3 : INTEGER := 1199;
		pixels_x0	:	INTEGER := 100;
		pixels_x1	:	INTEGER := 433;   --column that first color will persist until
		pixels_x2   :	INTEGER := 766;
		pixels_x3	:	INTEGER := 1099);
	PORT(
--		CLK_50MHz   : in  std_logic;          -- clock signal
		disp_ena		:	IN		STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		row			:	IN		INTEGER;		--row pixel coordinate
		column		:	IN		INTEGER;		--column pixel coordinate
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); --blue magnitude output to DAC
		rt : in std_logic;
		decide: in std_logic;
		reset: in std_logic);
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
--signal counter : std_logic_vector(24 downto 0);
--signal clk2:     std_logic;
signal b1, b2,b3,b4,b5,b6,b7,b8,b9 : std_logic_vector(1 downto 0):="00";
signal temp1 : std_logic_vector(3 downto 0):="0000";
signal turn  : std_logic:='0'; --when it is 0, player one's turn. otherwise, play two's turn
signal p1_win: integer range 0 to 16:=0;
signal p2_win: integer range 0 to 16:=0;
signal counter : std_logic_vector(24 downto 0);   
signal CLK_1HZ : std_logic;

BEGIN
		process(b1,b2,b3,b4,b5,b6,b7,b8,b9)
		begin
			if ((b1="10" and b2="10" and b3="10") or (b4="10" and b5="10" and b6="10")or(b7="10" and b8="10" and b9="10")) then
				p1_win <= p1_win + 1;
			elsif ((b1="10" and b4="10" and b7="10") or (b2="10" and b5="10" and b8="10")or(b3="10" and b6="10" and b9="10")) then
				p1_win <= p1_win+1;
			elsif ((b1="10" and b5="10" and b9="10") or (b3="10" and b5="10" and b7="10")) then
				p1_win <= p1_win+1;
			elsif ((b1="01" and b2="01" and b3="01") or (b4="01" and b5="01" and b6="01")or(b7="01" and b8="01" and b9="01")) then
				p2_win <= p2_win+1;
			elsif ((b1="01" and b4="01" and b7="01") or (b2="01" and b5="01" and b8="01")or(b3="01" and b6="01" and b9="01")) then
				p2_win <= p2_win+1;
			elsif ((b1="01" and b5="01" and b9="01") or (b3="01" and b5="01" and b7="01")) then
				p2_win <= p2_win+1;
			end if;
		end process;
		
		process(rt)
		begin
			if(rt='1') then
				if (temp1="0000") then
					temp1<="0001";
				elsif (temp1="0001") then
					temp1<="0010";
				elsif (temp1="0010") then
					temp1<="0011";
				elsif (temp1="0011") then
					temp1<="0100";
				elsif (temp1="0100") then
					temp1<="0101";
				elsif (temp1="0101") then
					temp1<="0110";
				elsif (temp1="0110") then
					temp1<="0111";
				elsif (temp1="0111") then
					temp1<="1000";
				elsif (temp1="1000") then
					temp1<="0000";
				end if;
			end if;
			
			
		end process;
		
		--process (CLK_50MHz)
		--begin  -- process Prescaler 
			--if CLK_50MHz'event and CLK_50MHz = '1' then  -- rising clock edge         
				--if counter < "1011111010111100001000000" then   -- Binary value is                                                         -- 25e6            
					--counter <= counter + 1;         
				--else            
					--CLK_1Hz <= not CLK_1Hz;       
					--counter <= (others => '0');         
				--end if;     
			--end if;  
		--end process;
		
		process(decide)
		begin
			if(decide='1') then
				if(turn='0') then
					if(temp1="0000" and b1="00") then
						b1<="01";
						turn<='1';
					elsif (temp1="0001" and b2="00") then
						b2<="01";
						turn<='1';
					elsif (temp1="0010" and b3="00") then
						b3<="01";
						turn<='1';
					elsif (temp1="0011" and b4="00") then
						b4<="01";
						turn<='1';
					elsif (temp1="0100" and b5="00") then
						b5<="01";
						turn<='1';
					elsif (temp1="0101" and b6="00") then
						b6<="01";
						turn<='1';
					elsif (temp1="0110" and b7="00") then
						b7<="01";
						turn<='1';
					elsif (temp1="0111" and b8="00") then
						b8<="01";
						turn<='1';
					elsif (temp1="1000" and b9="00") then
						b9<="01";
						turn<='1';
					end if;
				else
					if(temp1="0000" and b1="00") then
						b1<="10";
						turn<='0';
					elsif (temp1="0001" and b2="00") then
						b2<="10";
						turn<='0';
					elsif (temp1="0010" and b3="00") then
						b3<="10";
						turn<='0';
					elsif (temp1="0011" and b4="00") then
						b4<="10";
						turn<='0';
					elsif (temp1="0100" and b5="00") then
						b5<="10";
						turn<='0';
					elsif (temp1="0101" and b6="00") then
						b6<="10";
						turn<='0';
					elsif (temp1="0110" and b7="00") then
						b7<="10";
						turn<='0';
					elsif (temp1="0111" and b8="00") then
						b8<="10";
						turn<='0';
					elsif (temp1="1000" and b9="00") then
						b9<="10";
						turn<='0';
					end if;
				end if;
			end if;
		end process;
					

	PROCESS(disp_ena, row, column,b1,b2,b3,b4,b5,b6,b7,b8,b9)
	BEGIN
		IF(disp_ena = '1') THEN		--display time
			IF((row = pixels_y1 or row=pixels_y0 or row = pixels_y2 or row=pixels_y3)and (column<pixels_x3 and column>pixels_x0)) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			ELSIF((column=pixels_x0 or column=pixels_x1 or column=pixels_x2 or column=pixels_x3)and(row < pixels_y3 and row>pixels_y0 )) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="0000" and column>pixels_x0+100 and column<pixels_x1-100 and row < pixels_y1-100 and row>pixels_y0+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="0001" and column>pixels_x1+100 and column<pixels_x2-100 and row < pixels_y1-100 and row>pixels_y0+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="0010" and column>pixels_x2+100 and column<pixels_x3-100 and row < pixels_y1-100 and row>pixels_y0+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="0011" and column>pixels_x0+100 and column<pixels_x1-100 and row < pixels_y2-100 and row>pixels_y1+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="0100" and column>pixels_x1+100 and column<pixels_x2-100 and row < pixels_y2-100 and row>pixels_y1+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="0101" and column>pixels_x2+100 and column<pixels_x3-100 and row < pixels_y2-100 and row>pixels_y1+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="0110" and column>pixels_x0+100 and column<pixels_x1-100 and row < pixels_y3-100 and row>pixels_y2+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="0111" and column>pixels_x1+100 and column<pixels_x2-100 and row < pixels_y3-100 and row>pixels_y2+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(temp1="1000" and column>pixels_x2+100 and column<pixels_x3-100 and row < pixels_y3-100 and row>pixels_y2+100) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '1');
			elsif(b1="01" and column>pixels_x0 and column<pixels_x1 and row < pixels_y1 and row>pixels_y0) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b2="01" and column>pixels_x1 and column<pixels_x2 and row < pixels_y1 and row>pixels_y0) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b3="01" and column>pixels_x2 and column<pixels_x3 and row < pixels_y1 and row>pixels_y0) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b4="01" and column>pixels_x0 and column<pixels_x1 and row < pixels_y2 and row>pixels_y1) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b5="01" and column>pixels_x1 and column<pixels_x2 and row < pixels_y2 and row>pixels_y1) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b6="01" and column>pixels_x2 and column<pixels_x3 and row < pixels_y2 and row>pixels_y1) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b7="01" and column>pixels_x0 and column<pixels_x1 and row < pixels_y3 and row>pixels_y2) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b8="01" and column>pixels_x1 and column<pixels_x2 and row < pixels_y3 and row>pixels_y2) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b9="01" and column>pixels_x2 and column<pixels_x3 and row < pixels_y3 and row>pixels_y2) then
				red <= (OTHERS => '1');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			elsif(b1="10" and column>pixels_x0 and column<pixels_x1 and row < pixels_y1 and row>pixels_y0) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			elsif(b2="10" and column>pixels_x1 and column<pixels_x2 and row < pixels_y1 and row>pixels_y0) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			elsif(b3="10" and column>pixels_x2 and column<pixels_x3 and row < pixels_y1 and row>pixels_y0) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			elsif(b4="10" and column>pixels_x0 and column<pixels_x1 and row < pixels_y2 and row>pixels_y1) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			elsif(b5="10" and column>pixels_x1 and column<pixels_x2 and row < pixels_y2 and row>pixels_y1) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			elsif(b6="10" and column>pixels_x2 and column<pixels_x3 and row < pixels_y2 and row>pixels_y1) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			elsif(b7="10" and column>pixels_x0 and column<pixels_x1 and row < pixels_y3 and row>pixels_y2) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			elsif(b8="10" and column>pixels_x1 and column<pixels_x2 and row < pixels_y3 and row>pixels_y2) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			elsif(b9="10" and column>pixels_x2 and column<pixels_x3 and row < pixels_y3 and row>pixels_y2) then
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
				
			ELSIF((row < pixels_y3 and row>pixels_y0 and column<pixels_x3 and column>pixels_x0)) THEN
				red <= (OTHERS => '0');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSE
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '0');
			END IF;
		ELSE								--blanking time
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	
	END PROCESS;
END behavior;
