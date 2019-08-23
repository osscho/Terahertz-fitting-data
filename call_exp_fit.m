function [] = call_exp_fit(qdexp,lst,plotdata,temps,row,tempsmc,sb,fca,torb,colabs,sampletemp,modelst,...
                col,clbrsr,modes,ls,filepathexp)

if qdexp=='Yes'
    if clbrsr==3
        filename=strcat(filepathexp{1,2},'fit_',modelst{row,col});
    else
        rootsve=filepathexp{1+col}
        switch torb
        case 1
           filename=strcat(rootsve,num2str(row),'mode',num2str(modes(col)),'_B=',num2str(temps(row)),'T_actTsample=',num2str(sampletemp),'K_sb',num2str(sb),'.dat'); 
        case 2
            filename=strcat(rootsve,num2str(row),'_length',num2str(ls),'mm_eps',num2str(temps(row)),'_sb',num2str(sb),'.dat');
        otherwise
            filename=strcat(rootsve,num2str(row),'mode',num2str(modes(col)),'_Tsmp',num2str(temps(row)),'K_Tmc',...
                num2str(tempsmc(row)),'K_sb',num2str(sb),'.dat');
        end
    end
    fid=fopen(filename,'w');
    switch fca
        case 0
            fprintf(fid,'%6s %6s %6s %6s %6s %6s %6s \r\n','freq','re','im','abs','re_fit','im_fit','abs_fit');
        case 1
            fprintf(fid,'%6s %6s %6s \r\n','freq','tr','tr_fit');
    end

    for i=1:1:length(lst(:,1))
        switch  fca
            case 0
                %take care. it is not transmission but abs(S21) which is  exported;
                fprintf(fid,'%14.8f %14.8f %14.8f %14.8f %14.8f %14.8f %14.8f \r\n',lst(i,1),lst(i,2),lst(i,3),lst(i,colabs),...
                    plotdata(i,2),plotdata(i,3),sqrt(plotdata(i,2)^2+plotdata(i,3)^2));
            case 1
                fprintf(fid,'%14.8f %14.8f %14.8f \r\n',lst(i,1),lst(i,colabs)^2,plotdata(i,2)); %export transmission
        end
    end
    fclose(fid);
end