function [] = appnd_row()
%this function loads a set of analyzed data files containing x rows and y cols (x=number of temperatures/diel. constants/fields
%y=parameters like temp(diel. const. or B);f0;fB;Q;...). Afterwards these%files are appended rowwise. So in the end a list with
%number of files*no. of temps rows and y cols is exported
%files should have a header!

imporder='1,2,3,4,5,6,7,8,9'; %specify the order how the files in "filename" are imported

root='C:\Users\Manfred\Dropbox\Masterarbeit\Messung\CST\backup microstrip\cpw_twosub_stack\new\parsweep eps\analysis\append\';
[filename,filepath]=uigetfile({'*.dat'},'choose files to append',root,'MultiSelect','on');
str='';
for i=1:1:length(filename)
    if i~=length(filename)
        str=strcat(str,filename{i},'-dlmt-');
    else
        str=strcat(str,filename{i});
    end
end
inp=inputdlg(str,'import order',[1 120],{imporder});
split=strsplit(inp{1},',');
imporder=[];
for i=1:1:length(split)
    imporder=cat(1,imporder,str2num(split{i}));
end
imporder

if length(imporder)~=length(filename)
    waitfor(msgbox('different lengths of imporder and filename...default imporder is created by 1:1:length(filename)','modal'));
    imporder=1:1:length(filename);
end

out=[];
sel=[2,4,6,8,10,12,14,16,18,20];
for fileno=1:1:length(filename)
    lst=importdata(strcat(filepath,filename{imporder(fileno)}));
    lststr=lst.colheaders;
    lst=lst.data;    
    out=cat(1,out,lst(sel,:));
end

[filenameexp,filepathexp]=uiputfile({'*.dat'},'export data?',strcat(root,'apnded-lst.dat'));
if filenameexp ~= 0
    fid=fopen(strcat(filepathexp,filenameexp),'w');
    fprintf(fid,'%6s %6s %6s %6s %6s \r\n',lststr{1},lststr{2},lststr{3},lststr{4},lststr{5})
    for i=1:1:length(out(:,1))
        fprintf(fid,'%14.8f %14.8f %14.8f %14.8f %14.8f \r\n',out(i,1),out(i,2),out(i,3),out(i,4),out(i,5));
    end
end
fclose(fid)
    
    
    
    
    
    
    
    
    
    
    
    