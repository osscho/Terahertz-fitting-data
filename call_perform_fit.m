function [iglst,fitreslst,lbublst,next_row,plotdata] =...
    call_perform_fit(row,clbrsr,lst,lst0,cpg,fca,sb,sret,...
                crit_temp,awig,temps,fitreslst,iglst,lbublst,colabs,fields,skip)

if (not(isempty(lst)) && skip==0)
    switch fca
        case 0
            if awig == 0
                [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(row-1,:,cpg));
                call_plot_data(fca,lst,plotdata,row,sb,lst0,colabs);
                next_row=1;
            else
                if row<crit_temp
                    [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(row-1,:,cpg));
                    call_plot_data(fca,lst,plotdata,row,sb,lst0,colabs);
                    next_row=1;
                else
                    try
                        [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(row-1,:,cpg));
                        call_plot_data(fca,lst,plotdata,row,sb,lst0,colabs);
                        qd=questdlg('continue with next temp?','title','Yes','new ig','Yes');
                        if strcmpi(qd,'Yes')
                            next_row=1;
                        else
                            [fit_parameters,igout,plotdata,next_row]=call_ig_thoroughly(lst,row,clbrsr,100,fca,sb,lst0,colabs); %if col==1 it waits 1 second before showing plots
                        end
                    catch
                        fit_parameters=fitreslst(row-1,:,cpg);
                        fit_parameters=fit_parameters(2:end);
                        igout=iglst(row-1,:,cpg);
                        plotdata=[];
                        plotdata(:,1)=lst(:,1);
                        plotdata(:,2)=lst(:,2);
                        plotdata(:,3)=lst(:,3);
                        plotdata(:,colabs)=lst(:,colabs);
                        waitfor(msgbox('an error occured, continue with next temp (results will be taken from previous temp'));
                        next_row=1;
                    end
                end
            end

        case 1
            switch awig
                case 0
                    [fit_parameters,igout,plotdata]=call_fit_abs(lst,iglst(row-1,:,cpg),sret,awig,colabs);
                    call_plot_data(fca,lst,plotdata,row,sb,lst0,colabs);
                    next_row=1;
                case 1
                    [fit_parameters,igout,plotdata,next_row,ff]=call_ig_fitabs(lst,fca,row,sb,lst0,sret,ff,colabs);
            end
    end
    iglst(row,:,cpg)=igout;
    if clbrsr~=3
        fitreslst(row,:,cpg)=[temps(row),fit_parameters];
    else
        fitreslst(row,:,cpg)=[fields(row),fit_parameters];
    end
    %lbublst(row,:,cpg)=[lst(2,1),lst(end-1,1)];
else
    figure(6);
    plot(lst(:,1),lst(:,2),lst(:,1),lst(:,3));
    l=legend(strcat('re_i=',num2str(row)),'im');
    set(l,'Interpreter','none');
    iglst(row,:,cpg)=iglst(row-1,:,cpg);
    if clbrsr~=3
        fitreslst(row,:,cpg)=[temps(row),1,1,1];
    else
        fitreslst(row,:,cpg)=[fields(row),1,1,1];
    end
    lbublst(row,:,cpg)=lbublst(row-1,:,cpg);
    plotdata=lst;
    waitfor(msgbox('empty list...take previous fit results to ensure further execution'));
    next_row=1;
end;




