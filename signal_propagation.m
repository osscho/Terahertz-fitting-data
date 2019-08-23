function [res] =signal_propagation()

path='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(0.7)_4.2.2016\measurement2\';
[filename,pathname]=uigetfile(strcat(path,'*.dat'),'MultiSelect','on');

if iscell(filename)
    l=length(filename);
else
    l=1;
end;
%initialize result array
res=ones(l,2); %mode propagation time

for i=1:1:l
    if l>1
        b=importdata(strcat(pathname,filename{i}));b=b.data;
    else
        b=importdata(strcat(pathname,filename));b=b.data;
    end;
    f_v=b(:,1)/10^9;

    %border
    figure(1);
    plot(f_v,b(:,2));hold on;plot(f_v,b(:,3));hold off;
    %inp1=inputdlg('enter value for lower bound','poll');
    %inp2=inputdlg('enter value for upper bound','poll');
    %ll=str2num(inp1{1});ul=str2num(inp2{1}); %ll: lower limit;ul: upper limit
    [xpts,ypts]=getpts(figure(1));
    while length(xpts)~=2
        msgbox('you have to select two points','error','modal');
        figure(1);
        plot(f_v,b(:,2));hold on;plot(f_v,b(:,3));hold off;
        [xpts,ypts]=getpts(figure(1));
    end;
    ll=xpts(1);
    ul=xpts(2);
    if ll>ul
        ll=f_v(1);
        ul=f_v(end);
    end;
    n=1;
    while f_v(n)<ll
        n=n+1;
        if n==length(f_v)-5
            n=1;
            break;
        end;
    end;
    lb=n;
    n=1;
    while f_v(n)<ul
        n=n+1;
        if n==length(f_v)-5
            n=length(f_v);
            break;
        end;
    end;
    ub=n;
    if lb>ub
        lb=1;
        ub=length(f_v);
    end;
    %get D1 parameter
    d1re=max(b(lb:ub,2))
    d1im=max(b(lb:ub,3))
    
    %get phase
    re=b(lb:ub,2);im=b(lb:ub,3);f_vc=f_v(lb:ub);
    figure(1);plot(f_vc,re);hold on;plot(f_vc,im);hold off;legend('re','im');
    phse=angle(complex(re,im));
    phse_lin=unwrap(phse);
    figure(2);plot(f_vc,phse_lin);
    %init guess
    m0=(phse_lin(end)-phse_lin(1))/(f_vc(end)-f_vc(1));
    y0=phse_lin(1)-m0*f_vc(1);
    initguess=[m0,y0];

    %fitting
    obj_fcn=@(v,f)v(1)*f+v(2); %m=v(1);y0=v(2)
    opts=optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','MaxFunEvals',100000);
    [vfit,resnorm]=lsqcurvefit(obj_fcn,initguess,f_vc,phse_lin,[],[],opts);
    figure(2);
    plot(f_vc,phse_lin);
    hold on;
    plot(f_vc,obj_fcn(vfit,f_vc));
    text(f_vc(1)+(f_vc(end)-f_vc(1))/2,phse_lin(1)+(phse_lin(end)-phse_lin(1))/6,strcat('t_s=',num2str(abs(vfit(1))),' ns'));
    legend('data','fit');
    hold off;
    %add to result array
    res(i,:)=[i,abs(vfit(1))];
    phse_lin(1)
end;

if l>1
    figure(3);
    plot(res(:,1),res(:,2),'o');
    xlabel('mode no.');
    ylabel('propagation time');
end;