function psob_main(N)%迭代次数2000

%-------------------------------参数介绍------------------------------------  
%S=10^6交易总金额
%X=[x1,x2,x3...xn]{sum(X)=1}整个投资组合持有的n 种股票的投资比例向量
%x0表示投资于无风险资产
%σ(theta)表示所要投资的n 种股票的方差-协方差矩阵
%p(i)第i 种股票的每股买入价格
%r(i)表示第i种股票的收益率
%n(i)第i种股票的交易手数


%----------------------------参数初始化-------------------------------------
global p r X theta S
% [theta,p,r] = suan_xiefangcha()

theta=load('theta.txt');
p=load('p.txt');
p=p';
r=load('r.txt');
r=r';




S=10^6; %总金额设为100w
k=9; %论文中取了9支股票和一只无风险股-->问题的维度
M=N;choose=0;%最大迭代次数，PSO里的情况选择


%--------------------造出初始位置-------------------------------------------
%初始化股票比例向量

i=rand(1,k+1);    % 10个0-1的随机数
j=i/(sum(i));   %化成10个投资比例
global x0
x0 = j(k+1);%无风险投资的比例
%前8项为风险投资
mon = S*(1-x0).*j(1:k)/sum(j(1:k))%风投每只股票的钱数
shou = mon./(100*p);%每只股票交易手数
nev=round(shou); % 手数取整
nev(k) = round((S*(1-x0)-sum(nev(1:k-1).*100.*p(1:k-1)))/(100*p(k)));%先前7个取整，第8个用钱数取整
%nev(8) = round(S*(1-x0)-sum(mon(1:7)));
n = nev;%8只股票的手数向量行向量

X = 100.*n.*p/S; %初始比例向量与交易手数的关系



fvalue=[];%最优风险值存储器
tic
for i = 1:1
    
%xm=PSO(choose,value,M,D) choose：求上层还是下层，value：初始值，M：最大迭代次数，D:问题的维度  
[location,fbest] = psob(choose,n,M,k);
fvalue = cat(2,fvalue,fbest);

end
toc


%----------------------结果可视化-------------------------------------------

display(['最优风险值=[',num2str(min(fvalue)),']'])
bili = 100*location.*p/S;%风投比例
n_fengxian = 1-sum(bili);%无风险比例
t_bili = cat(2,n_fengxian,bili);
display(['最优投资比例=[',num2str(t_bili),']'])