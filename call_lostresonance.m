function [iglst,fitreslst,lbublst] = call_lostresonance(lst,iglst,fitreslst,cpg,temp_i,mode_i,ct,lbublst)


if temp_i<ct
    [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(temp_i-1,:,cpg));
    iglst(temp_i,:,cpg)=igout;fitreslst(temp_i,:,cpg)=[temps(temp_i),fit_parameters];
    figure(3);plot(lst(:,1),lst(:,2),'o','MarkerSize',2);hold on;plot(lst(:,1),lst(:,3),'o','MarkerSize',2);plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);plot(plotdata(:,1),plotdata(:,3),'LineWidth',1.5);legend(strcat('raw re i=',num2str(temp_i)),'raw im','fit re','fit im','Location','Southwest');hold off;drawnow   
    lbublst(temp_i,:,cpg)=[lst(2,1),lst(end-1,1)];            
    next_t=1;
else
    %[fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(temp_i-1,:,1));
    %figure(3);plot(lst(:,1),lst(:,2),'o','MarkerSize',2);hold on;plot(lst(:,1),lst(:,3),'o','MarkerSize',2);plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);plot(plotdata(:,1),plotdata(:,3),'LineWidth',1.5);legend(strcat('raw re i=',num2str(temp_i)),'raw im','fit re','fit im','Location','Southwest');hold off;drawnow   
    [lstnew,lbghz]=call_prev_range(lst,lbublst,temp_i,cpg);lst=lstnew;
    figure(3);plot(lst(:,1),lst(:,2),'o','MarkerSize',2);hold on;plot(lst(:,1),lst(:,3),'o','MarkerSize',2);hold off;l=legend({strcat('re_i=',num2str(temp_i)),'im_previous range (t>tc)'},'Location','Southwest');set(l,'Interpreter','none');drawnow;    
    qd=questdlg('whats on?','title','fit and continue','previous range','other','fit and continue');
    cont=1;
    while cont==1
        switch qd
            case 'fit and continue'
                [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(temp_i-1,:,cpg));
                iglst(temp_i,:,cpg)=igout;fitreslst(temp_i,:,cpg)=[temps(temp_i),fit_parameters];
                figure(3);plot(lst(:,1),lst(:,2),'o','MarkerSize',2);hold on;plot(lst(:,1),lst(:,3),'o','MarkerSize',2);plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);plot(plotdata(:,1),plotdata(:,3),'LineWidth',1.5);legend(strcat('raw re i=',num2str(temp_i)),'raw im','fit re','fit im','Location','Southwest');hold off;drawnow   
                pause(2);
                lbublst(temp_i,:,cpg)=[lst(2,1),lst(end-1,1)];    
                next_t=1;cont=0;
            case 'previous range'
                [lstnew,lbghz]=call_prev_range(lst,lbublst,temp_i,cpg);lst=lstnew;                               
                [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(temp_i-1,:,cpg));
                figure(4);plot(lst(:,1),lst(:,2),'o','MarkerSize',2);hold on;plot(lst(:,1),lst(:,3),'o','MarkerSize',2);plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);plot(plotdata(:,1),plotdata(:,3),'LineWidth',1.5);legend(strcat('raw re i=',num2str(temp_i)),'raw im_previous range','fit re','fit im','Location','Southwest');hold off;drawnow   
                lbublst(temp_i,:,cpg)=[lst(2,1),lst(end-1,1)];
                qd=questdlg('whats on?','title','fit and continue','previous range','other','fit and continue');
            case 'other'
                qd2=questdlg('whats on 2?','title','skip','select range cursor','select range man','skip');
                switch qd2
                    case 'skip'
                        lbublst(temp_i,:,cpg)=lbublst(temp_i-1,:,cpg);
                        iglst(temp_i,:,cpg)=iglst(temp_i-1,:,cpg);
                        cont=0;next_t=1;
                    case 'select range cursor'
                        [lb,ub] = call_cutlst(lst,filepath,modelst,clbrsr,1);lst=lst(lb:ub,:);
                        [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(temp_i-1,:,cpg));
                        figure(4);plot(lst(:,1),lst(:,2),'o','MarkerSize',2);hold on;plot(lst(:,1),lst(:,3),'o','MarkerSize',2);plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);plot(plotdata(:,1),plotdata(:,3),'LineWidth',1.5);legend(strcat('raw re i=',num2str(temp_i)),'raw im','fit re','fit im','Location','Southwest');hold off;drawnow   
                        lbublst(temp_i,:,cpg)=[lst(2,1),lst(end-1,1)];
                        qd=questdlg('whats on?','title','fit and continue','previous range','select new range','fit and continue');
                    case 'select range man'
                        srm=1;
                        while srm==1
                            [lb,ub,lst]=call_srm(filepath,modelst,temp_i,clbrsr(mode_i));
                            [fit_parameters,igout,plotdata]=call_fitcmplx(lst,iglst(temp_i-1,:,cpg));
                            figure(4);plot(lst(:,1),lst(:,2),'o','MarkerSize',2);hold on;plot(lst(:,1),lst(:,3),'o','MarkerSize',2);plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);plot(plotdata(:,1),plotdata(:,3),'LineWidth',1.5);legend(strcat('raw re i=',num2str(temp_i)),'raw im','fit re','fit im','Location','Southwest');hold off;drawnow   
                            qd3=questdlg('and now?','title','take fit','again','again');
                            if strcmpi(qd3,'take fit')
                                iglst(temp_i,:,cpg)=igout;lbublst(temp_i,:,cpg)=[lst(2,1),lst(end-1,1)];
                                srm=0;cont=0;next_t=1;
                            else
                                srm=1;
                            end
                        end
                end
        end
    end
end
