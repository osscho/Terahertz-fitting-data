function [ret] =call_signal_propagation(lst)

%impstr=modelst(temp_i,mode_i);
%b=importdata(strcat(filepath,impstr{1}));
%b=b.data;
%f_v=b(:,1)/10^9;
f_v=lst(:,1);

%border
figure(1);
plot(f_v,lst(:,2));hold on;plot(f_v,lst(:,3));hold off;
[xpts,ypts]=getpts(figure(1));
while length(xpts)~=2
    msgbox('you have to select two points','error','modal');
    figure(1);
    plot(f_v,lst(:,2));hold on;plot(f_v,lst(:,3));hold off;
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
d1re=max(lst(lb:ub,2));
d1im=max(lst(lb:ub,3));
  
%get phase
re=lst(lb:ub,2);im=lst(lb:ub,3);f_vc=f_v(lb:ub);
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

ret=abs(vfit(1));