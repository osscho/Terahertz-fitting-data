function [bg] = call_import_bg(sbem,filenamebg,filepathbg,col)


switch sbem
    case 0
        bg=importdata(strcat(filepathbg,filenamebg));
        if isstruct(bg)
            bg=bg.data;
        else
            bg=bg;
        end
        bg(:,1)=bg(:,1)/10^9;
        
    case 1
        if iscell(filenamebg)
            bg=importdata(strcat(filepathbg,filenamebg{col}));
        else
            bg=importdata(strcat(filepathbg,filenamebg));
        end
        if isstruct(bg)
            bg=bg.data;
        else
            bg=bg;
        end
        bg(:,1)=bg(:,1)/10^9;
end
        
            
            
            
            
            
            
            
            
            
            
            
            