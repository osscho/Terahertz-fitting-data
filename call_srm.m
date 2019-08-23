function [lb,ub,lst] = call_srm(filepath,modelst,temp_i,clbrsr)

lst=importdata(strcat(filepath,modelst{temp_i,clbrsr}));lst=lst.data;lst(:,1)=lst(:,1)/10^9;
figure(3);plot(lst(:,1),lst(:,2),'o','MarkerSize',2);hold on;plot(lst(:,1),lst(:,3),'o','MarkerSize',2);plot(lst(:,1),lst(:,4),'o','MarkerSize',2);l=legend(strcat('re_i=',num2str(temp_i)),'im_srm','abs','Location','Southwest');set(l,'Interpreter','none');hold off;drawnow;
xpts=inputdlg({'lb','ub'},'enter frequencies',[1 50],{'1','10'});
lb=str2num(xpts{1});ub=str2num(xpts{2});

if lb<lst(2,1)
    lb=2;
    disp('out of range')
else
    lb=find(lst(:,1)>lb,1,'first');
end    

if ub>lst(end-1,1)
    disp('out of range')
    ub=lst(end-1,1);
else
    ub=find(lst(:,1)>ub2,1,'first');lst=lst(lb:ub,:);
end
