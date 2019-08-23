function [iglst,fitreslst,plotdata,next_row,lbublst,lst,lst0,ls]...
    = call_ig_thoroughly_cases(lst,lst0,filepathmf,modelst,cpg,fca,bg,sb,sbem,sret,clbrsr,col,temps,row,...
    fitreslst,iglst,lbublst,stwt1,torb,colabs,fields,wt,awig)
%enter length if torb=2
if torb==2
    str=strcat('enter length of structure (in mm without unit;',modelst(1,cpgimp),')');
    inp=inputdlg(str,'title',[1 120],{'2.5'});
    ls=str2num(inp{1});
else
    ls=1;
end

if (clbrsr==3 && col~=1)
    if wt==1
        qd='same';
    else
        qd=questdlg(strcat('previous range:',num2str(lbublst(1,1,cpg-1)),' GHz to ',num2str(lbublst(1,2,cpg-1)),' GHz. Same or new range?'),...
        'title','same','new','same');
    end
    if strcmpi(qd,'same')
        lbghz=lbublst(1,1,cpg-1);
        ubghz=lbublst(1,2,cpg-1);
        lb=find(lst(:,1)>lbghz,1,'first');
        ub=find(lst(:,1)<ubghz,1,'last');
    else
       [lb,ub] = call_cutlst(lst,filepathmf,modelst,cpg,fca,bg,sb,sbem,row,sret,colabs,clbrsr);%not needed?       
    end
    lst=lst(lb:ub,:);
    %lbublst(row,:,cpg)=[lst(2,1),lst(end-1,1)];    
    lbublst(1,:,cpg)=[lst(2,1),lst(end-1,1)];
    switch fca
        case 0
            [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(row,:,cpg-1));
        case 1
            [fit_parameters,igout,plotdata]=call_fit_abs(lst,iglst(row,:,cpg-1),sret,awig,colabs)
    end
    call_plot_data(fca,lst,plotdata,row,sb,lst0,colabs);
    if wt==1
        qd='Yes';
    else
        qd=questdlg('continue with next temp?','title','Yes','new ig','Yes');
    end
    if strcmpi(qd,'Yes')
        next_row=1;
    else
        [fit_parameters,igout,plotdata,next_row]=call_ig_thoroughly(lst,row,clbrsr,cpg,fca,sb,lst0,colabs);
    end
else
    if stwt1==1
        [lb,ub] = call_cutlst(lst,filepathmf,modelst,cpg,fca,bg,sb,sbem,row,sret,colabs,clbrsr);%not needed?
        lst=lst(lb:ub,:);
    end 
    [lb,ub] = call_cutlst(lst,filepathmf,modelst,cpg,fca,bg,sb,sbem,row,sret,colabs,clbrsr);
    lst=lst(lb:ub,:);
    lbublst(row,:,cpg)=[lst(2,1),lst(end-1,1)]; 
    switch fca
        case 0
            [fit_parameters,igout,plotdata,next_row]=call_ig_thoroughly(lst,row,clbrsr,col,fca,sb,lst0,colabs);
        case 1
            [fit_parameters,igout,plotdata,next_row]=call_ig_fitabs(lst,fca,row,sb,lst0,sret,colabs);
    end
end
iglst(row,:,cpg)=igout;
if clbrsr~=3
    fitreslst(row,:,cpg)=[temps(row),fit_parameters];        
else
    fitreslst(row,:,cpg)=[fields(row),fit_parameters];        
end
    



