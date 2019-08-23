function [] = call_plotfB(clbrsr,cols,modes,fitreslst,psfB,temps,cpg)

switch psfB
    case 0
        switch clbrsr
            case 0
                leglst={};
                for i=1:1:cols
                    leglst=cat(1,leglst,strcat('fB_mode: ',num2str(modes(i))));
                end
                figure(4);
                plot(fitreslst(:,1,1),fitreslst(:,3,1),'o');
                hold on;
                for i=2:1:cols
                    plot(fitreslst(:,1,i),fitreslst(:,3,i),'o');
                end;
                l=legend(leglst,'Location','northwest');
                set(l,'Interpreter','none');
                hold off;
            case 3
                leglst={};
                for i=1:1:cols
                    tmean=mean(temps(:,i));
                    leglst=cat(1,leglst,strcat('fB_tempno ',num2str(cpg),'_Tmean=',num2str(tmean),' K'));
                end
                figure(4);
                plot(fitreslst(:,1,1),fitreslst(:,3,1),'o');
                hold on;
                for i=2:1:cols
                    plot(fitreslst(:,1,i),fitreslst(:,3,i),'o');
                end;
                l=legend(leglst,'Location','northwest');
                set(l,'Interpreter','none');
                hold off;
        end

    case 1
        switch clbrsr
            case 0
                figure(4);
                plot(fitreslst(:,1,cpg),fitreslst(:,3,cpg),'o','MarkerSize',2);
                l=legend(strcat('fB_mode: ',num2str(modes(cpg))),'Location','northwest');
                set(l,'Interpreter','none');
            case 3
                figure(4);
                plot(fitreslst(:,1,cpg),fitreslst(:,3,cpg),'o','MarkerSize',2);
                tmean=mean(temps(:,cpg));
                l=legend(strcat('fB_tempno ',num2str(cpg),'_Tmean=',num2str(tmean),' K'),'Location','northwest');
                set(l,'Interpreter','none');
        end 
end










