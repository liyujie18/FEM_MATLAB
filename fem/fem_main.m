clear;clc;
%% �����״
figure
x_l=[0 0];x_b1=[0 2];x_b3=[4 10];x_r=[10 10];x_t=[10 0];
y_l=[0 -8];y_b1=[-8 -8];y_b3=[-6 -2];y_r=[-2 0];y_t=[0 0];
x_center1=4;y_center1=-8;
n_c=11;%Բ���ȷֱ���n_c 
c1=linspace(pi,pi/2,n_c);r1=2;
x_b2=r1*cos(c1)+x_center1;
y_b2=r1*sin(c1)+y_center1;
x=[x_l,x_b1,x_b2,x_b3,x_r,x_t];
y=[y_l,y_b1,y_b2,y_b3,y_r,y_t];
plot(x,y)
hold on
axis equal
xlabel('x��');ylabel('y��'); title('ͼ��'); 


%% �ָ�����
tempx=x_t(2);tempy=y_t(2);
x_t(2)=3; y_t(2)=0;%x_b3(1)   x_b1(2)
x_t(3)=1; y_t(3)=0 ;%x_b1(2)    
x_t(4)=tempx; y_t(4)=tempy ;
cut_point=[x_t(2), y_t(2);x_t(3), y_t(3)];    
%�ָ�������
x_cutline1=[ x_t(2),x_b3(1)]; 
y_cutline1=[ y_t(2),y_b3(1)];
x_cutline2=[ x_t(3),x_b1(2)]; 
y_cutline2=[ y_t(3),y_b1(2)];
%���Ʒָ���
plot(x_cutline1, y_cutline1,'m');
plot(x_cutline2, y_cutline2,'m');


%% ���Ͻڵ㣨�������±����ӽڵ㣩
n=[10 30 30 10 10];%�������ӽڵ���,30*50����Ԫ��31*51����
x_b1point=linspace(x_b1(1),x_b1(2),n(1)+1);y_b1point=linspace(y_b1(1),y_b1(2),n(1)+1);
x_b3point=linspace(x_b3(1),x_b3(2),n(2)+1);y_b3point=linspace(y_b3(1),y_b3(2),n(2)+1);
x_t1point=linspace(x_t(2),x_t(1),n(3)+1);y_t1point=linspace(y_t(2),y_t(1),n(3)+1);
x_t2point=linspace(x_t(3),x_t(2),n(4)+1);y_t2point=linspace(y_t(3),y_t(2),n(4)+1);
x_t3point=linspace(x_t(4),x_t(3),n(5)+1);y_t3point=linspace(y_t(4),y_t(3),n(5)+1);
%�����������ŵ�
x_bpoint=[x_b1point(1:n(1)),x_b2,x_b3point(2:n(2)+1)];y_bpoint=[y_b1point(1:n(1)),y_b2,y_b3point(2:n(2)+1)];
x_tpoint=[x_t3point(1:n(5)),x_t2point,x_t1point(2:n(3)+1)];y_tpoint=[y_t3point(1:n(5)),y_t2point,y_t1point(2:n(3)+1)];


%% ��������д����������
hold on
m=30;% ����������Ŀ
for i=1:51               
    %������ 
    plot([x_tpoint(i),x_bpoint(i)],[y_tpoint(i),y_bpoint(i)],'k');
    % ����
    %����m�ȷ֣�ֱ�ӵõ�x,y����,x1�Ǻ�����,y1�������꣬˳�����֮�£��������� 
    x1(i,:)=linspace(x_tpoint(i),x_bpoint(i),m+1);    
    y1(i,:)=linspace(y_tpoint(i),y_bpoint(i),m+1);
end

% ����������Ϊһά����
for j=1:51
    for i=1:31
        x2(i+(j-1)*31)=x1(j,i);
        y2(i+(j-1)*31)=y1(j,i);
    end
end

% ���ƺ���
for i=1:m 
    for j=51:-1:2 %j,i��j,i-1��
        plot([x1(j,i) x1(j-1,i)],[y1(j,i) y1(j-1,i)],'k');
    end
end


%% ��Ԫ�����
for j=1:50   %�кţ�20�е�Ԫ��21�е�
    for i=1:m  %�кţ�m�е�Ԫ��m+1�е�
        % �������£��������ұ��
        p1=i+(j-1)*(m+1);%��j�У���i�б�ţ��ı��ε�һ���㣩
        p2=i+1+(j-1)*(m+1); %��j�У���i+1�б��
        p3=i+1+j*(m+1); %��j+1�У���i+1�б��
        p4=i+j*(m+1);%��j+1�У���i�б�� 
        t=i+(j-1)*m; %��Ԫ�ı�ţ��������£���������
        % ��Ԫ�����ĵ�ı��
        e(t,:)=[p1,p2,p3,p4];
    end
