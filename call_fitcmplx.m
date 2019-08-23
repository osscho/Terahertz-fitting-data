function [fit_parameters,igout,plotdata] = call_fitcmplx(lst,ig);

f_v=lst(:,1);
initguess=[ig(1)+1i*ig(2);ig(3)+1i*ig(4);ig(5)+1i*ig(6);ig(7)+1i*ig(8);ig(9)+1i*ig(10)];

cplxydata=complex(lst(:,2),lst(:,3));

objfcn = @(v,f)exp(-v(1).*2.*pi.*1i.*f).*(v(2)./(f-v(3))+v(4)+v(5)*(f-real(v(3))));

opts = optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','MaxFunEvals',1000000,'MaxIter',10000,'TolFun',1E-20);
[vfit,resnorm] = lsqcurvefit(objfcn,initguess,f_v,cplxydata,[],[],opts);
objfcn_estimated=objfcn(vfit,f_v);
fB=imag(vfit(3))*2;
f0=real(vfit(3));
Q=f0/fB;
fit_parameters=[f0 fB Q];

igout=[real(vfit(1));imag(vfit(1));real(vfit(2));imag(vfit(2));real(vfit(3));imag(vfit(3));real(vfit(4));imag(vfit(4));real(vfit(5));imag(vfit(5))];

plotdata=cat(2,[],f_v,real(objfcn_estimated),imag(objfcn_estimated));

