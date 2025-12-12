module SPI_slave #(parameter DATA_LENGTH=8,CPOL = 0, CPHA = 0)(input SS,SCK,MOSI,input [DATA_LENGTH-1:0] data_in,
output MISO,output reg[DATA_LENGTH-1:0] data_out);
    
    
    (*noprune*) reg [DATA_LENGTH:0] data_reg; 
    (*noprune*) reg [2:0] counter;  
    

    generate

    if (!(CPHA ^ CPOL)) begin    
    
    always@(posedge SCK,posedge SS) begin
    if(SS) begin
    counter<=0;
    end

    else begin
    counter<=counter+1;
    end
    end

    always@(posedge SS or posedge SCK) begin
        
        if(SS)
        data_reg[DATA_LENGTH]<=0;

        else
        data_reg[DATA_LENGTH]<=MOSI;


    end

    always @(posedge SS or negedge SCK) begin

            if(SS) begin
            data_reg[DATA_LENGTH-1:0]<=0;
            end 

            else if(counter==0) begin
            data_reg[DATA_LENGTH-1:0]<=data_in;
            end

            else  begin

            data_reg[DATA_LENGTH-1:0]<={data_reg[DATA_LENGTH],data_reg[DATA_LENGTH-1:1]};

            end          

    end    


    always @(negedge SCK,posedge SS) begin
        if(SS)
            data_out<=0;

        else if(counter==0)
            data_out<=data_reg[DATA_LENGTH:1]; 

    end

    end 

    
   else if (CPHA ^ CPOL) begin    

    always@(negedge SCK,posedge SS) begin
    if(SS) begin
    counter<=0;
    end

    else begin
    counter<=counter+1;
    end
    end


    always@(posedge SS or negedge SCK) begin
        
        if(SS)
        data_reg[DATA_LENGTH]<=0;

        else 
        data_reg[DATA_LENGTH]<=MOSI;

    end

    always @(posedge SS or posedge SCK) begin

            if(SS) begin
            data_reg[DATA_LENGTH-1:0]<=0;
            end 

            else if(counter==0) begin
            data_reg[DATA_LENGTH-1:0]<=data_in;
            end

            else
            
            begin

            data_reg[DATA_LENGTH-1:0]<={data_reg[DATA_LENGTH],data_reg[DATA_LENGTH-1:1]};

            end          

    end    
    always @(posedge SCK,posedge SS) begin
        if(SS)
            data_out<=0;   

        else if(counter==0)
            data_out<=data_reg[DATA_LENGTH:1]; 

    end         

    end

    endgenerate


    assign MISO =(SS)?1'b0:data_reg[0];
endmodule