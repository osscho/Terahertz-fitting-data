function [] = create_tempfile()

%creates temperature file for measurements performed using VTI

root='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\copper-resonator_on_STO_(15.08.2016)\measurement vincent\measurement\'
[filename,filepath]=uigetfile({'*.dat'},'title',root,'MultiSelect','on');
del11='STOmeandercool_';del12='K';
del21='STOmeandercool_';del22='K';

spltact=strsplit(filename{1},{del11,del12});%split actual temperature
spltset=strsplit(filename{1},{del21,del22});%split set temperature
stract='';
strset='';
for i=1:1:length(spltact)
    if i<length(spltact)
        stract=strcat(stract,spltact{i},'-dlmt-');
    else
        stract=strcat(stract,spltact{i});
    end    
end
for i=1:1:length(spltset)
    if i<length(spltset)
        strset=strcat(strset,spltset{i},'-dlmt-');
    else
        strset=strcat(strset,spltset{i});
    end    
end
spltat=inputdlg({stract,strset,'number of modes'},'enter split position',[1,50],{'2','4','2'});
spltatact=str2num(spltat{1});
spltatset=str2num(spltat{2});
noofm=str2num(spltat{3});

templst=ones(length(filename),2);
for i=1:1:length(filename)
     spltact=strsplit(filename{i},{del11,del12});
     spltset=strsplit(filename{i},{del21,del22});
     templst(i,1)=str2num(spltact{spltatact});
     templst(i,2)=str2num(spltset{spltatset});
end
templst
sel=1:noofm:length(filename);
templst=templst(sel,:)
qd=questdlg('export data?','title','Yes','No','Yes');
if strcmpi(qd,'Yes')
    [filename,filepath]=uiputfile({'*.dat'},'title',strcat(filepath,'temps.dat'));
    fid=fopen(strcat(filepath,filename),'w');
    fprintf(fid,'%6s %6s \r\n','set_T','act_T');
    for i=1:1:length(templst(:,1))
        fprintf(fid,'%14.8f %14.8f \r\n',templst(i,2),templst(i,1))
    end
    fclose(fid)
end
