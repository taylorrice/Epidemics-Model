N = 50; %population size
space = 200; %variable that determines how large of a space the population has to move around in
D = space^2/10; %diffusion constant
personX = rand(1,N)*space;
personY = rand(1,N)*space;
personStatus = zeros(1,N)+1; %1 = susceptible, 2 = infected, 3 = recovered
personStatus(1) = 2;
daysInfected = zeros(1,N); %keeps track of infected days before recovery
dt = 0.01; %1/2 day
tmax = 30; %one month in days
a = 1/4.5; %infectivity
b = 1/7; %recovery rate in days
r = a/b; %reproduction number
S = 0; %number susceptible
I = 0; %number infected
R = 0; %number recovered
infectProb = a*dt; %rate at which an infect person infects others
clockmax = ceil(tmax/dt);
xs = 300;
infectDist = 20; %radius of infection

%initial plot set-up
hS = plot(personX(find(personStatus == 1)),personY(find(personStatus == 1)),'bo');
hold on
hI = plot(personX(find(personStatus == 2)),personY(find(personStatus == 2)),'r*');
hold on
hR = plot(0,0, 'go');
axis equal
axis([0, space, 0, space])
axis manual
axis on
hold off

for clock = 0:clockmax
    S = 0;I = 0;R = 0;
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
    xS = personX(find(personStatus == 1));
    xI = personX(find(personStatus == 2));
    xR = personX(find(personStatus == 3));
    yS = personY(find(personStatus == 1));
    yI = personY(find(personStatus == 2));
    yR = personY(find(personStatus == 3));

    %plots new coordinates
    set(hS,'xdata',xS,'ydata',yS)
    set(hI,'xdata',xI,'ydata',yI)
    set(hR,'xdata',xR,'ydata',yR)

    days = sprintf('%.2f days', clock*dt);
    counts = sprintf('%d infected, %d susceptible, %d recovered', I, S, R);
    axis equal
    axis([0,space,0, space])
    axis manual
    axis on
    hold off
    title({days;counts})
    drawnow
    pause(0.1)
end
