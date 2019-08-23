function [] = call_exp_data_cases(fitreslst,iglst,modelst,spltat,filepathexp,sb,cpg,clbrsr,fca,torb,cpgimp,ls,sampletemp,col,temps)


if exp_data==1
    if strcmpi(qdexp,'Yes')
        call_export_cmplx(fitreslst,iglst,modelst,spltat,filepathexp,sb,cpg,clbrsr,fca,torb,cpgimp,ls,sampletemp,col,temps)  
    end
end
exp_data=0;