end


%% �����ܸնȾ���
E=70E6;%����ģ��
NU=0.25;%���ɱ�
h=0.02;%���
K=zeros(2*31*51,2*31*51);
k=zeros(8,8);
for j=1:30%i�ǵ�Ԫ���кţ�j�ǵ�Ԫ���к�
    for i=1:50
        t=i+(j-1)*50;
        p1=e(t,1);p2=e(t,2);p3=e(t,3);p4=e(t,4);%��ȡ��Ԫ�ڵ�ı�ŵ�p1,p2,p3,p4
        k=k+stiffness(E,NU,h,x2(p2),y2(p2),x2(p3),y2(p3),x2(p4),y2(p4),x2(p1),y2(p1),1);
        K=assemble(K,k,p2,p3,p4,p1);
    end
end


%% ����K*u=f���λ�ƾ��� ��һ���㷨
% �նȾ���K1,��λ��Ϊ0�Ķ�Ӧ�նȾ���Խ�����1��������0
K1=K;
for i=1:31*2
    K1(i,i)=1;
    for j=i+1:3162
        K1(j,i)=0;
        K1(i,j)=0;
    end
end
% �غɾ���f,����һ���������غ�(����һ�������غɵ�ͼ��)
f=zeros(3162,1);
f(3102)=-20;
% �ⷽ�̣�λ�ƾ���u��ÿ����u��v����װ
u=K1\f;


%% ���κ��ͼ��λ�ƣ�
%��u��Ϊx��y�����ϵ�λ��
for i=1:31*51
    u1(i)=u(2*i-1);
    u2(i)=u(2*i);
end
% ����ֵ����λ��ֵ=λ�Ʊ��κ��ͼ��
for i=1:31*51
    x3(i)=x2(i)+u1(i)*1e7;
    y3(i)=y2(i)+u2(i)*1e7;
end

% ����λ��ͼ
figure
hold on
% ����
for i=1:51
    for j=1:30
        plot([x3(j+(i-1)*31),x3(j+1+(i-1)*31)],[y3(j+(i-1)*31),y3(j+1+(i-1)*31)],'r');
    end
end
% ����
for i=1:50
    for j=1:31
        plot([x3(j+(i-1)*31),x3(j+i*31)],[y3(j+(i-1)*31),y3(j+i*31)],'r');
    end
end
xlabel('x��');ylabel('y��'); title('���κ�ͼ��'); 


%% ����λ����ͼ(U)
figure
hold on
for i=1:30*50
    j=e(i,:);
    fill(x3(j),y3(j),sqrt(u1(j).^2+u2(j).^2),'FaceColor','interp');
end
shading interp;
colorbar;
colormap jet;
axis equal;
xlabel('x��');ylabel('y��'); title('���κ�ͼ���ϵ�Uλ����ͼ'); 


%% ����λ����ͼ(U1)
figure
hold on
for i=1:30*50
    j=e(i,:);
    fill(x3(j),y3(j),u1(j),'FaceColor','interp');
end
shading interp;
colorbar;
colormap jet;
axis equal;
xlabel('x��');ylabel('y��'); title('���κ�ͼ���ϵ�U1λ����ͼ'); 


%% ����λ����ͼ(U2)
figure
hold on
for i=1:30*50
    j=e(i,:);
    fill(x3(j),y3(j),u2(j),'FaceColor','interp');
end
shading interp;
colorbar;
colormap jet;
axis equal;
xlabel('x��');ylabel('y��'); title('���κ�ͼ���ϵ�U2λ����ͼ'); 



%% RF=K*u;���㷴��
RF=K*u;
for i=1:31*51
    RF1(i)=RF(2*i-1);
    RF2(i)=RF(2*i);
end
for i=1:51
    for j=1:31
        RF11(j,i)=RF1(j+(i-1)*31);
        RF22(j,i)=RF2(j+(i-1)*31);
    end
end


%% ���Ʒ�����ͼ��RF��RF1��RF2
figure
hold on
pcolor(x1',y1',sqrt(RF11.^2+RF22.^2));
colormap jet;
colorbar;
axis equal;
xlabel('x��');ylabel('y��'); title('����RF��ͼ'); 
caxis([0,1]);

