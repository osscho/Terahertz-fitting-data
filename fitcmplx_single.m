function [fit_parameters,initguess,igout] = fitcmplx_single();

path='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(0.35)_09.02.2016\measurement2\';
%files=dir(fullfile(path,'*.dat'));
%files={files.name};
[filename,pathname]=uigetfile(strcat(path,'*.dat'),'choose file','MultiSelect','off');

format long

raw=importdata(strcat(pathname,filename));
raw=raw.data;
lb=1;ub=length(raw(:,1));
f_v=raw(lb:ub,1)./10^9;
tr=raw(lb:ub,4).^2;
maxind=find(tr==max(tr));
maxval=tr(maxind);
meanval=(mean(tr(lb+1:lb+10))+mean(tr(ub-10:ub-1)))/2;

fBil=find(tr(lb:maxind)<(maxval/2)+meanval,1,'last');
fBir=find(tr(maxind:end)<(maxval/2)+meanval,1,'first');
fBir=maxind+fBir;
fB1=f_v(fBil);
fB2=f_v(fBir);
fB=fB2-fB1;
%[A B]=find(raw(lb:ub,4)>max(raw(lb:ub,4)/2),1,'first');
%[C D]=find(raw(lb:ub,4)>max(raw(lb:ub,4)/2),1,'last');
%fB=(f_v(C)-f_v(A));
f0_fit=f_v(maxind)
Insloss=max(tr)
raw2=raw(lb:ub,:);
D1=(raw2(2,4)+raw2(end-1,4))/2;
v10=193.7818/(2*pi); %193.7818;
v20=Insloss/2*fB*1i;
v30=f0_fit+1i*fB/2;
v40=0;
v50=D1;
ig=[real(v10);imag(v10);real(v20);imag(v20);real(v30);imag(v30);real(v40);imag(v40);real(v50);imag(v50)];
%ig=[30.841331351245046,0,0,0.013082664611127,5.730936043991044,0.022309081819107,0,0,0.246815130,0];
initguess=[ig(1)+1i*ig(2);ig(3)+1i*ig(4);ig(5)+1i*ig(6);ig(7)+1i*ig(8);ig(9)+1i*ig(10)]
initial_guess=[193.7818/(2*pi);max(raw(:,4))/2*fB*1i;f0_fit+1i*fB/2;0;D1];

cplxydata=complex(raw(lb:ub,2),raw(lb:ub,3));

objfcn = @(v,f)exp(-v(1).*2.*pi.*1i.*f).*(v(2)./(f-v(3))+v(4)+v(5)*(f-real(v(3))));

opts = optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','MaxFunEvals',100000,'TolFun',1E-20);
[vfit,resnorm] = lsqcurvefit(objfcn,initguess,f_v,cplxydata,[],[],opts);
objfcn_estimated=objfcn(vfit,f_v);
fB=imag(vfit(3))*2;
f0=real(vfit(3));
Q=f0/fB;
fit_parameters=[f0 fB Q]

igout=[real(vfit(1));imag(vfit(1));real(vfit(2));imag(vfit(2));real(vfit(3));imag(vfit(3));real(vfit(4));imag(vfit(4));real(vfit(5));imag(vfit(5))];
vfit
igout
figure(1)
plot(f_v,raw(lb:ub,2),'o','MarkerSize',2);
hold on;
plot(f_v,raw(lb:ub,3),'o','MarkerSize',2);
plot(f_v,real(objfcn_estimated),'LineWidth',1.5);
plot(f_v,imag(objfcn_estimated),'LineWidth',1.5);
legend('raw re','raw im','fit re','fit im');
hold off
figure(2)
plot(f_v,raw(lb:ub,2).^2+raw(lb:ub,3).^2)

%re=real(objfcn_estimated);
%im=imag(objfcn_estimated);
%root2='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Report Dressel\vgl_fit\';
%fid=fopen(strcat(root2,'0.7NbSTO_mode3_T=0.069K_fitcomplx.dat'),'w');
%fprintf(fid,'%6s %6s %6s \r\n','freq','re','im');
%for i=1:1:length(f_v)    
%    fprintf(fid,'%14.9f %14.9f %14.9f \r\n',f_v(i),re(i),im(i));
%end;
%fclose(fid);

