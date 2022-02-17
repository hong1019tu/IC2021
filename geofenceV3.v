module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output valid;
output is_inside;
reg valid;
reg is_inside;

reg signed [10:0] px,py;
reg signed[10:0] dx[5:0];
reg signed[10:0] dy[5:0];
reg [1:0] cur,next;//0:initial 1:sort 2:ans
reg st0_finish,st1_finish,st2_finish;
reg [2:0] cnt,load,num,i;
reg signed[10:0] a,b,c,d;
reg signed[20:0] vector,vector1;
// always @(*) begin
//     // if(cur == 0)begin
//     //     if(st0_finish == 1)begin
//     //         next = 1;
//     //     end
//     //     else begin
//     //         next = 0;
//     //     end
//     // end
//     // else if (cur == 1) begin
//     //     if(st1_finish == 1)begin
//     //         next = 2;
//     //     end
//     //     else begin
//     //         next = 1;
//     //     end
//     // end
//     // else begin
//     //     if(st2_finish == 1)begin
//     //         next = 0;
//     //     end
//     //     else begin
//     //         next = 2;
//     //     end
//     // end
// end
always @(*)begin
    vector = (a-c) * (b-d);
end
always @(posedge clk or posedge reset) begin
    if(reset)begin
        valid <= 0;
        is_inside <= 1;
        cur <= 0;
        st0_finish <= 0;
        st1_finish <= 0;
        st2_finish <= 0;
        cnt <= 0;
        load <= 0;
        num <= 1;
    end
    else begin
    cur <= next;
    case(cur) 
        0:begin
            cnt <= cnt + 1;
            if(cnt == 0)begin
                px <= {1'b0,X};
                py <= {1'b0,Y};
                st0_finish <= 0;
                st1_finish <= 0;
                st2_finish <= 0;
                load <= 0;
                is_inside <= 1;
                valid <= 0;
            end
            else begin
                dx[cnt-1] <= {1'b0,X};
                dy[cnt-1] <= {1'b0,Y};
            end
            if(cnt == 6)begin
                st0_finish <= 1;
                cnt <= -1;
            end
        end
        1:begin
            if(cnt == -1)cnt <= cnt + 1;
            else begin
                load <= load + 1;
                if(load == 0)begin
                    a <= dx[num];
                    c <= dx[0];
                    b <= dy[cnt+2];
                    d <= dy[0];
                end
                else if(load == 1)begin
                    vector1 <= vector;
                    a <= dy[num];
                    c <=  dy[0];
                    b <= dx[cnt+2];
                    d <= dx[0];
                    num <= num + 1; 
                end
                else if(load == 2)begin
                    if(vector1 - vector < 0)begin
                        load <= 0;
                        if(cnt == 3&&num == cnt+2)begin
                            st1_finish <= 1;
                            cnt <= 0;
                            num <= 1;
                        end
                        else if (num == cnt+2) begin
                            cnt <= cnt+1;
                            num <= 1;
                        end
                        else begin
                            
                        end
                    end
                    else begin
                        dx[num-1] <= dx[cnt+2];
                        dy[num-1] <= dy[cnt+2];
                        for ( i = 5 ; i>0 ;i=i-1 ) begin
                            if(i <= cnt+2 && i>num-1)begin
                                dx[i] <= dx[i-1];
                                dy[i] <= dy[i-1];
                            end
                        end
                        if(cnt == 3)begin
                            st1_finish <= 1;
                            cnt <= 0;
                            num <= 1;
                        end
                        else begin
                            cnt <= cnt + 1;
                            num <= 1;
                        end
                        load <= 0;
                    end
                end
            end
        end
        2:begin
            load <= load + 1;
            if(load == 1)begin
                a <= dx[cnt];
                c <= px;
                if(cnt != 5)begin
                    b <= dy[cnt+1];
                    d <= dy[cnt];
                end
                else begin
                    b <= dy[0];
                    d <= dy[cnt];
                end
            end
            else if (load == 2) begin
                vector1 <= vector;
                a <= dy[cnt];
                c <= py;
                if(cnt != 5)begin
                    b <= dx[cnt+1];
                    d <= dx[cnt];
                end
                else begin
                    b <= dx[0];
                    d <= dx[cnt];
                end 
            end
            else if(load == 3)begin
                load <= -1;
                if(cnt != 5)begin
                    cnt <= cnt + 1;
                end
                else begin
                    valid <= 1;
                    cnt <= 0;
                    st2_finish <= 1;
                    st0_finish <= 0;
                end
                if(vector1 - vector >= 0)begin
                    is_inside <= 0;
                end
            end
        end
    endcase
    end
end
endmodule