figure
hold on
pcolor(x1',y1',RF11);
colormap jet;
colorbar;
axis equal;
xlabel('x��');ylabel('y��'); title('����RF1��ͼ'); 
caxis([0,1]);

figure
hold on
pcolor(x1',y1',RF22);
colormap jet;
colorbar;
axis equal;
xlabel('x��');ylabel('y��'); title('֧����RF2��ͼ'); 
caxis([0,1]);


%% ���㵥ԪӦ��,������Ӧ��
% ��ԪӦ��
stress=zeros(30*50,3);
strain=zeros(30*50,3);
for j=1:30
    for i=1:50
        t=i+(j-1)*50;
        %��ȡ��Ԫ�ڵ�ı�ŵ�p1,p2,p3,p4
        p1=e(t,1);p2=e(t,2);p3=e(t,3);p4=e(t,4);
        %����Ԫ�ĸ����λ��
        uel=[u1(p2);u2(p2);u1(p3);u2(p3);u1(p4);u2(p4);u1(p1);u2(p1)];
        %����Ԫ���ĵ�Ӧ����Ӧ��
        [stress(t,:),strain(t,:)]=stressandstrain(E,NU,x2(p2),y2(p2),x2(p3),y2(p3),x2(p4),y2(p4),x2(p1),y2(p1),uel);
    end
end


% ������Ӧ����С�������
sigma=zeros(30*50,3);
for j=1:30
    for i=1:50
        t=i+(j-1)*50;
        sigma(t,:)=PStresses(stress(t,:));
    end
end


%% ������Ӧ����ͼǰ���ݴ����ڵ㴦Ӧ�����ڹ��øýڵ㵥Ԫ��Ӧ����ƽ��
com=zeros(31*51,5);%com��һ�д洢�м�����Ԫ���øõ㣬�����д洢��Ԫ��ţ��������е�Ϊ0��
for i=1:30*50
    com(e(i,1),1)=com(e(i,1),1)+1;
    com(e(i,1),com(e(i,1),1)+1)=i;
    com(e(i,2),1)=com(e(i,2),1)+1;
    com(e(i,2),com(e(i,2),1)+1)=i;
    com(e(i,3),1)=com(e(i,3),1)+1;
    com(e(i,3),com(e(i,3),1)+1)=i;
    com(e(i,4),1)=com(e(i,4),1)+1;
    com(e(i,4),com(e(i,4),1)+1)=i;
end
%��ȡsigma��һ��
for i=1:50*30
    sigma1(i)=sigma(i,1);
    sigma2(i)=sigma(i,2);
    sigma3(i)=sigma(i,3);
end
% ����ڵ㴦Ӧ��ֵ�����ܱߵ�ԪӦ����ƽ��ֵ��
sigma1=[sigma1,0];
sigma2=[sigma2,0];
sigma3=[sigma3,0];
for i=1:31*51
    for j=2:5
%         ���ڵ���sigma1ʱ�±겻��Ϊ0�����Խ�sigma1������һ��0��
%         ��com(i,j)==0ʱ��sigma1���������ɽ������
        if com(i,j)==0 
            com(i,j)=30*50+1;
        end
    end
    %����ĵ�һ��Ӧ��
    sigmanode1(i)=(sigma1(com(i,2))+sigma1(com(i,3))+sigma1(com(i,4))+sigma1(com(i,5)))/com(i,1);
    %����ĵڶ���Ӧ��
    sigmanode2(i)=(sigma2(com(i,2))+sigma2(com(i,3))+sigma2(com(i,4))+sigma2(com(i,5)))/com(i,1);
end

%% ���Ƶ�һ��Ӧ����ͼ
% ����fill�����Ϳ��Եõ��ı��ε�stress��ͼ���������˼·��
% �����ڵõ�����Ԫ��������нڵ��Ӧ��ֵ�󣬿��ԶԵ�Ԫ����ÿ
% ���ӵ�Ԫ��Ӧ����ͼ���ƣ�ѭ�������еĵ�Ԫ��Ϳ��Եõ����������Ӧ����ͼ�ˡ�
figure
hold on
for i=1:30*50
    j=e(i,:);
    fill(x2(j),y2(j),sigmanode1(j),'FaceColor','interp');
