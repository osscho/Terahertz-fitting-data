function [] = call_plot_data(fca,lst,plotdata,row,sb,lst0,colabs)

switch fca
    case 0
        if sb==1;
            figure(5);plot(lst(:,1),lst(:,2),'o','MarkerSize',1);
            hold on;
            plot(lst(:,1),lst(:,3),'o','MarkerSize',1);
            plot(lst0(:,1),lst0(:,2),'o','MarkerSize',1);
            plot(lst0(:,1),lst0(:,colabs),'o','MarkerSize',1);
            l=legend('re substr bg','im substr bg',strcat('re_i=',num2str(row)),'im');set(l,'Interpreter','none');
            hold off;
            drawnow;
            figure(6);
            plot(lst(:,1),lst(:,colabs).^2,'o','MarkerSize',1);
            hold on;
            plot(lst0(:,1),lst0(:,colabs).^2,'o','MarkerSize',1);
            l=legend('tr substr bg','tr');set(l,'Interpreter','none');
            hold off;
            drawnow;
        end;
        figure(4);
        plot(lst(:,1),lst(:,2).^2+lst(:,3).^2,'o','MarkerSize',2);
        hold on;
        plot(plotdata(:,1),(plotdata(:,2).^2+plotdata(:,3).^2),'LineWidth',1.5);
        legend(strcat('raw tr i=',num2str(row)),'fit tr','Location','Northeast');
        hold off;drawnow;
        figure(3);
        plot(lst(:,1),lst(:,2),'o','MarkerSize',2);
        hold on;
        plot(lst(:,1),lst(:,3),'o','MarkerSize',2);
        plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);
        plot(plotdata(:,1),plotdata(:,3),'LineWidth',1.5);
        legend(strcat('raw re i=',num2str(row)),'raw im','fit re','fit im','Location','Southwest');
        hold off;
        drawnow;
    case 1
        if sb==1;
            figure(6);
            plot(lst(:,1),lst(:,colabs).^2,'o','MarkerSize',1);
            hold on;
            plot(lst0(:,1),lst0(:,colabs).^2,'o','MarkerSize',1);
            l=legend('tr substr bg',strcat('tr_i=',num2str(row)));
            set(l,'Interpreter','none');
            hold off;
            drawnow;
        end
        figure(3);
        plot(lst(:,1),lst(:,colabs).^2,'o','MarkerSize',2);
        hold on;
        plot(plotdata(:,1),plotdata(:,2),'LineWidth',1.5);
        legend(strcat('tr i=',num2str(row)),'fit tr','Location','Northeast');
        hold off;
        drawnow;
end;
        
   