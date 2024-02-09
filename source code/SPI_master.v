module SPI_master #(parameter DATA_LENGTH=8,CPOL = 0, CPHA = 0)(input sys_clk,rst_n,MISO, input [DATA_LENGTH-1:0] data_in 
                    ,output reg SCK,output MOSI,read_available,output [DATA_LENGTH-1:0] data_out);
    
    
    reg [DATA_LENGTH:0] data_reg;
    reg write_en; 
    reg [5:0] counter;
 

        always@(negedge sys_clk,negedge rst_n) begin
        if(!rst_n) begin
        counter<=0;
        write_en<=1;
        end
        else if(counter==DATA_LENGTH) begin
        counter<=0;
        write_en<=1;
        end

        else begin
        counter<=counter+1;
        write_en<=0;
        end
    end    
   
    always@(*) begin
        
        if(CPOL)
        SCK= ~(sys_clk && !write_en);

        else if(!CPOL)
        SCK= (sys_clk && !write_en);


    end

    generate

    if (!CPHA) begin    
    always@(negedge rst_n or posedge sys_clk) begin
        
        if(!rst_n)
        data_reg[DATA_LENGTH]<=0;

        else
        data_reg[DATA_LENGTH]<=MISO;


    end

    always @(negedge rst_n or negedge sys_clk) begin

            if(!rst_n) begin
            data_reg[DATA_LENGTH-1:0]<=0;
            end 

            else if(write_en) begin
            data_reg[DATA_LENGTH-1:0]<=data_in;
            end

            else begin

            data_reg[DATA_LENGTH-1:0]={data_reg[DATA_LENGTH],data_reg[DATA_LENGTH-1:1]};

            end          

    end    

    end

   else if (CPHA) begin    
    always@(negedge rst_n or negedge sys_clk) begin
        
        if(!rst_n)
        data_reg[DATA_LENGTH]<=0;

        else if(write_en)
        data_reg[DATA_LENGTH]<=data_in[DATA_LENGTH-1];

        else
        data_reg[DATA_LENGTH]<=MISO;

    end

    always @(negedge rst_n or posedge sys_clk) begin

            if(!rst_n) begin
            data_reg[DATA_LENGTH-1:0]<=0;
            end 

            else if(write_en) begin
            data_reg[DATA_LENGTH-1:1]<=data_in[DATA_LENGTH-2:0];
            end

            else 
            
            begin

            data_reg[DATA_LENGTH-1:0]={data_reg[DATA_LENGTH],data_reg[DATA_LENGTH-1:1]};

            end          

    end    

    end

    endgenerate

    assign read_available=write_en;
    assign MOSI = data_reg[0];
    assign data_out=CPHA? data_reg[DATA_LENGTH:1]:data_reg[DATA_LENGTH-1:0];    

endmodule