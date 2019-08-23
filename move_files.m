function [] = move_files()

%move files from folder 'Modexy' which contains files ...br... and ...sr...to two new folders called br and sr

root='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(0.5clean)_24.06.2016_try3\measurement\run2_dynrange\measurement\Mode2\'
filepath=uigetdir(root,'choose folder of measurement files');
filepath=strcat(filepath,'\')
%[filenames,filepath]=uigetfile({'*.dat'},'choose files',root,'MultiSelect','on');
filenames=dir(fullfile(filepath,'*.dat'));
filenames={filenames.name}

modelst={};
spltat=2;
countbr=1;
countsr=1;
for i=1:1:length(filenames)
    splt=strsplit(filenames{i},{'_'})
    
    if strcmpi(splt{spltat},'br')
        modelst{countbr,1}=filenames{i};
        countbr=countbr+1;
    end
    if strcmpi(splt{spltat},'sr')
        modelst{countsr,2}=filenames{i};
        countsr=countsr+1;
    end
end;
modelst
pathbr=strcat(filepath,'br\');
pathsr=strcat(filepath,'sr\');

mkdir(pathbr);
mkdir(pathsr);
for i=1:1:length(modelst(:,1))
    movefile(strcat(filepath,modelst{i,1}),strcat(pathbr,modelst{i,1}));
    movefile(strcat(filepath,modelst{i,2}),strcat(pathsr,modelst{i,2}));
end;
