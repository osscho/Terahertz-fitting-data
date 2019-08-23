function [clbrsrcol,clbrsrstr,filepathexplst,filepathexp2,cols,filepathexp,col]...
    = call_set_parameters_set_up_exp(clbrsr,cols,filepathexp,labelmodes,qdexp,asm,sm,cm,sret,torb,modelst)

%clbrsr=2;noofm=10;filepathexp='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(0.5clean)_19.05_2016_measuredbymarkus\analysis2\complex_sb0_sr\';
%labelmodes=[12,2,3,4,45];asm=0;sm=1;cm=3;qdexp='Yes';
%set parameter for loop
switch clbrsr
    case 0
        switch asm
            case 0
                if cols==1;
                    col=1;
                    sm=1;
                    clbrsrcol=1;
                else
                    col=1;                    
                    clbrsrcol=1:1:cols; 
                end
            case 1
                col=sm;                
                clbrsrcol=1:1:cols;
            case 2
                col=sm;                
                clbrsrcol=1:1:cols;
        end
    case 1        
        cols=1;
        clbrsrcol=clbrsr;
        col=1;
    case 2
        cols=2;
        clbrsrcol=clbrsr;
        col=1;
    case 3
        cols=cols;   
        clbrsrcol=1:1:cols;
        clbrsrstr='';
        filepathexplst={};
        col=1;
end;
   

%make paths and folder for export of data
switch clbrsr
    case 0
        clbrsrstr='cl';
        filepathexplst={};
        for i=sm:1:length(labelmodes);
            if strcmpi(qdexp,'Yes')
                filepathexp2=filepathexp;
                if torb==2
                    labelmodelength='length';
                else
                    labelmodelength='mode';
                end
                filepathexp2=strcat(filepathexp,labelmodelength,num2str(labelmodes(i)),'_',clbrsrstr);
                switch asm
                    case 0
                        mkdir(filepathexp2);
                    case 1
                        if i==sm
                            mkdir(filepathexp2);
                        end
                    case 2
                        mkdir(filepathexp2);
                end
                filepathexplst{i}=strcat(filepathexp2,'\');
            end
        end
    case 1
        filepathexplst={};
        filepathexp2=filepathexp;
        clbrsrstr='br';
        if strcmpi(qdexp,'Yes')
            filepathexp=strcat(filepathexp,'mode',num2str(cm),'_',clbrsrstr);
            mkdir(filepathexp);
            filepathexp=strcat(filepathexp,'\');
        end
    case 2
        filepathexplst={};
        filepathexp2=filepathexp;
        clbrsrstr='sr';
        if strcmpi(qdexp,'Yes')
            filepathexp=strcat(filepathexp,'mode',num2str(cm),'_',clbrsrstr);
            mkdir(filepathexp);
            filepathexp=strcat(filepathexp,'\');
        end
    case 3;
        filepathexp=filepathexp;
        filepathexp2=strcat(filepathexp,'fitted spectrum\');
        mkdir(filepathexp2);
        labelmodelength='';
end

if strcmpi(qdexp,'No')
    filepathexp2='C:';
end
    








