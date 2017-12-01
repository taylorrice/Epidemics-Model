N = 50; %population size
space = 200; %variable that determines how large of a space 
                %the population has to move around in
D = space^2/10; %diffusion constant
personX = rand(1,N)*space;
personY = rand(1,N)*space;
personStatus = zeros(1,N)+1; %1 = susceptible, 2 = infected, 3 = recovered
personStatus(1) = 2;
daysInfected = zeros(1,N); %keeps track of infected days before recovery
dt = 1; %1/2 day
tmax = 60; %one month in days
a = 5/21; %infectivity
b = 1/21; %recovery rate in days
r = a/b; %reproduction number
S = 0; %number susceptible
I = 0; %number infected
R = 0; %number recovered
infectProb = a*dt; %rate at which an infect person infects others
clockmax = ceil(tmax/dt);
xs = 300;
infectDist = 20; %radius of infection

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

%initial plot set-up
plot(tsave(1),Ssave(1),'-bo',tsave(1),Isave(1),'-ro',...
    tsave(1),Rsave(1),'-go',tsave(1),Nsave(1),'-ko',...
    'markers',3);
axis([0,tmax,0,1.2*(Nsave(1))])
axis manual

for clock = 0:clockmax
    t = clock*dt;
    %moves each person a random amount in a random direction
    personX = personX+sqrt(D*dt)*randn(1,N);
    personY = personY+sqrt(D*dt)*randn(1,N);
    %find those who have moved out of space, reflect them back in
    personX(find(personX<0)) = -personX(find(personX<0));
    personX(find(personX>space)) = 2*space - personX(find(personX>space));
    
    personY(find(personY<0)) = -personY(find(personY<0));
    personY(find(personY>space)) = 2*space - personY(find(personY>space));
        

    
    %check if individuals are close to each other
    for ii = find(personStatus == 2)
        radius = sqrt((personX-personX(ii)).^2+(personY-personY(ii)).^2);
        jj = find((radius<infectDist)&(personStatus == 1));
        personStatus(jj) = personStatus(jj)+(rand(1,length(jj))<infectProb);
    end
  
    %add to number of infected days
    for w = 1:N
        if (personStatus(w) == 2)
            daysInfected(w) = daysInfected(w)+ dt;
        end
    end
    
    %check if anyone has recovered
    for v = 1:N
        if (daysInfected(v) >= 1/b)
            personStatus(v) = 3;
        end
    end
    %counter to keep track of how many people of each type there are
    S = sum(personStatus == 1);
    I = sum(personStatus == 2);
    R = sum(personStatus == 3);
    
    tsave(clock+1) = t;
    Ssave(clock+1) = S;
    Isave(clock+1) = I;
    Rsave(clock+1) = R;
    Nsave(clock+1) = N;
end

for i=2:clockmax+1
    hold on
    plot(tsave(i),Ssave(i),'-bo',tsave(i),Isave(i),'-ro',...
        tsave(i),Rsave(i),'-go',tsave(i),Nsave(i),'-ko',...
        'markers',3);
    title("Random Model: Swine Flu")
    pause(0.05)
end
hold off
