module lcd480p_top (
        input clk,    // Clock

        output              lcd_clk,
        output              lcd_hsync,    //lcd horizontal synchronization
        output              lcd_vsync,    //lcd vertical synchronization
        output              lcd_de,    //lcd data enable
        output 	  [4:0]     LCD_R,     //lcd red
        output 	  [5:0]     LCD_G,     //lcd green
        output 	  [4:0]     LCD_B	   //lcd blue
    );

    wire [23:0]	lcd_data;

    assign LCD_R[4:0]=lcd_de?lcd_data[20:16]:5'H00;
    assign LCD_G[5:0]=lcd_de?lcd_data[13:8]:5'H00;
    assign LCD_B[4:0]=lcd_de?lcd_data[4:0]:5'H00;



    wire [9:0] lcd_x,lcd_y;


/*
    assign {LCD_R,LCD_G,LCD_B} = lcd_de?
           lcd_x <  30 ? 16'B10000_000000_00000: 	lcd_x <  60 ? 16'B01000_000000_00000:
           lcd_x <  90 ? 16'B00100_000000_00000:	lcd_x < 120 ? 16'B00010_000000_00000:
           lcd_x < 150 ? 16'B00001_000000_00000:	lcd_x < 180 ? 16'B00000_100000_00000:

           lcd_x < 210 ? 16'B00000_010000_00000:	lcd_x < 240 ? 16'B00000_001000_00000:
           lcd_x < 270 ? 16'B00000_000100_00000:	lcd_x < 300 ? 16'B00000_000010_00000:
           lcd_x < 330 ? 16'B00000_000001_00000:	lcd_x < 360 ? 16'B00000_000000_10000:

           lcd_x < 390 ? 16'B00000_000000_01000:	lcd_x < 420 ? 16'B00000_000000_00100:
           lcd_x < 450 ? 16'B00000_000000_00010:				  16'B00000_000000_00001
       : 16'H0000;
*/

    lcd_data #(
                 .H_DISP 		( 480 		),
                 .V_DISP 		( 272 		))
             u_lcd_data(
                 //ports
                 .clk      		( clk      		),
                 .rst_n    		(  1'b1   		),
                 .lcd_xpos 		( lcd_x 		),
                 .lcd_ypos 		( lcd_y 		),
                 .lcd_data 		( lcd_data 		)
             );


    Gowin_rPLL video_pll_m0(
                   .clkout(lcd_clk), //output clkout
                   .clkin(clk) //input clkin
               );



    vga_timing vga_timing_m0(
                   .clk  		(lcd_clk 	),
                   .rst  		(0 			),
                   .active_x 	(lcd_x 		),
                   .active_y 	(lcd_y 		),
                   .hs  		(lcd_hsync 	),
                   .vs  		(lcd_vsync 	),
                   .de  		(lcd_de 	)
               );

endmodule
