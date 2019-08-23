function [] = copy_to_all()
%if themeasurement files are separated in different folders, i.e. folder "Mode1" containts 1_Mode1_br.dat;1_Mode1_sr.dat;
%2_Mode1_br.dat;..." then this programm puts all files located in the different folders ("Mode1","Mode2",...) in one folder
%for "br-files" and one folder fot "sr-files"

root='C:\Users\Manfred\Dropbox\Masterarbeit\Messung\NbSTO(0.2)_14.04.2016\measurement 2\measurement\';
rootbr='C:\Users\Manfred\Dropbox\Masterarbeit\Messung\NbSTO(0.2)_14.04.2016\measurement 2\measurement\all\br\';
rootsr='C:\Users\Manfred\Dropbox\Masterarbeit\Messung\NbSTO(0.2)_14.04.2016\measurement 2\measurement\all\sr\';
noofm=16;


for mode_i=1:1:noofm
    path_to=strcat(root,'Mode',num2str(mode_i),'\');
    files=dir(fullfile(path_to,'*.dat'));
    files={files.name};
    for file_i=1:1:length(files)
        split=strsplit(files{file_i},{'Mode','_'});
        strcat(path_to,files{file_i});
        split;
        if strcmpi(split{3},'br')
            copyfile(strcat(path_to,files{file_i}),rootbr);
        end
        if strcmpi(split{3},'sr')
            copyfile(strcat(path_to,files{file_i}),rootsr);
        end
    end
end
