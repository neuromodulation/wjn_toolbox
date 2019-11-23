function [rcv,rgof,pr] = wjn_fitpower1(x,y,ni)

if ~exist('ni','var')
    ni = 1000;
end

if ~exist('y','var') || isempty(y)
    y = [1:size(x,1)]';
end



for a = 1:size(x,2)
    [rr,rgof]=fit(x(:,a),y(:,1),'power1');
    rcv = feval(rr,x(:,a));
%     keyboard
    r(1,a) = rgof.rsquare;
    for b = 2:ni+1
        y(:,b) = y(randperm(size(y,1)));      
            [~,gof]=fit(x(:,a),y(:,b),'power1');
            r(b,a) = gof.rsquare;
          
    end
    disp([num2str(a) ' / ' num2str(size(x,2)) ' done'])
end


for a = 1:size(x,2)
    srn=sort(r(2:end,a));
    pr(a) = 1-wjn_sc(srn,abs(r(1,a)))/ni;
end



