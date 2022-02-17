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
reg [3:0] cnt,load;
reg signed[10:0] a,b,c,d;
reg signed[20:0] vector,vector1;
always @(*) begin
    if(cur == 0)begin
        if(st0_finish == 1)begin
            next = 1;
        end
        else begin
            next = 0;
        end
    end
    else if (cur == 1) begin
        if(st1_finish == 1)begin
            next = 2;
        end
        else begin
            next = 1;
        end
    end
    else begin
        if(st2_finish == 1)begin
            next = 0;
        end
        else begin
            next = 2;
        end
    end
end
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
            if(cnt == 0)begin//sort 0,1,2
                load <= load + 1;
                if(load == 0)begin
                    a <= dx[1];
                    c <= dx[0];
                    b <= dy[2];
                    d <= dy[0];
                end
                else if(load == 1)begin
                    vector1 <= vector;
                    a <= dy[1];
                    c <= dy[0];
                    b <= dx[2];
                    d <= dx[0];
                end
                else if(load == 2)begin
                    if(vector1 - vector >= 0)begin
                        dx[1] <= dx[2];
                        dx[2] <= dx[1];
                        dy[1] <= dy[2];
                        dy[2] <= dy[1];
                    end
                    cnt <= cnt + 1;
                    load <= 0;
                end
            end
            else if(cnt == 1)begin//sort 0,1,2,3
                load <= load + 1;
                if(load == 0)begin
                    a <= dx[1];
                    c <= dx[0];
                    b <= dy[3];
                    d <= dy[0];
                end
                else if(load == 1)begin
                    vector1 <= vector;
                    a <= dy[1];
                    c <= dy[0];
                    b <= dx[3];
                    d <= dx[0];
                end
                else if(load == 2)begin
                    if(vector1 - vector < 0)begin//compare 2,3
                        a <= dx[2];
                        c <= dx[0];
                        b <= dy[3];
                        d <= dy[0];
                    end
                    else begin
                        dx[1] <= dx[3];
                        dx[2] <= dx[1];
                        dx[3] <= dx[2];
                        dy[1] <= dy[3];
                        dy[2] <= dy[1];
                        dy[3] <= dy[2];
                        cnt <= cnt + 1;
                        load <= 0;
                    end
                end
                else if(load == 3)begin
                    vector1 <= vector;
                    a <= dy[2];
                    c <= dy[0];
                    b <= dx[3];
                    d <= dx[0];
                end
                else if(load == 4)begin
                    if(vector1 - vector >= 0)begin
                        dx[2] <= dx[3];
                        dx[3] <= dx[2];
                        dy[3] <= dy[2];
                        dy[2] <= dy[3];
                    end
                    cnt <= cnt + 1;
                    load <= 0;
                end
            end
            else if(cnt <= 2)begin//sort 0,1,2,3,4
                load <= load + 1;
                if(load == 0)begin
                    a <= dx[1];
                    c <= dx[0];
                    b <= dy[4];
                    d <= dy[0];
                end
                else if(load == 1)begin
                    vector1 <= vector;
                    a <= dy[1];
                    c <= dy[0];
                    b <= dx[4];
                    d <= dx[0];
                end
                else if(load == 2)begin
                    if(vector1 - vector < 0)begin//compare 2,4
                        a <= dx[2];
                        c <= dx[0];
                        b <= dy[4];
                        d <= dy[0];
                    end
                    else begin
                        dx[1] <= dx[4];
                        dx[2] <= dx[1];
                        dy[1] <= dy[4];
                        dy[2] <= dy[1];
                        dx[3] <= dx[2];
                        dy[3] <= dy[2];
                        dx[4] <= dx[3];
                        dy[4] <= dy[3];
                        cnt <= cnt + 1;
                        load <= 0;
                    end
                end
                else if(load == 3)begin
                    vector1 <= vector;
                    a <= dy[2];
                    c <= dy[0];
                    b <= dx[4];
                    d <= dx[0];
                end
                else if(load == 4)begin
                    if(vector1 - vector < 0)begin//compare 3,4
                        a <= dx[3];
                        c <= dx[0];
                        b <= dy[4];
                        d <= dy[0];
                    end
                    else begin
                        dx[2] <= dx[4];
                        dx[3] <= dx[2];
                        dy[3] <= dy[2];
                        dy[2] <= dy[4];
                        dx[4] <= dx[3];
                        dy[4] <= dy[3];
                        cnt <= cnt + 1;
                        load <= 0;
                    end
                end
                else if(load == 5)begin
                    vector1 <= vector;
                    a <= dy[3];
                    c <= dy[0];
                    b <= dx[4];
                    d <= dx[0];
                end
                else if(load == 6)begin
                    if(vector1 - vector >= 0)begin//compare 3,4
                        dx[3] <= dx[4];
                        dx[4] <= dx[3];
                        dy[3] <= dy[4];
                        dy[4] <= dy[3];
                    end
                    load <= 0;
                    cnt <= cnt + 1;
                end
            end
            else if(cnt == 3)begin
                load <= load + 1;
                if(load == 0)begin
                    a <= dx[1];
                    c <= dx[0];
                    b <= dy[5];
                    d <= dy[0];
                end
                else if(load == 1)begin
                    vector1 <= vector;
                    a <= dy[1];
                    c <=  dy[0];
                    b <= dx[5];
                    d <= dx[0];
                end
                else if(load == 2)begin
                    if(vector1 - vector < 0)begin//compare 2,5
                        a <= dx[2];
                        c <= dx[0];
                        b <= dy[5];
                        d <= dy[0];
                    end
                    else begin
                        dx[1] <= dx[5];
                        dx[2] <= dx[1];
                        dy[1] <= dy[5];
                        dy[2] <= dy[1];
                        dx[3] <= dx[2];
                        dy[3] <= dy[2];
                        dx[4] <= dx[3];
                        dy[4] <= dy[3];
                        dx[5] <= dx[4];
                        dy[5] <= dy[4];
                        st1_finish <= 1;
                        cnt <= 0;
                        load <= 0;
                    end
                end
                else if(load == 3)begin
                    vector1 <= vector;
                    a <= dy[2];
                    c <= dy[0];
                    b <= dx[5];
                    d <= dx[0];
                end
                else if(load == 4)begin
                    if(vector1 - vector < 0)begin//compare 3,5
                        a <= dx[3]; 
                        c <= dx[0];
                        b <= dy[5];
                        d <= dy[0];
                    end
                    else begin
                        dx[2] <= dx[5];
                        dx[3] <= dx[2];
                        dy[3] <= dy[2];
                        dy[2] <= dy[5];
                        dx[4] <= dx[3];
                        dy[4] <= dy[3];
                        dx[5] <= dx[4];
                        dy[5] <= dy[4];
                        cnt <= 0;
                        load <= 0;
                        st1_finish <= 1;
                    end
                end
                else if(load == 5)begin
                    vector1 <= vector;
                    a <= dy[3];
                    c <= dy[0];
                    b <= dx[5];
                    d <= dx[0];
                end
                else if(load == 6)begin
                    if(vector1 - vector < 0)begin//compare 4,5
                        a <= dx[4];
                        c <= dx[0];
                        b <= dy[5];
                        d <= dy[0];
                    end
                    else begin
                        dx[3] <= dx[5];
                        dx[4] <= dx[3];
                        dy[3] <= dy[5];
                        dy[4] <= dy[3];
                        dx[5] <= dx[4];
                        dy[5] <= dy[4];
                        cnt <= 0;
                        load <= 0;
                        st1_finish <= 1;
                    end
                end
                else if(load == 7)begin
                    vector1 <= vector;
                    a <= dy[4];
                    c <= dy[0];
                    b <= dx[5];
                    d <= dx[0];
                end
                else if(load == 8)begin
                    if(vector1 - vector >= 0)begin
                        dx[4] <= dx[5];
                        dx[5] <= dx[4];
                        dy[4] <= dy[5];
                        dy[5] <= dy[4];
                    end
                    cnt <= 0;
                    load <= 0;
                    st1_finish <= 1;
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