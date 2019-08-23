function [ig] = call_initguess(lst,spt)

f_v=lst(:,1);
tr=lst(:,4).^2;

maxind=find(tr==max(tr));
maxval=tr(maxind);
meanval=(mean(tr(1:10))+mean(tr(end-10:end)))/2;

fBil=find(tr(1:maxind)<(maxval/2)+meanval,1,'last');
fBir=find(tr(maxind:end)<(maxval/2)+meanval,1,'first');
fBir=maxind+fBir;
fB1=f_v(fBil);
fB2=f_v(fBir);
fB=fB2-fB1;
[E f0_ind]=max(tr);
f0_fit=f_v(f0_ind);
Insloss=max(tr);
D1=(lst(2,4)+lst(end-1,4))/2;
v10=spt/(2*pi); %143.204;
v20=Insloss/2*fB*1i;
v30=f0_fit+1i*fB/2;
v40=0;
v50=D1;
ig=[real(v10);imag(v10);real(v20);imag(v20);real(v30);imag(v30);real(v40);imag(v40);real(v50);imag(v50)];