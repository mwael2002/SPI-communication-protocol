module Top_module(input clk,rst_n,tx_en,ss,input [7:0] tx_data,output [7:0] data_out_M,data_out_S); 

wire SCK,MOSI,MISO,MISO_golden;

SPI_master #(.DATA_LENGTH(8),.CPOL(1),.CPHA(1)) MASTER_DUT(clk,rst_n,MISO,tx_en,tx_data,SCK,MOSI,data_out_M);
SPI_slave #(.DATA_LENGTH(8),.CPOL(1),.CPHA(1)) SLAVE_DUT(ss,SCK,MOSI,8'b01001101,MISO,data_out_S);

endmodule