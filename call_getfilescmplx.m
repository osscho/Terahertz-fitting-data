function [modelst,filepathmf,filepathexp,filenamebg,filepathbg,tempsmc,temps,fields,rows,cols,...
    qdexp,sampletemp]...
    =call_getfilescmplx(rootmf,rootsve,root,roottemp,clbrsr,checkspltat,modes,cmct,cst,ro,sb,sbem,...
    sret,torb,newargnumb,newargdel)

%clbrsr=0;checkspltat=0;noofm=12;cmct=1;cst=7;
%ro=1;%reverse order
%rootmf='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(1.0)_29.07.2016\run1\measurement\all\';
%roottemp='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(1.0)_29.07.2016\run1\';
%rootsve='C:\Users\Manfred Beutel\Dropbox\Masterarbeit\Messung\NbSTO(1.0)_29.07.2016\analysis_run1\complex_cl_sb0\'

%create paths for export (if required)
qdexp=questdlg('export data?','quest dlg','Yes','No','Yes');
if strcmpi(qdexp,'Yes')
    rootsve=uigetdir(rootsve,'save results (results folder will be created here)');
    rootsve=strcat(rootsve,'\');
    switch clbrsr
        case 0
            filepathexp=cell(1,length(modes)+1);%root folder for fit results and folder for each mode
            filepathexp{1,1}=rootsve;
            for i=1:1:length(modes)
                path=strcat(rootsve,'mode',num2str(modes(i)),'\');
                mkdir(path);
                filepathexp{i+1}=path;
            end
        case 3
            filepathexp=cell(1,2);%rootfolder and fitted spectrum folder
            filepathexp{1,1}=rootsve;
            path=strcat(rootsve,'fitted spectrum');
            mkdir(path);
            filepathexp{1,2}=strcat(path,'\');
    end
else
    filepathexp='C:\Users\';
end
%get measurement files
cols=length(modes);
del1=newargdel{11};del2=newargdel{12};del3=newargdel{13};del4=newargdel{14};
noofT0=newargnumb(5);tempindav=newargnumb(6);
switch clbrsr
    case 0
        sampletemp=0.02;%just that output is not empty
        [filename,filepathmf]=uigetfile({'*.dat'},'choose measurement files',rootmf,'MultiSelect','on');
        if torb==1;
            sampletemp=inputdlg({filename{1}},'enter sample temperature in K for this field sweep',[1 150],{'0.01'});
            sampletemp=str2num(sampletemp{1});
        end
        del1=newargdel{11};del2=newargdel{12};del3=newargdel{13};del4=newargdel{14};
        noofT0=newargnumb(5);tempindav=newargnumb(6);
        if iscell(filename) %check if one file or multiple files was/were chosen
            if checkspltat==1
                splt=strsplit(filename{1},{del1,del2});
                str='';i=1;
                while i~=length(splt)
                    str=strcat(str,splt{i},'-dlmt-');
                    i=i+1;
                end;strf0ind=strcat(str,splt{end});
                splt=strsplit(filename{1},{del3,del4});
                str='';i=1;
                while i~=length(splt)
                    str=strcat(str,splt{i},'-dlmt-');
                    i=i+1;
                end;strTind=strcat(str,splt{end});
                if tempindav==1
                    inp=inputdlg({strcat('modeind: ',strf0ind),strcat('Tind: ',strTind)},...
                        'enter position of mode and temp index (if mode is not separated open dialog by entering 0)',[1,160],{'2','1'});
                else
                    inp=inputdlg({strcat('modeind: ',strf0ind),'enter one'},...
                        'enter position of mode and temp index (if mode is not separated open dialog by entering 0)',[1,120],{'2','1'});
                end
                if isempty(inp)
                    spltatf0ind=2;
                    spltatTind=2;
                else  
                   spltatf0ind=str2num(inp{1});
                   spltatTind=str2num(inp{2});
                end;
                if spltatf0ind==0
                    qd='No';
                    while qd~='Yes'
                        inp=inputdlg({strcat(filename{1},'_delimiter1:'),strcat(filename{1},'_delimiter2:')},'enter delimiter',[1 50],{'Mode','min'});                        
                        del1=inp{1};
                        del2=inp{2};
                        splt=strsplit(filename{1},{del1,del2})     
                        str2'';i=1;
                        while i~=length(splt)
                            str=strcat(str,splt{i},'-dlmt-');
                        end;str=strcat(str,splt{end})                               
                        qd=questdlg(str,'is mode separated?','Yes','No','Yes');
                    end
                    inp=inputdlg(str,'enter position of mode',[1,50],{'2'});
                    spltatf0ind=str2num(inp{1});
                end;
            else
                spltatf0ind=newargnumb(7);
                spltatTind=newargnumb(8);
            end;
            if tempindav==0
                %find number of modes in mf
                detmodes=ones(length(filename),1);
                for i=1:1:length(filename)
                    spltf0ind=strsplit(filename{i},{del1,del2});
                    detmodes(i)=str2num(spltf0ind{spltatf0ind});
                end
                %get number of temperatures by counting occurence of one mode in detmodes list
                ts=sum(length(find(detmodes==detmodes(1))));%ts counts the temperatures
                ms=length(filename)/ts;%maximum number of modes in specified measurement folder
                %check if modes are arranged like 1,2,3,4,1,2,3,4... or %1,1,1,1,1,2,2,2,2,2,... in order get the actual mode number specified in filename
                if length(find(detmodes(1:ms)==detmodes(1)))==1 %if the first modename occurs only once in this range, they are arranged like 1,2,3,4,1,2,3,4,...
                    intmodes=detmodes(1:ms);%internalmodes (do not call it modes, as modes is specified by user)
                else
                    intmodes=ones(1,ms);
                    for i=1:1:ms
                        intmodes(i)=detmodes(1+(i-1)*ts);
                    end
                end
                if ms~=length(modes)
                    waitfor(msgbox(strcat('I detected that you named not all modes which are actually in the measurement folder. I counted it and I found ',...
                        num2str(ms),' modes. Be proud of me and go on!'),'title','modal'));
                end
                detmodes=[];
                tind=zeros(1,ms);
                tinds=ones(length(filename),1);
                for i=1:1:length(filename)
                    spltf0ind=strsplit(filename{i},{del1,del2});
                    indexf0=find(intmodes==str2num(spltf0ind{spltatf0ind}));
                    tind(indexf0)=tind(indexf0)+1;                 
                    tinds(i)=tind(indexf0);
                end
                noofT0=ts;
            end
            modelst=cell(noofT0,length(modes));
            for i=1:1:length(filename)
                spltf0ind=strsplit(filename{i},{del1,del2});
                indexf0=find(modes==str2num(spltf0ind{spltatf0ind}));
                if tempindav==1
                    spltTind=strsplit(filename{i},{del3,del4});
                    indexT=str2num(spltTind{spltatTind});
                else
                    indexT=tinds(i);
                end
                modelst(indexT,indexf0)=filename(i);
            end
        else
            spltat=2;
            modelst={filename};
            count=1;
        end;
        modelst
        %rows=temps; cols=modes       
        rows=length(modelst(:,1));
        cols=length(modelst(1,:));
        if (rows~=noofT0 && tempindav==1)
            inp=inputdlg(strcat('you said there are ',num2str(noofT0),' temps but I count: ',num2str(length(modelst(:,1))),...
                '. Enter correct no.!'),'title',[1,120],{'50'});
            rows=str2num(inp{1});
        end

%--------------------------------------------------------------------------------------------------------------------------------        
    case 3
        cols=newargnumb(2);
        %newargdel=[del31,del32,del33,del34,del35,del36,del37,del38];
        [filename,filepathmf]=uigetfile({'*.dat'},'choose measurement files (temp&field)',rootmf,'MultiSelect','on');
        if checkspltat==1
            spltBind=strsplit(filename{1},{newargdel{1},newargdel{2}});
            spltBval=strsplit(filename{1},{newargdel{3},newargdel{4}});
            spltmodeno=strsplit(filename{1},{newargdel{9},newargdel{10}});
            strBind='';strBval='';strTind='';strTval='';strmodeno='';
            for i=1:1:length(spltBind)
                strBind=strcat(strBind,spltBind{i},'-dlmt-');
            end;
            for i=1:1:length(spltBval)
                strBval=strcat(strBval,spltBval{i},'-dlmt-');
            end;
            for i=1:1:length(spltmodeno)
                strmodeno=strcat(strmodeno,spltmodeno{i},'-dlmt-');
            end;            
            if tempindav==1
                spltTind=strsplit(filename{1},{newargdel{5},newargdel{6}});
                spltTval=strsplit(filename{1},{newargdel{7},newargdel{8}});
                for i=1:1:length(spltTind)
                    strTind=strcat(strTind,spltTind{i},'-dlmt-');
                end;
                for i=1:1:length(spltTval)
                    strTval=strcat(strTval,spltTval{i},'-dlmt-');
                end;
            else
                strTind='not available';
                strTval='not available';
            end
            inp=inputdlg({strcat('Bind: ',strBind),strcat('Bval: ',strBval),strcat('Tind: ',strTind),strcat('Tval: ',strTval),...
                strcat('modeno: ',strmodeno)},'title',[1,120],{num2str(newargnumb(9)),num2str(newargnumb(10)),num2str(newargnumb(11)),num2str(newargnumb(12)),...
                num2str(newargnumb(13))});
            spltatBind=str2num(inp{1});
            spltatBval=str2num(inp{2});
            spltatTind=str2num(inp{3});
            spltatTval=str2num(inp{4});
            spltatmodeno=str2num(inp{5});
        else
            spltatBind=newargnumb(9);
            spltatBval=newargnumb(10);
            spltatTind=newargnumb(11);
            spltatTval=newargnumb(12);
            spltatmodeno=newargnumb(13);
        end
        spltmodeno=strsplit(filename{1},{newargdel{9},newargdel{10}});
        if str2num(spltmodeno{spltatmodeno})~=modes(1)
            inp=inputdlg(strcat('I detect mode ',spltmodeno{spltatmodeno},'. But you entered mode',...
                num2str(modes(1)),'. Enter correct modeno!'),'title');
            modes(1)=str2num(inp{1});
        end
        if newargnumb(3)==0
            add=1;
        else
            add=0;
        end;        
        %newargnumb=[indexTst,noofT3,indexBst,noofB];
        %rows=fields; cols=temps;
        if tempindav==1
            modelst=cell(newargnumb(4),newargnumb(2));
            for i=1:1:length(filename)
                spltmodeno=strsplit(filename{i},{newargdel{9},newargdel{10}});
                if modes(1)==str2num(spltmodeno{spltatmodeno})
                    spltBind=strsplit(filename{i},{newargdel{1},newargdel{2}});
                    indexB=str2num(spltBind{spltatBind})+add;
                    spltTind=strsplit(filename{i},{newargdel{5},newargdel{6}});
                    indexT=str2num(spltTind{spltatTind});
                    modelst(indexB,indexT)=filename(i);
                end
            end
            modelst=modelst(1:newargnumb(4),:);
            if length(modelst(1,:))~=newargnumb(2)
                inp=inputdlg(strcat('you said there are ',num2str(newargnumb(2)),' temps but I count: ',num2str(length(modelst(1,:))),...
                    '. Enter correct no.!'),'title',[1,120],{'5'});
                cols=str2num(inp{1});
                modelst=modelst(:,1:cols);
            else
                cols=length(modelst(1,:));
            end
        else
            %write all fieldinds in list (rows:fieldsinds,col:filenumber when rel. mode is matched
            detBinds=ones(length(filename),2);
            for i=1:1:length(filename)
                spltmodeno=strsplit(filename{i},{newargdel{9},newargdel{10}});
                if modes(1)==str2num(spltmodeno{spltatmodeno})
                    spltBind=strsplit(filename{i},{newargdel{1},newargdel{2}});
                    indexB=str2num(spltBind{spltatBind})+add;
                    detBinds(i,:)=[indexB,i];
                end
            end
            %get number of fields
            noofB=max(detBinds(:,1));
            %get number of temps (so temps for which complete set of 1:1:noofB exists
            mvar1=zeros(4000,noofB); %rows=temps;cols=fields
            var1=1;count=1;addc=0;
            for i=1:1:length(detBinds(:,1))
                col=detBinds(i,1);
                if i>2
                    if col==detBinds(i-1,1);
                        addc=1;
                    end
                end
                mvar1(count,col+addc)=detBinds(i,1);
                if detBinds(i,1)==noofB
                    count=count+1;
                    var1=1;addc=0;
                end
            end
            for i=1:1:(noofB-1)
                test=find(mvar1(:,i)==0,1,'first');
                if (test)~=find(mvar1(:,i+1)==0,1,'first')
                    inp=inputdlg('apparently you have different number of temps for different fields...enter correct no. of temps!',...
                        'title',[1 50],{num2str(test-1)});
                    noofT=str2num(inp{1});
                    break;
                else
                    noofT=test-1;
                end
            end
            noofB
            noofT
        end
        %create temp and field file
        fields=[];
        for row=1:1:length(modelst(:,1))
            spltBval=strsplit(modelst{row,1},{newargdel{3},newargdel{4}});
            Bval=str2num(spltBval{spltatBval});
            fields=cat(1,fields,Bval);
        end
        temps=ones(length(modelst(:,1)),cols);
        for row=1:1:length(modelst(:,1))
            for col=1:1:cols
                spltTval=strsplit(modelst{row,col},{newargdel{7},newargdel{8}});
                Tval=str2num(spltTval{spltatTval});
                temps(row,col)=Tval;
            end
        end
        tempsmc=[];
        temps
        fields
        rows=length(modelst(:,1));
        %just that output is not empty
        %start
        spltat=2;
        filenamebg='';
        filepathbg='';
        sampletemp=1;
        %end
        %get modeno.
        if isempty(modelst{2,2})
            waitfor(msgbox('I could not find the mode you entered in the measurement folder. I think you lied to me, I am not happy about that. Stop & make it right!!!'));
        end
        
end
        


if ro==1
    for i=1:1:length(modelst(1,:))
        modelst(:,i)=flipud(modelst(:,i));
    end
end

if clbrsr~=3
    fields=[0];
    %get temp files
    switch torb
        case 0
            tmpstr='choose temp file';
        case 1
            tmpstr='choose field file';
        case 2
            tmpstr='choose length file';
        otherwise
            tmpstr='choose anything';
    end;
    [tempfile,roottemp]=uigetfile({'*.dat'},tmpstr,roottemp,'MultiSelect','off');
    temps=importdata(strcat(roottemp,tempfile));
    if isstruct(temps)
        temps=temps.data;
    else
        temps=temps;
    end;
    if ro==1
        temps=flipud(temps);
    end;

    noofcols=length(temps(1,:));
    if (noofcols<cmct || noofcols<cst)
        ip2=inputdlg({strcat('new value col Tmc: (old value:',num2str(cmct),')'),strcat('new value col Tsample: (old value:',num2str(cst),')')},...
            'wrong values for cmct or cst',[1 60],{'1','2'});
        cmct=str2num(ip2{1});
        cst=str2num(ip2{2});
    end
    tempsmc=temps(:,cmct);
    temps=temps(:,cst);
    %get background files
    if sb==1
        switch sbem
            case 0
                [filenamebg,filepathbg]=uigetfile({'*.dat'},'select calibration file',root,'MultiSelect','off');
            case 1
                [filenamebg,filepathbg]=uigetfile({'*.dat'},'select calibration files',root,'MultiSelect','on');
                disp(filenamebg)
                qdsrt=questdlg('sort modes?','title','Yes','No','Yes');
                if strcmpi(qdsrt,'Yes')
                    splt=strsplit(filenamebg{1},{del1,del2});
                    str='';i=1;
                    while i<length(splt)
                        str=strcat(str,splt{i},'-dlmt-');
                    end;str=strcat(str,splt{end});
                    ip=inputdlg(str,'enter position of mode',[1 50]);spltat=str2num(ip{1});
                    lst=[];
                    for i=1:1:length(filenamebg)
                        splt=strsplit(filenamebg{i},{del1,del2});splt=str2num(splt{spltat});
                        lst=cat(1,lst,[i,splt]);
                    end
                    lst2=sortrows(lst,2);
                    filenamebg2={};
                    for i=1:1:length(filenamebg)
                        filenamebg2{i}=filenamebg{lst2(i,1)};
                    end
                    filenamebg=filenamebg2;
                    filenamebg;
                end;
        end;
    else
        filepathbg='C:\Users\Manfred Beutel\Desktop\';
        filenamebg='test.dat';
    end;
end