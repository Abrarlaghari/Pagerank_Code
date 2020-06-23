% Author: Tim Chartier
% Title:  linearLS.m

%% Data

% Taken from: http://trackandfield.about.com/od/sprintsandrelays/qt/olym100women.htm
% 1928	12.2	Elizabeth Robinson, United States
% 1932	11.9	Stella Walsh, Poland
% 1936	11.5	Helen Stephens, United States
% 1948	12.2	Fanny Blankers-Koen, Netherlands
% 1952	11.67	Marjorie Jackson, Australia
% 1956	11.82	Betty Cuthbert, Australia
% 1960	11.18	Wilma Rudolph, United States
% 1964	11.49	Wyomia Tyus, United States
% 1968	11.08	Wyomia Tyus, United States
% 1972	11.07	Renate Stecher, East Germany
% 1976	11.08	Annegret Richter, West Germany
% 1980	11.06	Lyudmila Kondratyeva, USSR
% 1984	10.97	Evelyn Ashford, United States
% 1988	10.54	Florence Griffith-Joyner, United States
% 1992	10.82	Gail Devers, United States
% 1996	10.94	Gail Devers, United States
% 2004	10.93	Yuliya Nesterenko, Belarus
% 2008	10.78	Shelly-ann Fraser, Jamaica
% 2012	10.75	Shelly-ann Fraser, Jamaica

%% Create the Olympic data as a matrix

olympicData = [1928	12.2
1932	11.9
1936	11.5
1948	12.2
1952	11.67
1956	11.82
1960	11.18
1964	11.49
1968	11.08
1972	11.07
1976	11.08
1980	11.06
1984	10.97
1988	10.54
1992	10.82
1996	10.94
2004	10.93
2008	10.78
2012	10.75];

%% Prepare for the linear least square solve 

years = olympicData(:,1);  % vector of years of Olympic data
times = olympicData(:,2);  % vector of times of Olympic data

numberOfTimes = length(years); 
leastSquareData = ones(numberOfTimes,2); % create a matrix of ones

leastSquareData(:,1) = years; % replace the first column with the years

%% Perform least-squares solve

linearCoefs = leastSquareData \ times;

%% Plot the data and LS line

plot(olympicData(:,1),olympicData(:,2),'oy',...
                     'MarkerSize',10, ...
                     'MarkerFaceColor',[255/255,215/255,0],...
                     'MarkerEdgeColor','k')
                 
hold on

x = linspace(1920, 2020, 500); 
y = linearCoefs(1).*x + linearCoefs(2);

plot(x,y,'-k','LineWidth',2); 




