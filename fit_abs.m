function [fit_parameters] = fit_abs() %pig=revious init guess

colabs=4;
root='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\test_NbSTO_wt0.35(15.07.2016)_VTI\run1\'
[filename,pathname]=uigetfile({'*.dat'},'choose file',root,'MultiSelect','off');
lst=importdata(strcat(pathname,filename));
lst=lst.data;
lst(:,1)=lst(:,1)/10^9;


IL=max(lst(:,4)).^2;
f0ind=find(lst(:,4)==max(lst(:,4)));
f0=lst(f0ind);
[indrowl,indcoll]=find(lst(:,colabs)>max(lst(:,colabs))/2,1,'first');
[indrowr,indcolr]=find(lst(:,colabs)>max(lst(:,colabs))/2,1,'last');
fB=lst(indrowr,1)-lst(indrowl,1);
if fB==0
    fB=100/1000000000;
end;
y0=lst(10,colabs);
ig=[IL*fB,fB,f0,y0];


objfcn=@(v,f)(2/pi)*v(1)*v(2)./(4*(f-v(3)).^2+v(2)^2)+v(4); %L0=v(1);fB=v(2);f0=v(3);y0=v(4)
%right fit function: objfcn=@(v,f)(2/3.14159)*v(1)*v(2)./(v(2)^2+4*(f-v(3)).^2)+v(4);
%to find init guess for amplitude use a0/fB, actually it should be a0*fB
opt=optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','MaxFunEvals',100000);
[vfit,resnorm] = lsqcurvefit(objfcn,ig,lst(:,1),lst(:,colabs).^2,[],[],opt);
objfcn_fit=objfcn(vfit,lst(:,1));
igout=[vfit(1),vfit(2),vfit(3),vfit(4),1,1,1,1,1,1];    

f0fit=vfit(3);fBfit=vfit(2);Qfit=f0fit/fBfit;
fit_parameters=[f0fit,fBfit,Qfit];

plotdata=cat(2,[],lst(:,1),objfcn_fit);
figure(1);
plot(lst(:,1),lst(:,4).^2,'o','MarkerSize',1);
hold on
plot(lst(:,1),plotdata(:,2))
legend('data','fit')
hold off

