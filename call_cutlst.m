function [lb,ub] = call_cutlst(lst,filepathmf,modelst,cpg,fca,bg,sb,sbem,row,sret,colabs,clbrsr)


switch sret
    case 0
        legstr='first temperature';
        legstr2='last temperature';
    otherwise
        legstr=strcat('current temp: i=',num2str(row));
        legstr2='';
end
if clbrsr==3
    legstr='first field';
    legstr2='last field';
end
%lst_lt=list_last_temperature
try
    lst_lt=importdata(strcat(filepathmf,modelst{end-1,cpg}));
    lst_lt=lst_lt.data; 
    lst_lt(:,1)=lst_lt(:,1)/10^9; %import last file to see maximum shift in resonance frequency
catch
    questdlg('oh no! something went terribly wrong during import of last file! Debug list is plotted instead of last temp file','fatal crash!!!!','Ok','Ok')
    debuglst=1:1:10;
    lst_lt=transpose(cat(1,[],debuglst,debuglst,debuglst,debuglst.^2));
end
if sb==1
    [ret]=call_substr_bg(lst_lt,bg,sbem);lst_lt=ret;
end

title_str='pick start/stop';

%make plot
switch fca
    case 0 %fit complex
        figure(1)
        plot(lst(:,1),lst(:,2),'LineWidth',0.4)
        hold on
        plot(lst(:,1),lst(:,3),'LineWidth',0.4)
        plot(lst(:,1),lst(:,colabs).^2,'LineWidth',2)
        legend(legstr);
        title(title_str);
        hold off

        figure(2)
        plot(lst_lt(:,1),lst_lt(:,2),'LineWidth',0.4)
        hold on
        plot(lst_lt(:,1),lst_lt(:,3),'LineWidth',0.4)
        plot(lst_lt(:,1),lst_lt(:,colabs).^2,'LineWidth',2);
        legend(legstr2);
        hold off
    case 1
        figure(1)
        plot(lst(:,1),lst(:,colabs).^2,'MarkerSize',2)
        legend(legstr);
        title(title_str);
        figure(2)
        plot(lst_lt(:,1),lst_lt(:,colabs).^2,'MarkerSize',2)
        legend(legstr2);
end;


%select range
[xpts,ypts]=getpts(figure(1));
while (length(xpts) ~=2 || xpts(2)<xpts(1))
    msgbox('you have to choose two points/pick lower point at first','modal');
    [xpts,ypts]=getpts(figure(1));
end;
if xpts(1)<lst(1,1)
    lb=1;
    disp('outside range left')
else
    lb=find(lst(:,1)>xpts(1),1,'first');
    expl=0;
end;
if xpts(2)>lst(end,1)
    ub=length(lst);
    disp('outside range right')
else
    ub=find(lst(:,1)<xpts(2),1,'last');
end;


disp('close it')
close(figure(1));
close(figure(2));