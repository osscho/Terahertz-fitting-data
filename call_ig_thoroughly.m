function [fit_parameters,igout,plotdata,next_t] =call_ig_thorougly(lst,row,clbrsr,col,fca,sb,lst0,colabs)

cont=1;newspt=0;next_t=0;runs=0;
while cont==1
    if newspt==1
        [spt]=call_signal_propagation(lst0);
    else;
        spt=193.7818;
    end;
    if runs>4
        qd2=questdlg('you seem to have trouble fitting the data...','quest dlg','Yes','I_am_fine','Yes');
        if strcmpi(qd2,'Yes')
            inp=inputdlg({'v1re (spt)','v1im (should be zero)','v2re (0?)','v2im (IL/(2fB))','v3re (f0)','v3im (fB/2)','v4re (0?)',...
                'v4im (0?)','v5re (D1=(lst(end-1,4)-lst(2,4))/2)','v5im (0?)'},'this seems not to work out...',[1 120],...
                {num2str(ig(1)),num2str(ig(2)),num2str(ig(3)),num2str(ig(4)),num2str(ig(5)),num2str(ig(6)),num2str(ig(7)),...
                num2str(ig(8)),num2str(ig(9)),num2str(ig(10))});
            ig(1)=str2num(inp{1});ig(2)=str2num(inp{2});ig(3)=str2num(inp{3});ig(4)=str2num(inp{4});ig(5)=str2num(inp{5});
            ig(6)=str2num(inp{6});ig(7)=str2num(inp{7});ig(8)=str2num(inp{8});ig(9)=str2num(inp{9});ig(10)=str2num(inp{10});
        else
            [ig]=call_initguess(lst,spt); 
        end
    else
        [ig]=call_initguess(lst,spt); 
    end
    [fit_parameters,igout,plotdata]=call_fitcmplx(lst,ig);
    figure(3);
    plot(lst(:,1),lst(:,2),'o','MarkerSize',2);
    hold on;
    plot(lst(:,1),lst(:,3),'o','MarkerSize',2);
    plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);
    plot(plotdata(:,1),plotdata(:,3),'LineWidth',1.5);
    l=legend(strcat('raw re i=',num2str(row)),'raw im','fit re','fit im','Location','Southwest');
    set(l,'Interpreter','none');
    hold off;
    drawnow;
    call_plot_data(fca,lst,plotdata,row,sb,lst0,colabs);
    if col==1;pause(0.01);end;
    quest=questdlg('take ig?','quest dlg','Yes','No','Yes');
    if strcmpi(quest,'Yes');
        cont=0;next_t=1;
        runs=runs;
    else;
        cont=1;
        newspt=1;
        runs=runs+1;
    end;
end;    