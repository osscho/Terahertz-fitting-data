function [ret] = call_substr_bg(lst,bg,sbem)

ret=ones(length(lst(:,1)),4);
switch sbem
    case 0
        samplpts=lst(:,1);
        ipre=interp1(bg(:,1),bg(:,2),samplpts);
        ipim=interp1(bg(:,1),bg(:,3),samplpts);
        ipabs=interp1(bg(:,1),bg(:,4),samplpts);

        ret(:,1)=lst(:,1);
        ret(:,2)=lst(:,2)-ipre;
        ret(:,3)=lst(:,3)-ipim;
        ret(:,4)=sqrt((lst(:,2)-ipre).^2+(lst(:,3)-ipim).^2);
    case 1
        ret(:,1)=lst(:,1);
        ret(:,2)=lst(:,2)-bg(:,2);
        ret(:,3)=lst(:,3)-bg(:,3);
        ret(:,4)=sqrt((lst(:,2)-bg(:,2)).^2+(lst(:,3)-bg(:,3)).^2);
end;