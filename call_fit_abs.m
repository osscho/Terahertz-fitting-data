function [fit_parameters,igout,plotdata] = call_fit_abs(lst,ig,sret,awig,colabs) %pig=revious init guess


if (sret==1 || awig==1)
    IL=max(lst(:,colabs)).^2;
    f0ind=find(lst(:,colabs)==max(lst(:,colabs)));
    f0=lst(f0ind);
    [indrowl,indcoll]=find(lst(:,colabs)>max(lst(:,colabs))/2,1,'first');
    [indrowr,indcolr]=find(lst(:,colabs)>max(lst(:,colabs))/2,1,'last');
    fB=lst(indrowr,1)-lst(indrowl,1);
    if fB==0
        fB=100/1000000000;
    end;
    y0=lst(10,colabs);
    ig=[IL*fB,fB,f0,y0];
else
    ig=ig(1:4);
end

objfcn=@(v,f)(2/pi)*v(1)*v(2)./(4*(f-v(3)).^2+v(2)^2)+v(4); %L0=v(1);fB=v(2);f0=v(3);y0=v(4)
%right fit function: objfcn=@(v,f)(2/3.14159)*v(1)*v(2)./(v(2)^2+4*(f-v(3)).^2)+v(4);
%to find init guess for amplitude use a0/fB, actually it should be a0*fB
opt=optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','TolFun',1E-20,'MaxFunEvals',100000,'MaxIter',10000);
[vfit,resnorm] = lsqcurvefit(objfcn,ig,lst(:,1),lst(:,colabs).^2,[],[],opt);
objfcn_fit=objfcn(vfit,lst(:,1));
igout=[vfit(1),vfit(2),vfit(3),vfit(4),1,1,1,1,1,1];    

f0fit=vfit(3);fBfit=vfit(2);Qfit=f0fit/fBfit;
fit_parameters=[f0fit,fBfit,Qfit];

plotdata=cat(2,[],lst(:,1),objfcn_fit);

