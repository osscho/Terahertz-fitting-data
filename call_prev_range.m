function [lstnew,lbghz] = call_prev_range(lst,lbublst,temp_i,cpg)

lbghz=lbublst(temp_i-1,1,cpg);
ubghz=lbublst(temp_i-1,2,cpg);

if ubghz>lst(end,1)
    lb=1;
    ub=length(lst(:,1));
else
    lb=find(lst(:,1)>lbghz,1,'first');
    ub=find(lst(:,1)<ubghz,1,'last');
end

lstnew=lst(lb:ub,:);
