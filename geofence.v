module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output valid;
output is_inside;
reg valid;
reg is_inside;

reg signed [10:0]datax[5:0],datay[5:0];
reg signed [10:0]xr,yr;
reg [3:0]load;
reg [1:0]state;
//0:load data 1:bubble sort 2 :count
reg signed[20:0]ans;
reg signed [10:0]a,b,c,d;
reg signed[20:0]vec1;
reg [2:0]neg,pos;
always @(posedge clk or posedge reset) begin
    if(reset)begin
        valid <= 1'd0;
        is_inside <= 1'd0;
        load <= 5'd0;
        state <= 4'd0;
        neg <= 3'd0;
        pos <= 3'd0;
    end
    else begin
        case (state)
        2'd0:begin
            load <= load + 5'b1;
            if(load == 5'd0)begin
                xr <= X;
                yr <= Y;
            end
            else if (load <= 5'd6) begin
                datax[load - 5'd1] <= X;
                datay[load - 5'd1] <= Y;
            end
            else begin
                state <= 2'd1;
                load <= 5'd0;
            end
        end
        2'd1:begin
            //v1vXvv2
            if(load == 5'd0)begin
                a <= datax[1];
                b <= datax[0];
                c <= datay[2];
                d <= datay[0];
                load <= load +5'd1;
            end
            else if(load == 5'd1)begin
                vec1 <= ans;
                a <= datax[2];
                b <= datax[0];
                c <= datay[1];
                d <= datay[0];
                load <= load +5'd1;
            end
            else if (load == 5'd2) begin
                if(vec1 > ans)begin//逆時針
                    datax[1] <= datax[2];
                    datax[2] <= datax[1];
                    datay[1] <= datay[2];
                    datay[2] <= datay[1];
                    load <= 0;
                end
                else begin
                    load <= load +5'd1;
                end
            end
            else if(load == 5'd3) begin
                a <= datax[2];
                b <= datax[0];
                c <= datay[3];
                d <= datay[0];
                load <= load +5'd1;
            end
            else if(load == 5'd4)begin
                vec1 <= ans;
                a <= datax[3];
                b <= datax[0];
                c <= datay[2];
                d <= datay[0];
                load <= load +5'd1;
            end
            else if (load == 5'd5) begin
                if(vec1 > ans)begin//逆時針
                    datax[2] <= datax[3];
                    datax[3] <= datax[2];
                    datay[2] <= datay[3];
                    datay[3] <= datay[2];
                    load <= 0;
                end
                else begin
                    load <= load +5'd1;
                end
            end
            else if(load == 5'd6) begin
                a <= datax[3];
                b <= datax[0];
                c <= datay[4];
                d <= datay[0];
                load <= load +5'd1;
            end
            else if(load == 5'd7)begin
                vec1 <= ans;
                a <= datax[4];
                b <= datax[0];
                c <= datay[3];
                d <= datay[0];
                load <= load +5'd1;
            end
            else if (load == 5'd8) begin
                if(vec1 > ans)begin//逆時針
                    datax[3] <= datax[4];
                    datax[4] <= datax[3];
                    datay[3] <= datay[4];
                    datay[4] <= datay[3];
                    load <= 0;
                end
                else begin
                    load <= load +5'd1;
                end
            end
            else if(load == 5'd9) begin
                a <= datax[4];
                b <= datax[0];
                c <= datay[5];
                d <= datay[0];
                load <= load +5'd1;
            end
            else if(load == 5'd10)begin
                vec1 <= ans;
                a <= datax[5];
                b <= datax[0];
                c <= datay[4];
                d <= datay[0];
                load <= load +5'd1;
            end
            else if (load == 5'd11) begin
                if(vec1 > ans)begin//逆時針
                    datax[4] <= datax[5];
                    datax[5] <= datax[4];
                    datay[4] <= datay[5];
                    datay[5] <= datay[4];
                    load <= 0;
                end
                else begin
                    load <= load +5'd1;
                end
            end
            else if(load == 5'd12)begin
                //valid <= 1;
                state <= 2'd2;
                load <= 5'd0;
            end
        end
        2'd2:begin  //count
            load <= load + 5'd1;
            if(load == 5'd0)begin
                a <= xr;
                b <= datax[0];
                c <= datay[0];
                d <= datay[1];
            end
            else if (load == 5'd1) begin
                vec1 <= ans;
                a <= datax[0];
                b <= datax[1];
                c <= yr;
                d <= datay[0];
            end
            else if (load == 5'd2) begin
                if(vec1 < ans)begin
                    neg <= neg + 1; 
                end
                else begin
                    pos <= pos + 1;
                end
                a <= xr;
                b <= datax[1];
                c <= datay[1];
                d <= datay[2];
            end
            else if (load == 5'd3) begin
                vec1 <= ans;
                a <= datax[1];
                b <= datax[2];
                c <= yr;
                d <= datay[1];
            end
            else if (load == 5'd4) begin
                if(vec1 < ans)begin
                    neg <= neg + 1; 
                end
                else begin
                    pos <= pos + 1;
                end
                a <= xr;
                b <= datax[2];
                c <= datay[2];
                d <= datay[3];
            end
            else if (load == 5'd5) begin
                vec1 <= ans;
                a <= datax[2];
                b <= datax[3];
                c <= yr;
                d <= datay[2];
            end
            else if (load == 5'd6) begin
                if(vec1 < ans)begin
                    neg <= neg + 1; 
                end
                else begin
                    pos <= pos + 1;
                end
                a <= xr;
                b <= datax[3];
                c <= datay[3];
                d <= datay[4];
            end
            else if (load == 5'd7) begin
                vec1 <= ans;
                a <= datax[3];
                b <= datax[4];
                c <= yr;
                d <= datay[3];
            end
            else if (load == 5'd8) begin
                if(vec1 < ans)begin
                    neg <= neg + 1; 
                end
                else begin
                    pos <= pos + 1;
                end
                a <= xr;
                b <= datax[4];
                c <= datay[4];
                d <= datay[5];
            end
            else if (load == 5'd9) begin
                vec1 <= ans;
                a <= datax[4];
                b <= datax[5];
                c <= yr;
                d <= datay[4];
            end
            else if (load == 5'd10) begin
                if(vec1 < ans)begin
                    neg <= neg + 1; 
                end
                else begin
                    pos <= pos + 1;
                end
                a <= xr;
                b <= datax[5];
                c <= datay[5];
                d <= datay[0];
            end
            else if (load == 5'd11) begin
                vec1 <= ans;
                a <= datax[5];
                b <= datax[0];
                c <= yr;
                d <= datay[5];
            end
            else if (load == 5'd12) begin
                if(vec1 < ans)begin
                    neg <= neg + 1; 
                end
                else begin
                    pos <= pos + 1;
                end
            end
            else if (load == 5'd13) begin
                if(pos != 0 && neg != 0)begin
                    valid <= 1'd1;
                    is_inside <= 1'd0;
                end
                else begin
                    valid <= 1'd1;
                    is_inside <= 1'd1; 
                end
            end
            else begin
                load <= 5'd0;
                valid <= 1'd0;
                state <= 2'd0;
                neg <= 3'd0;
                pos <= 3'd0;
            end
        end
        endcase
    end
end

always @(*) begin
    ans = (a - b) * (c - d);
end

endmodule

