function [lst,lbublst,skip]...
    = call_select_range(clbrsr,mlbub,lst,row,cpg,filepathmf,modelst,fca,bg,sb,sbem,sret,lbublst,...
    crit_temp,colabs)

switch sret
    case 0
        if mlbub==1
            lbghz=lbublst(1,1,cpg);
            ubghz=lbublst(1,2,cpg);
            if ((lst(end,1)<lbghz) || (lst(1,1) >ubghz || lst(1,1)<0))%completely outside range 
                skip=1;
                lb=1;ub=length(lst(:,1));
                disp('completely out');
            else
                skip=0;
                if lst(1,1)>lbghz
                    lb=1;
                else
                    lb=find(lst(:,1)>lbghz,1,'first');
                end
                if lst(end,1) < ubghz
                    ub=length(lst(:,1));
                else
                    ub=find(lst(:,1)<ubghz,1,'last');
                end
            end
        else
            lb=1;ub=length(lst(:,1));
        end
        lst=lst(lb:ub,:);
    case 1
        figure(10);
        plot(lst(:,1),lst(:,4));
        [lb,ub]=call_cutlst(lst,filepathmf,modelst,cpg,fca,bg,sb,sbem,row,sret,colabs,clbrsr);
        lst=lst(lb:ub,:);
        skip=0;
end;
lbublst(row,:,cpg)=[lst(2,1),lst(end-1,1)];











           