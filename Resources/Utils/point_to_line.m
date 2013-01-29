function d = point_to_line(pt, v1, v2)
% a = v1 - v2;
% b = pt - v2;
% d = norm(cross(a,b)) / norm(a);
% 
% 
% d = abs(cross(v2-v1,pt-v1))/abs(v2-v1);

 d = abs(det([v2-v1;pt-v1]))/norm(v2-v1);
 
 
 % def dist(x1,y1, x2,y2, x3,y3): # x3,y3 is the point
 
 
 x1 = v1(1);
 y1 = v1(2);
 x2 = v2(1);
 y2 = v2(2);
 x3 = pt(1);
 y3 = pt(2);
 
 px = x2-x1;
 py = y2-y1;

something = px*px + py*py;

    u =  ((x3 - x1) * px + (y3 - y1) * py) / something;

    if u > 1
        u = 1;
    elseif u < 0
        u = 0;
    end

    x = x1 + u * px;
    y = y1 + u * py;

    dx = x - x3;
    dy = y - y3;

    d = sqrt(dx*dx + dy*dy);
