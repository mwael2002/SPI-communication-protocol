module SPI_master #(parameter DATA_LENGTH=8,CPOL = 0, CPHA = 0)(input sys_clk,rst_n,MISO,enable, input [DATA_LENGTH-1:0] data_in 
                    ,output SCK,MOSI,output reg [DATA_LENGTH-1:0] data_out);
    
    
    reg [DATA_LENGTH:0] data_reg;
    reg [2:0] counter;
    reg tx_en_latch;

    always @(*) begin

        if(!sys_clk)
            tx_en_latch<=enable;    
        
    end

    always@(posedge sys_clk,negedge rst_n) begin
    if(!rst_n) begin
    counter<=0;
    end

    else if(enable) begin
    counter<=counter+1;
    end
    else
    counter<=0;
    end  

    generate

    if (!CPHA) begin    
      
    always@(negedge rst_n or posedge sys_clk) begin
        
        if(!rst_n)
        data_reg[DATA_LENGTH]<=0;

        else if (enable)
        data_reg[DATA_LENGTH]<=MISO;


    end

    always @(negedge rst_n or negedge sys_clk) begin

            if(!rst_n) begin
            data_reg[DATA_LENGTH-1:0]<=0;
            end 

            else if(enable && counter==0) begin
            data_reg[DATA_LENGTH-1:0]<=data_in;
            end

            else if(enable) begin

            data_reg[DATA_LENGTH-1:0]<={data_reg[DATA_LENGTH],data_reg[DATA_LENGTH-1:1]};

            end          

    end    

    always @(negedge sys_clk,negedge rst_n) begin
        if(!rst_n)
            data_out<=0;

        else if(!enable)
            data_out<=0;

        else if(counter==0 && enable)
            data_out<=data_reg[DATA_LENGTH:1]; 

    end 
    end

   else if (CPHA) begin    

    always@(negedge rst_n or negedge sys_clk) begin
        
        if(!rst_n)
        data_reg[DATA_LENGTH]<=0;

        else if(enable)
        data_reg[DATA_LENGTH]<=MISO;

    end

    always @(negedge rst_n or posedge sys_clk) begin

            if(!rst_n) begin
            data_reg[DATA_LENGTH-1:0]<=0;
            end 

            else if(enable && counter==0) begin
            data_reg[DATA_LENGTH-1:0]<=data_in;
            end

            else if(enable)
            
            begin

            data_reg[DATA_LENGTH-1:0]<={data_reg[DATA_LENGTH],data_reg[DATA_LENGTH-1:1]};

            end          

    end    
    always @(posedge sys_clk,negedge rst_n) begin
        if(!rst_n)
            data_out<=0;

        else if(!enable)
            data_out<=0;
        
            else if(counter==0 && enable)
            data_out<=data_reg[DATA_LENGTH:1]; 

    end
    
    end


    if(CPOL) begin
    assign SCK= ~(sys_clk && tx_en_latch);

    end

    else if(!CPOL) begin
    assign SCK= (sys_clk && tx_en_latch);

    end

    endgenerate

    assign MOSI = data_reg[0];

endmodule