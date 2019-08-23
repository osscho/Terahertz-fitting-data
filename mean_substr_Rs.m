function [] = mean_substr_Rs()

root='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(0.35)_09.02.2016\analysis2\fit complex\'
[filename,pathname]=uigetfile({'*.dat'},'title',root,'MultiSelect','on');

if iscell(filename)
    for i=1:1:length(filename)
        lst=importdata(strcat(pathname,filename{i}));
        lst=lst.data;
        Rsmean=lst(:,3)-mean(lst(1:3,3));
        lst=cat(2,lst,Rsmean);
        fid=fopen(strcat(pathname,filename{i},'_Rsmean.dat'),'w');
        fprintf(fid,'%6s %6s %6s %6s %6s %6s %6s \r\n','temperature','f0','fB','Q','fprime(-(f-f0))','fBprime','fBprimemean');
        fprintf(fid,'%8.4f %14.8f %14.8f %14.8f %14.8f %14.8f %14.8f \r\n',transpose(lst));
        fclose(fid);
    end
else
        lst=importdata(strcat(pathname,filename));
        lst=lst.data;
        Rsmean=lst(:,3)-mean(lst(1:3,3));
        lst=cat(2,lst,Rsmean);
        fid=fopen(strcat(pathname,filename,'_Rsmean.dat'),'w');
        fprintf(fid,'%6s %6s %6s %6s %6s %6s %6s \r\n','temperature','f0','fB','Q','fprime(-(f-f0))','fBprime','fBprimemean');
        fprintf(fid,'%8.4f %14.8f %14.8f %14.8f %14.8f %14.8f %14.8f \r\n',transpose(lst));
        fclose(fid);
end