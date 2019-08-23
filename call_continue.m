function [col,exp_data] = call_continue(col,cols,clbrsr,wt)

if clbrsr==3
    quest='next temp?';
    quest2='last temp, finish or again?';
else
    quest='next mode?';
    quest2='last mode?';
end

if col<cols
    if wt==1
        qd='Yes';
        pause(5);
    else
        qd=questdlg(quest,'title','Yes','No','Yes');
    end    
    if strcmpi(qd,'Yes')
        col=col+1;
        exp_data=1;
    else
        col=col;
        exp_data=0;
    end
else
    if col==cols;
        if strcmpi(questdlg(quest2,'title','finish','again','finish'),'finish');
            col=col+1;
            exp_data=1;
        else
            exp_data=0;
            col=col;
        end
    end
end