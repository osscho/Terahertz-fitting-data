function [fitreslst] = main_fct_cmplx_2()
%description: see call answer

tempindav=1;%set tempindav to zero if no temperature index is in filename
%in this casethe temperature should be sorted in ascending order. Otherwise I will go on strike!

%for clbrsr=0 (tempsweep for diff modes):
%start
%standard delimiter when splitting strings for sorting before import
%get modeindex
del11='_Mode';del12='(';
%get tempindex
%del13 and noofT0 are not used when tempindav=0)
del13='_T';del14='_setTmc';
noofT0=65;%enter here the number of temperatures
spltatf0ind=3;%position of the modeindex in the splitted string
spltatTind=2;%used only if tindav=1
%end
%temp&field-mode (clbrsr=3):
%start
indexTst=1;noofT3=21;%do not include reference temp here
indexBst=1;noofB=72;
%get fieldindex:
del31='_B';del32='(setB=';
%get fieldval
del33='setB=';del34='T)';
%get tempindex (not used when tempindav=0)
del35='_T';del36='_setTmc=';
%get tempval (not used when tempindav=0)
del37='K_actTsample=';del38='K_B';
%get modeindex.
del39='_Mode';del310='(';
stdspltat=[2,2,2,2,3];%standartspltat=[Bind,Bval,Tind,Tval,modeno]
%end
newargnumb=cat(2,[indexTst,noofT3,indexBst,noofB,noofT0,tempindav,spltatf0ind,spltatTind],stdspltat);
newargdel={del31,del32,del33,del34,del35,del36,del37,del38,del39,del310,del11,del12,del13,del14};

format long
root='D:\Data\Shang\CECU6\2017_05_17 H04_50mum_CeCu6_b-axis\2nd measurement\'; %here 'start_values.dat' will be stored
rootmf='D:\Data\Shang\CECU6\2017_05_17 H04_50mum_CeCu6_b-axis\2nd measurement\measurement\';
rootsve='D:\Data\Shang\CECU6\2017_05_17 H04_50mum_CeCu6_b-axis\2nd measurement\analysis\';
roottemp='D:\Data\Shang\CECU6\2017_05_17 H04_50mum_CeCu6_b-axis\2nd measurement\';
filename_st_val='start_values.dat';

[clbrsr,modes,fca,sb,sbem,cmct,cst,mlbub,checkspltat,sret,crit_temp,ro,awig,...
        torb,stwt1,colabs,ls]=call_answer(root,filename_st_val);
modes
%sort modes, get temp file, get background files (if required), export data?
[modelst,filepathmf,filepathexp,filenamebg,filepathbg,tempsmc,temps,fields,rows,cols,...
    qdexp,sampletemp]...
    =call_getfilescmplx(rootmf,rootsve,root,roottemp,clbrsr,checkspltat,modes,cmct,cst,ro,sb,sbem,...
    sret,torb,newargnumb,newargdel);
modelst

%clbrsr=0,1,2: rows=noofT; cols=T,f0,fB,Q; pages=noofm
%clbrsr=3: rows=noofB; cols=T,f0,fB,Q; pages=noofT
fitreslst=ones(rows,4,cols);
%cols=ig
iglst=ones(rows,10,cols);
%cols=lb and ub
lbublst=ones(rows,2,cols);

%start main sequence
wt=1;%for clbrsr=3 without dlg-box
col=1;
while col<=cols
    row=1;
    %cpg: current page. for cl this is list of modes. for br or sr it is 1 or 2 respectively
    cpg=col;
    if sret==7;else;cpgimp=cpg;end;if torb==2;div=1;else;div=10^9;end; %for import
    while row<=rows
        %import data
        %use here clbrsr(col) since depending on br or sr col 1 or col 2 is used. lst0 is original list without sb of mgt field!;lst2 for magnetic field
        lst=importdata(strcat(filepathmf,modelst{row,cpgimp}));lst=lst.data;lst(:,1)=lst(:,1)/div;lst0=lst;
        %import magnetic field (if required)
        if (row==1 && sb==1);[bg]=call_import_bg(sbem,filenamebg,filepathbg,col);end;
        %substract background (if required)
        if sb==1;[ret]=call_substr_bg(lst,bg,sbem);lst=ret;else;bg=[];end;
        %perform first fit (call ig)
        if row==1
            [iglst,fitreslst,plotdata,next_row,lbublst,lst,lst0,ls]...
                = call_ig_thoroughly_cases(lst,lst0,filepathmf,modelst,cpg,fca,bg,sb,sbem,sret,clbrsr,col,temps,row,...
                    fitreslst,iglst,lbublst,stwt1,torb,colabs,fields,wt,awig);
        end
        disp(row)     
        %select range and perform fit
        if row>1
            %select range
            [lst,lbublst,skip]...
                =call_select_range(clbrsr,mlbub,lst,row,cpg,filepathmf,modelst,fca,bg,sb,sbem,sret,lbublst,...
                crit_temp,colabs);
            %fit
            [iglst,fitreslst,lbublst,next_row,plotdata]...
                = call_perform_fit(row,clbrsr,lst,lst0,cpg,fca,sb,sret,...
                       crit_temp,awig,temps,fitreslst,iglst,lbublst,colabs,fields,skip);
        end
        %exp fit of resonance
        call_exp_fit(qdexp,lst,plotdata,temps,row,tempsmc,sb,fca,torb,colabs,sampletemp,modelst,...
                col,clbrsr,modes,ls,filepathexp);
        %go to next row
        if next_row==1;row=row+1;end;
    end;   
    %plot fB
    call_plotfB(clbrsr,cols,modes,fitreslst,1,temps,cpg);
    %continue?
    [col,exp_data] = call_continue(col,cols,clbrsr,wt);
    %export data
    if exp_data==1;call_export_cmplx(fitreslst,iglst,modelst,filepathexp,sb,cpg,clbrsr,fca,torb,ls,sampletemp,temps,modes);end;
end;

%plot for one(all) mode(s)
call_plotfB(clbrsr,cols,modes,fitreslst,0,temps,cpg);
close(figure(1));close(figure(2));close(figure(3));close(figure(5));close(figure(6));
