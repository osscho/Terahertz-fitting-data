function [clbrsr,modes,fca,sb,sbem,cmct,cst,mlbub,checkspltat,sret,crit_temp,ro,awig,...
        torb,stwt1,colabs,ls]=call_answer(root,filename_st_val)

%sb_st=num2str(1);noofm_st=num2str(9);fca_st=num2str(0);sbem_st=num2str(1);
%root='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(0.5clean)_19.05_2016_measuredbymarkus\';
filename_st_val='start_values.dat';
filepath=root;
filename=filename_st_val;

%legend
%---------------------------------------------------------------------------
%clbrsr: 0=tempsweep for diff modes; 3=fieldsweep at different temps
%modes: containts the mode numbers (e.g. mode1,mode3 -> modes=[1,3])
%fca: 0=fit complex; 1=fit absolute (so transmission)
%sb: substract background (0=no,1=yes)
%sbem: substract background for each mode (when background was recorded for each mode, but should be same frequency range and same no. of points)
%cmct: column of mc temperature in temp. file
%cst: column of sample temperature in temp file
%mlbub: maintain the lower bound and upper bound from the first selection
%checkspltat: check if the string is split in a way that it can be sorted according to the mode or temp index (0=no,1=yes)
%sret:select range for each file
%ro: reverse order of files
%awig: always inital guess
%torb=temp, magnetic field or simulation(here:constant length and parsweep in eps)
%stwt1=select range two times at temp_i=1
%ls=length structure (for torb=2)
%colabs=column with S21 data
%psfB=plot single fB

%crit_temp: index1:relevant for awig (when this temp is reached awig becomes active)
%filepathmf: filepath for measurement files
%filepathexp: filepath for export
%filepathbg: filepath for background files
%ls: length 

%rows/cols: the files are sorted in 2D matrix. For clbrsr=0 the rows correspond to temperature and the columns to different modes.
%For clbrsr the rows correspond to different fields and the columns correspond to different temperatures, here only one mode is analyzed.
try 
    imp=importdata(strcat(filepath,filename));
    imptextdata=imp.textdata;
    imp=imp.data;
catch
    qd=questdlg('choose file or use standard values?','title','choose file','standard values','choose file');
    if strcmpi(qd,'choose file')
        [filename_error,filepath_error]=uigetfile({'*.dat'},'file does not exist','.\','MultiSelect','off');
        imp=importdata(strcat(filepath_error,filename_error));              
        imptextdata=imp.textdata;        
        imp=imp.data;
    else
        imp=[0,0,0,0,0,1,7,1,0,0,0,0,1000000,0,0];
        imptextdata={'clbrsr','1_2_3_4_5','fca','sb','sbem','cmct','cst','mlbub','checkspltat',...
            'sret','ro','awig','crit_temp','torb','stwt1'};
        %imptextdata={'clbrsr',here are the modes,'fca','sb','sbem','cmct','cst','mlbub','checkspltat','sret','ro',...
         %   'awig','crit_temp','torb','stwt1'};        
    end;
end

clbrsr_st=num2str(imp(1));
modes_st=imptextdata{2};
fca_st=num2str(imp(3));
sb_st=num2str(imp(4));
sbem_st=num2str(imp(5));
cmct_st=num2str(imp(6));
cst_st=num2str(imp(7));
mlbub_st=num2str(imp(8));
checkspltat_st=num2str(imp(9));
sret_st=num2str(imp(10));
ro_st=num2str(imp(11));
awig_st=num2str(imp(12));
crit_temp_st=num2str(imp(13));
torb_st=num2str(imp(14));
stwt1_st=num2str(imp(15));

answer=inputdlg({
    '0: temp & mode; 3: field&temp (many options are not possible; ask author)',...
    'enter modes formatted as 1_2_3_5_6_8 (enter: "014" -> 14 modes in consecutive order) (for temp&field only one mode possible)',...
    '0=fit complex; 1= fit abs',...
    'substract background? (0: no, 1: yes) <-only for temp&mode',...
    'background file for each mode? (0=no,1=yes) <-only for temp&mode',...
    'col mc temp <-only for temp&mode',...
    'col sample temp <-only for temp&mode',...
    'maintain lb ub from first cut? (0=no;1=yes)',...
    'checkspltat (0: no, 1: yes;)',...
    'select range for each file?:0=no,1=yes (from whole range);',...
    'reverse order of files? (0=no,1=yes)',...
    'always ig?; 0=no,1=yes (ig taken from previous fit but dlgbox will appear)',...
    'torb (temperature=0 or magnetic field=1 or 2=for simulation: constant length and parsweep in eps; eps is read from col sample temp and colabs is set to 2) <-only for temp&mode',...
    'stwt1 (select range two times at temp_i=1)->0=no;1=yes'},...
    'prompt for user input',[1 160],...
    {clbrsr_st,...
    modes_st,...
    fca_st,...
    sb_st,...
    sbem_st,...
    cmct_st,...
    cst_st,...
    mlbub_st,...
    checkspltat_st,...
    sret_st,...
    ro_st,...
    awig_st,...
    torb_st,...
    stwt1_st});

clbrsr=str2num(answer{1});
var1=answer{2};
modes_to_write='';
if str2num(var1(1))==0
    modes=1:1:str2num(var1);
else
    splt=strsplit(var1,'_');
    modes=ones(length(splt),1);
    for i=1:1:length(splt)
        modes(i)=str2num(splt{i});
    end
end
fca=str2num(answer{3});
sb=str2num(answer{4});
sbem=str2num(answer{5});
if sb==0
    sbem=0;
end
cmct=str2num(answer{6});
cst=str2num(answer{7});
mlbub=str2num(answer{8});
checkspltat=str2num(answer{9});
sret=str2num(answer{10});
switch sret
    case 0
        crit_temp=1000;
    case 1
        mlbub=0;
        crit_temp=1000;
end
ro=str2num(answer{11});
awig=str2num(answer{12});
switch awig
    case 0
        crit_temp=1000000;
    case 1
        crit_temp=inputdlg({'enter temp. to start ig_thoroughly if required'},'title',[1 50],{crit_temp_st});
        crit_temp=str2num(crit_temp{1});
end;
torb=str2num(answer{13});
ls=5;
if torb==2
    colabs=2;
    fca=1;
    inp=inputdlg({'enter length of structure in mm'},'title',[1 20],{'5'});
    ls=str2num(inp{1});
else
    colabs=4;
end
stwt1=str2num(answer{14});

vec_leg={'clbrsr',answer{2},'fca','sb','sbem','cmct','cst','mlbub','checkspltat','sret','ro',...
    'awig','crit_temp','torb','stwt1'};
vec=[clbrsr,0,fca,sb,sbem,cmct,cst,mlbub,checkspltat,sret,ro,awig,crit_temp,torb,stwt1];

try
    fid=fopen(strcat(filepath,filename),'w');
    for i=1:1:length(vec)
        fprintf(fid,'%6s %2d \r\n',vec_leg{i},vec(i));
    end;
    fclose(fid);
catch
    inp=inputdlg('problem with filepath...enter new one (I can not export "start_values.dat")','title',[1 120]);
    filepath=inp{1};
    fid=fopen(strcat(filepath,filename),'w');
    for i=1:1:length(vec)
        fprintf(fid,'%6s %2d \r\n',vec_leg{i},vec(i));
    end;
    fclose(fid);
end

