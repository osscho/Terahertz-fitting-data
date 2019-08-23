function [] = sort_for_modes()

root='C:\Users\Manfred Beutel\Desktop\test\B sweep with true 0T 2\measurement\';
rootsve='C:\Users\Manfred Beutel\Desktop\test\B sweep with true 0T 2\sorted\';
del1='_Mode';
del2='(';
del3='GHz)_min';

modenos=[1,3,5,6,9];

[filename,pathname]=uigetfile({'*.dat'},'choose files',root,'MultiSelect','on');

%find position to split string and where freq is located
test=strsplit(filename{1},{del1,del2});
test2=strsplit(filename{1},{del2,del3});
name='';
name2='';
for i=1:1:length(test)
    name=strcat(name,test{i},'-dlmt-');
end
for i=1:1:length(test2)
    name2=strcat(name2,test2{i},'-dlmt-');
end
tosplt=inputdlg({strcat('get modeindex: ',name),strcat('get freqval ',name2)},'enter spltat',[1 150],{'3','3'});
spltat=str2num(tosplt{1});
spltat2=str2num(tosplt{2});

%sort files in 2D array with rows=no. of T and B and cols=no. of modes
noofTandB=length(filename)/length(modenos);
indexcount=ones(1,length(modenos));
modelst=cell(noofTandB,length(modenos));
for i=1:1:length(filename)
    splt=strsplit(filename{i},{del1,del2});
    splt=str2num(splt{spltat});
    index=find(modenos==splt);
    modelst(indexcount(1,index),index)=filename(i);
    indexcount(1,index)=indexcount(1,index)+1;
end

for col=1:1:length(modenos)
    splt=strsplit(modelst{1,col},{del2,del3});
    target=strcat(rootsve,'Mode',num2str(modenos(col)),'(',splt{spltat2},'GHz)');
    mkdir(target);
    for row=1:1:length(modelst(:,col))
        copyfile(strcat(root,modelst{row,col}),target);
    end
end
    
    

