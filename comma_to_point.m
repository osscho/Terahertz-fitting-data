function [] = comma_to_point()


root='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\copper-resonator_on_STO_(15.08.2016)\measurement vincent\old\';
filepathexp='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\copper-resonator_on_STO_(15.08.2016)\measurement vincent\measurement\';
[filename,filepath]=uigetfile({'*.dat'},'title',root,'MultiSelect','on');
del1=',';

for i=1:1:length(filename)
    t=strsplit(filename{i},{','});
    t2=strsplit(t{1},'Spectrum_');
    t3=strsplit(t{2},'K_21.07.2016')
    temp1=t2{2};
    temp2=t3{1};
    temp=strcat(temp1,'.',temp2)
    new=strcat(num2str(i),'_','Mode1_',t2{1},temp,'K_',t3{2})
    lst=importdata(strcat(filepath,filename{i}));lst=lst.data;
    fid=fopen(strcat(filepathexp,new),'w');
    fprintf(fid,'%6s %6s %6s %6s \r\n','freq','re','im','abs');
    for row=1:1:length(lst(:,1))
        fprintf(fid,'%14.8f %14.8f %14.8f %14.8f \r\n',lst(row,1),lst(row,2),lst(row,3),lst(row,4));
    end;
    fclose(fid);
end
