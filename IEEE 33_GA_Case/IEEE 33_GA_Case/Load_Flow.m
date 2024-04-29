function [FIT,SPL,SQL,SVD,SV,SVSI,Pl,Ql]=Load_Flow(QC)
%% Intial Parameter
format short;
m=load('loaddata33bus.m');
l=load('linedata33bus.m');
%% Preparing Data
br=length(l);
no=length(m);
f=0;
d=0;
MVAb=100;
KVb=11;
Zb=(KVb^2)/MVAb;
% Per unit Values
for i=1:br
    R(i,1)=(l(i,4))/Zb;
    X(i,1)=(l(i,5))/Zb;
end
for i=1:no
    P(i,1)=((m(i,2))/(1000*MVAb));
    if QC(2)==i
    Q(i,1)=((m(i,3)-QC(1))/(1000*MVAb));
    else
    Q(i,1)=((m(i,3))/(1000*MVAb));    
    end

end
R;
X;
P;
Q;
C=zeros(br,no);
for i=1:br
    a=l(i,2);
    b=l(i,3);
    for j=1:no
        if a==j
            C(i,j)=-1;
        end
        if b==j
            C(i,j)=1;
        end
    end
end
C;
e=1;
for i=1:no
    d=0;
    for j=1:br
        if C(j,i)==-1
            d=1;
        end
    end
    if d==0
        endnode(e,1)=i;
        e=e+1;
    end
end
endnode;
h=length(endnode);
for j=1:h
    e=2;
    
    f=endnode(j,1);
   % while (f~=1)
   for s=1:no
     if (f~=1)
       k=1;  
       for i=1:br
           if ((C(i,f)==1)&&(k==1))
                f=i;
                k=2;
           end
       end
       k=1;
       for i=1:no
           if ((C(f,i)==-1)&&(k==1));
                f=i;
                g(j,e)=i;
                e=e+1;
                k=3;
           end            
       end
     end
   end
end
for i=1:h
    g(i,1)=endnode(i,1);
end
g;
w=length(g(1,:));
for i=1:h
    j=1;
    for k=1:no 
        for t=1:w
            if g(i,t)==k
                g(i,t)=g(i,j);
                g(i,j)=k;
                j=j+1;
             end
         end
    end
end
g;
for k=1:br
    e=1;
    for i=1:h
        for j=1:w-1
            if (g(i,j)==k) 
                if g(i,j+1)~=0
                    adjb(k,e)=g(i,j+1);            
                    e=e+1;
                else
                    adjb(k,1)=0;
                end
             end
        end
    end
end
adjb;
for i=1:br-1
    for j=h:-1:1
        for k=j:-1:2
            if adjb(i,j)==adjb(i,k-1)
                adjb(i,j)=0;
            end
        end
    end
end
adjb;
x=length(adjb(:,1));
ab=length(adjb(1,:));
for i=1:x
    for j=1:ab
        if adjb(i,j)==0 && j~=ab
            if adjb(i,j+1)~=0
                adjb(i,j)=adjb(i,j+1);
                adjb(i,j+1)=0;
            end
        end
        if adjb(i,j)~=0
            adjb(i,j)=adjb(i,j)-1;
        end
    end
end
adjb;
for i=1:x-1
    for j=1:ab
        adjcb(i,j)=adjb(i+1,j);
    end
end
b=length(adjcb);

% voltage current program

for i=1:no
    vb(i,1)=1;
end
for S=1:5
for i=1:no
    nlc(i,1)=conj(complex(P(i,1),Q(i,1)))/(vb(i,1));
end
nlc;
for i=1:br
    Ibr(i,1)=nlc(i+1,1);
end
Ibr;
xy=length(adjcb(1,:));
for i=br-1:-1:1
    for k=1:xy
        if adjcb(i,k)~=0
            u=adjcb(i,k);
            %Ibr(i,1)=nlc(i+1,1)+Ibr(k,1);
            Ibr(i,1)=Ibr(i,1)+Ibr(u,1);
        end
    end      
end
Ibr;
for i=2:no
      g=0;
      for a=1:b 
          if xy>1
            if adjcb(a,2)==i-1 
                u=adjcb(a,1);
                vb(i,1)=((vb(u,1))-((Ibr(i-1,1))*(complex((R(i-1,1)),X(i-1,1)))));
                g=1;
            end
            if adjcb(a,3)==i-1 
                u=adjcb(a,1);
                vb(i,1)=((vb(u,1))-((Ibr(i-1,1))*(complex((R(i-1,1)),X(i-1,1)))));
                g=1;
            end
          end
        end
        if g==0
            vb(i,1)=((vb(i-1,1))-((Ibr(i-1,1))*(complex((R(i-1,1)),X(i-1,1)))));
        end
end
end
nlc;
Ibr;
V=vb;
vbp=[abs(vb) angle(vb)*180/pi];


for i=1:no
vbp(i,1)=abs(vb(i));
vbp(i,2)=angle(vb(i))*(180/pi);
end


for i=1:no
    va(i,2:3)=vbp(i,1:2);
end
for i=1:no
    va(i,1)=i;
end
va;
Ibrp=[abs(Ibr) angle(Ibr)*180/pi];
PL(1,1)=0;
QL(1,1)=0;

% losses
for f=1:br
    Pl(f,1)=(Ibrp(f,1)^2)*R(f,1);
    Ql(f,1)=X(f,1)*(Ibrp(f,1)^2);
    PL(1,1)=PL(1,1)+Pl(f,1);
    QL(1,1)=QL(1,1)+Ql(f,1);
    VSI(f)=abs(V(l(f,1)))^4-4*(P(l(f,2))*R(f,1)+Q(l(f,2))*X(f,1))^2*abs(V(l(f,1)))^2-4*((P(l(f,2))*X(f,1)-Q(l(f,2))*R(f,1)))^2;
end
Plosskw=(Pl)*100000;
Qlosskw=(Ql)*100000;
PL=(PL)*100000;
QL=(QL)*100000;
voltage = vbp(:,1);


VD=sum((1-voltage));
SPL=PL;
SQL=QL;
SV=voltage;
SVD=VD;
SVSI=min(abs(VSI));
FIT=(SPL/201.89)+(SQL/134.64)+(SVD/1.7)+(SVSI/0.7);


