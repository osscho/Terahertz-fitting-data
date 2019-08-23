function [] =...
    call_export_cmplx(fitreslst,iglst,modelst,filepathexp,sb,cpg,clbrsr,fca,torb,ls,sampletemp,temps,modes)


%root='C:\Users\Manfred\Dropbox\Masterarbeit\Messung\NbSTO(0.7)_4.2.2016\measurement2\';
%filepath=uigetdir(root,'save results');
%filepath=strcat(filepath,'\')

switch torb
    case 0
        torb_str='temperature';
        torb_str_short='temp';
    case 1
        torb_str='mgtfield';
        torb_str_short='field';
    case 2
        torb_str='dielconst';
        torb_str_short='eps';
end
switch clbrsr
    case 0
        switch torb
            case 1
                freqlabel=strcat(num2str(fitreslst(2,2,cpg)),'GHz)');
                filename=strcat('mode',num2str(modes(cpg)),'(',freqlabel,'_actTsample=',num2str(sampletemp),'K_sb',num2str(sb),'_fca',num2str(fca),'.dat');
                igfilename=strcat('ig_','mode',modes(cpg),'(',freqlabel,'_sb',num2str(sb),'_fca',num2str(fca),'.dat');
            case 2
                modelabel=strcat('length=',num2str(ls),'mm_no');
                filename=strcat(modelabel,num2str(modes(cpg)),'_sb',num2str(sb),'_fca',num2str(fca),'.dat');
                igfilename=strcat('ig_',modelabel,num2str(modes(cpg)),'_sb',num2str(sb),'_fca',num2str(fca),'.dat');
            otherwise
                freqlabel=strcat(num2str(fitreslst(2,2,cpg)),'GHz)');
                filename=strcat('mode',num2str(modes(cpg)),'(',freqlabel,'_sb',num2str(sb),'_fca',num2str(fca),'.dat');
                igfilename=strcat('ig_mode',num2str(modes(cpg)),'(',freqlabel,'_sb',num2str(sb),'_fca',num2str(fca),'.dat');
        end
    case 3
        torb_str='mgtfield';
        torb_str_short='field(T)';
        tmean=mean(temps(:,cpg));
        filename=strcat('T',num2str(cpg),'_actTmeansample=',num2str(tmean,'%2.4f'),'K_mode',num2str(modes),...
            '(',num2str(fitreslst(1,2,cpg),'%1.2f'),'GHz).dat');
        igfilename=strcat('ig_T',num2str(cpg),'_actTmeansample=',num2str(tmean,'%2.4f'),'K_mode',num2str(modes),...
            '(',num2str(fitreslst(1,2,cpg),'%1.2f'),'GHz).dat');                       
end;

fid=fopen(strcat(filepathexp{1},filename),'w');
switch clbrsr
    case 0
        igfid=fopen(strcat(filepathexp{1+cpg},igfilename),'w');
    case 3
        igfid=fopen(strcat(filepathexp{2},igfilename),'w');
end

if clbrsr==3
    fprintf(fid,'%6s %6s %6s %6s %6s %6s %6s\r\n','field(T)','temp(K)','f0','fB','Q','f0prime(-(f-f0))','fBprime');
    switch fca
        case 0
            fprintf(igfid,'%6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s\r\n','field(T)','temp(K)','v1re','v1im','v2re','v2im',...
                'v3re','v3im','v4re','v4im','v5re','v5im');
        case 1
            fprintf(igfid,'%6s %6s %6s %6s %6s %6s \r\n','field(T)','temp(K)','L0','fB','f0','y0');
    end
else
    switch torb
        case 2
            fprintf(fid,'%6s %6s %6s %6s %6s %6s %6s\r\n',torb_str,'length','f0','fB','Q','f0prime(-(f-f0))','fBprime');
        otherwise
            fprintf(fid,'%6s %6s %6s %6s %6s %6s\r\n',torb_str,'f0','fB','Q','f0prime(-(f-f0))','fBprime');
    end
    switch fca
        case 0
            fprintf(igfid,'%6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s \r\n',torb_str_short,'v1re','v1im','v2re','v2im',...
                'v3re','v3im','v4re','v4im','v5re','v5im');
        case 1
            fprintf(igfid,'%6s %6s %6s %6s %6s \r\n',torb_str_short,'L0','fB','f0','y0');
    end
end

for row=1:1:length(fitreslst(:,1,cpg))
    if clbrsr==3
        fprintf(fid,'%6.4f %6.4f %14.9f %14.9f %14.9f %14.9f %14.9f \r\n', fitreslst(row,1,cpg),temps(row,cpg),...
            fitreslst(row,2,cpg),fitreslst(row,3,cpg),fitreslst(row,4,cpg),...
                -(fitreslst(row,2,cpg)-fitreslst(1,2,cpg)),fitreslst(row,3,cpg)-fitreslst(1,3,cpg));
        switch fca
            case 0
                fprintf(igfid,'%8.4f %8.4f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f \r\n',...
                    fitreslst(row,1,cpg),temps(row,cpg),iglst(row,1,cpg),iglst(row,2,cpg),iglst(row,3,cpg),iglst(row,4,cpg),...
                    iglst(row,5,cpg),iglst(row,6,cpg),iglst(row,7,cpg),iglst(row,8,cpg),iglst(row,9,cpg),...
                    iglst(row,10,cpg));
            case 1
                fprintf(igfid,'%8.4f %8.4f %14.9f %14.9f %14.9f %14.9f \r\n', fitreslst(row,1,cpg),temps(row,cpg),iglst(row,1,cpg),...
                    iglst(row,2,cpg),iglst(row,3,cpg),iglst(row,4,cpg));
        end
    else
        switch torb
            case 2
                fprintf(fid,'%6.4f %6.4f %14.9f %14.9f %14.9f %14.9f %14.9f \r\n', fitreslst(row,1,cpg),ls,...
                    fitreslst(row,2,cpg),fitreslst(row,3,cpg),fitreslst(row,4,cpg),...
                    -(fitreslst(row,2,cpg)-fitreslst(1,2,cpg)),fitreslst(row,3,cpg)-fitreslst(1,3,cpg));
            otherwise
                fprintf(fid,'%6.4f %14.9f %14.9f %14.9f %14.9f %14.9f \r\n', fitreslst(row,1,cpg),fitreslst(row,2,cpg),...
                    fitreslst(row,3,cpg),fitreslst(row,4,cpg),-(fitreslst(row,2,cpg)-fitreslst(1,2,cpg)),...
                    fitreslst(row,3,cpg)-fitreslst(1,3,cpg));
        end
        switch fca
            case 0
                fprintf(igfid,'%8.4f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f %14.9f \r\n',...
                    fitreslst(row,1,cpg),iglst(row,1,cpg),iglst(row,2,cpg),iglst(row,3,cpg),iglst(row,4,cpg),...
                    iglst(row,5,cpg),iglst(row,6,cpg),iglst(row,7,cpg),iglst(row,8,cpg),iglst(row,9,cpg),...
                    iglst(row,10,cpg));
            case 1
                fprintf(igfid,'%8.4f %14.9f %14.9f %14.9f %14.9f \r\n', fitreslst(row,1,cpg),iglst(row,1,cpg),...
                    iglst(row,2,cpg),iglst(row,3,cpg),iglst(row,4,cpg));
        end
    end;
end;
fclose(fid);
fclose(igfid);
