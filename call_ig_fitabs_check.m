function [fit_parameters,igout,plotdata,next_t] = call_ig_fitabs_check(lst,fca,temp_i,sb,lst0,ig,colabs)

ig=ig(1:4);
cont=1;
while cont==1;
    objfcn=@(v,f)(2/pi)*v(1)*v(2)./(4*(f-v(3)).^2+v(2)^2)+v(4); %L0=v(1);fB=v(2);f0=v(3);y0=v(4)
    %right fit function: objfcn=@(v,f)(2/3.14159)*v(1)*v(2)./(v(2)^2+4*(f-v(3)).^2)+v(4);
    %to find init guess for amplitude use a0/fB, actually it should be a0*fB
    opt=optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','MaxFunEvals',100000,'TolFun',1E-20');
    [vfit,resnorm] = lsqcurvefit(objfcn,ig,lst(:,1),lst(:,colabs).^2,[],[],opt);
    objfcn_fit=objfcn(vfit,lst(:,1));
    plotdata=cat(2,[],lst(:,1),objfcn_fit);
    call_plot_data(fca,lst,plotdata,temp_i,sb,lst0,colabs);

    qd=questdlg('take this fit?','title','Yes','No','Yes');
    if strcmpi(qd,'Yes')
        cont=0;next_t=1;
    else
        ig_st={num2str(ig(1)),num2str(ig(2)),num2str(ig(3)),num2str(ig(4))};
        ip=inputdlg({'IL*fB','fB','f0','y0'},'enter ig by hand',[1 50],ig_st);
        ip1=str2num(ip{1});ip2=str2num(ip{2});ip3=str2num(ip{3});ip4=str2num(ip{4});
        ig=[ip1,ip2,ip3,ip4];
        ig_st={ip{1},ip{2},ip{3},ip{4}};
        cont=1;
    end;
end
    
igout=[vfit(1),vfit(2),vfit(3),vfit(4),1,1,1,1,1,1];    

f0fit=vfit(3);fBfit=vfit(2);Qfit=f0fit/fBfit;
fit_parameters=[f0fit,fBfit,Qfit];

plotdata=cat(2,[],lst(:,1),objfcn_fit);