end
shading interp;% ȥ������ʹ��ͼ��ƽ��ƽ��
colorbar;
colormap jet;
axis equal;
xlabel('x��');ylabel('y��'); title('��һ��Ӧ����ͼ'); 
caxis([-1 20]);


%% ���Ƶڶ���Ӧ����ͼ
figure
hold on
for i=1:30*50
    j=e(i,:);
    fill(x2(j),y2(j),sigmanode2(j),'FaceColor','interp');
end
shading interp;
colorbar;
colormap jet;
axis equal;
xlabel('x��');ylabel('y��'); title('�ڶ���Ӧ����ͼ'); 


%% ����miseӦ����Ӧ����ͼǰ�����ݴ���
for i=1:50*30
    stress1(i)=stress(i,1);
    stress2(i)=stress(i,2);
    stress3(i)=stress(i,3);
    strain1(i)=strain(i,1);
    strain2(i)=strain(i,2);
    strain3(i)=strain(i,3);
end
% ����ڵ㴦Ӧ��ֵ�����ܱߵ�ԪӦ����ƽ��ֵ��
stress1=[stress1,0];
stress2=[stress2,0];
stress3=[stress3,0];
strain1=[strain1,0];
strain2=[strain2,0];
strain3=[strain3,0];
for i=1:31*51
    for j=2:5
%         ���ڵ���sigma1ʱ�±겻��Ϊ0�����Խ�sigma1������һ��0��
%         ��com(i,j)==0ʱ��sigma1���������ɽ������
        if com(i,j)==0 
            com(i,j)=30*50+1;
        end
    end
    %�����stress1ƽ��ֵ
    stressnode1(i)=(stress1(com(i,2))+stress1(com(i,3))+stress1(com(i,4))+stress1(com(i,5)))/com(i,1);
    %�����stress2ƽ��ֵ
    stressnode2(i)=(stress2(com(i,2))+stress2(com(i,3))+stress2(com(i,4))+stress2(com(i,5)))/com(i,1);
    %�����stress3ƽ��ֵ
    stressnode3(i)=(stress3(com(i,2))+stress3(com(i,3))+stress3(com(i,4))+stress3(com(i,5)))/com(i,1);
    %�����miseӦ��
    mise(i)=(((stressnode1(i)-stressnode2(i))^2+(stressnode2(i)-stressnode3(i))^2+(stressnode3(i)-stressnode1(i))^2)/2)^0.5;
    %�����strain1ƽ��ֵ
    strainnode1(i)=(strain1(com(i,2))+strain1(com(i,3))+strain1(com(i,4))+strain1(com(i,5)))/com(i,1);
    %�����strain2ƽ��ֵ
    strainnode2(i)=(strain2(com(i,2))+strain2(com(i,3))+strain2(com(i,4))+strain2(com(i,5)))/com(i,1);
    %�����strain3ƽ��ֵ
    strainnode3(i)=(strain3(com(i,2))+strain3(com(i,3))+strain3(com(i,4))+strain3(com(i,5)))/com(i,1);
    %�����Ӧ��
    strain0(i)=(((strainnode1(i)-strainnode2(i))^2+(strainnode2(i)-strainnode3(i))^2+(strainnode3(i)-strainnode1(i))^2)/2)^0.5;
end


%% ����miseӦ����ͼ
figure
hold on
for i=1:30*50
    j=e(i,:);
    fill(x2(j),y2(j),mise(j),'FaceColor','interp');
end
shading interp;% ȥ������ʹ��ͼ��ƽ��ƽ��
colorbar;
colormap jet;
axis equal;
xlabel('x��');ylabel('y��'); title('miseӦ����ͼ'); 
caxis([-1 5]);


%% ����Ӧ����ͼ
figure
hold on
for i=1:30*50
    j=e(i,:);
    fill(x2(j),y2(j),strain0(j),'FaceColor','interp');
end
shading interp;% ȥ������ʹ��ͼ��ƽ��ƽ��
colorbar;
colormap jet;
axis equal;
xlabel('x��');ylabel('y��'); title('Ӧ����ͼ'); 

% 
% %% pcolor��ͼ,���뽫X,Y,C������Ϊ��״����
% for i=1:51
%     for j=1:31
%         sigmanode11(j,i)=sigmanode(j+(i-1)*31);
%     end
% end
% figure
% hold on
% pcolor(x1',y1',sigmanode11);
% colormap jet;
% % shading interp;%ȥ��������
% colorbar;
% axis equal;
% xlabel('x��');ylabel('y��'); title('sigma1��ͼ'); 
