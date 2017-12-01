S=49; % number of initial susceptible
I=1; % number of initial infected
R=0; % number of initial recovered
N=S+I+R; % total number
a=1/4.5; % infectivity
b=1/7; % recovery rate
dt=1; % time interval = a day
tmax=120;
clockmax=ceil(tmax/dt);
Ssave=zeros(1,clockmax+1);
Isave=zeros(1,clockmax+1);
Rsave=zeros(1,clockmax+1);
Nsave=zeros(1,clockmax+1);
tsave=zeros(1,clockmax+1);

Ssave(1)=S;
Isave(1)=I;
Rsave(1)=R;
Nsave(1)=N;
tsave(1)=0;

for clock = 1:clockmax
    t = clock*dt;
    S2I = dt*S*(I/N)*a;
    I2R = dt*I*b;
    S = S - S2I;
    I = I + S2I - I2R;
    R = R + I2R;
    N = S + I + R;
    
    tsave(clock+1) = t;
    Ssave(clock+1) = S;
    Isave(clock+1) = I;
    Rsave(clock+1) = R;
    Nsave(clock+1) = N;
end

plot(tsave(1),Ssave(1),'bo',tsave(1),Isave(1),'ro',...
    tsave(1),Rsave(1),'go',tsave(1),Nsave(1),'ko',...
    'markers',3);
axis([0,clockmax,0,1.2*(Nsave(1))])
axis manual

for i=2:clockmax+1
    hold on
    plot(tsave(i),Ssave(i),'bo',tsave(i),Isave(i),'ro',...
        tsave(i),Rsave(i),'go',tsave(i),Nsave(i),'ko',...
        'markers',3);
    title("Deterministic Model: Swine Flu")
    pause(0.05)
end
hold off
