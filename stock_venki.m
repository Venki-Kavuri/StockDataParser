clear 
clc
close all
%% 
PERIOD =2400;
DAYS=10;
Stocks={'TSLA','NVDA','AAPL','MASI','HPQ'};

%Stocks={'NVDA'};

%%
for i= 1:length(Stocks)
[date_str,s.(Stocks{i})] = get_stock_data(PERIOD,DAYS,Stocks{i});

figure
subplot(2,2,1)
candle(s.(Stocks{i})(:,1),s.(Stocks{i})(:,2),s.(Stocks{i})(:,3),s.(Stocks{i})(:,4));
tick_index = 1:15:length(date_str); % checks length of the dates with 10 steps in b200tween.
tick_label = datestr(date_str(tick_index), 'mm/dd ddd HH:MM AM'); % this is translated to a datestring.
%Now we tell the x axis to use the parameters set before.
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
ch = get(gca,'children');
set(ch(1),'FaceColor','r')
set(ch(2),'FaceColor','g')
axis tight
set(gca,'XTickLabelRotation',45);
hL=get(gca,'XLabel');
set(hL,'Interpreter','latex')
grid on;


l=length(s.(Stocks{i})(:,3));
P=s.(Stocks{i})(:,3);
V=s.(Stocks{i})(:,5);
date_str_temp= datenum(datestr(date_str, 'mm/dd')); % strip time information with-in each day
[dateX,ia,~] = unique(date_str_temp,'legacy'); % pick up lowest price in each day
for j=1:length(dateX)
[r]=find(date_str_temp==dateX(j));
[PriceX(j,1),idx]=min(P(r));
P_idx(j,1)=r(idx);

V_day(j,1)=sum(V(r));
end
[~,I]=sort(PriceX);
P_idx=P_idx(I);

for j=1:length(P_idx)
line([(P_idx(j)) (P_idx(j))],[min(P) max(P)],'LineWidth',3);
end



% C=P;
% dP=[0;diff(P)];%2 day price difference
% pP=dP./P;%percent change
% spP=sign(pP);%signum of day to day % change
% n=find(spP==0);%%find no change days
% spP(n)=sign(rand-.5);%%add small noise to no change days
% spP=(spP+1)/2;%%convert to binary 0=down 1=up
% %%%%filter out flat dayswith changes less than .5%
% %%small noises and spikes are non-profitable neglected
% for j=2:l-1
%     if abs(pP(j))<.005
%         spP(j)=spP(j-1);%same as prior day
%     end
% end
% %%%%%%%%Mark signal change%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%find buy  signal%%
% n=find(spP(2:end)==1);%shift back by one day 
% buy=n;
% %%%%%%%%find sell signal%%
% n=find(spP(2:end)==0);%shift back by one day 
% sell=n;
% %%%%%%%%tradesignal
% changemarker=xor(spP(1:end-1),spP(2:end));%finds changing signals
% %%%%%%%%tradesignal
% tradesignal=zeros(length(C),1);
% tradesignal(buy)=1;
% 
% %set(gcf,'Color',[0,0,0])
% set(gca,'fontsize',14);
% title((Stocks{i}))



h=subplot(2,2,2);
bar(s.(Stocks{i})(:,5))
axis tight
tick_index = 1:15:length(date_str); % checks length of the dates with 15 steps in between.
tick_label = datestr(date_str(tick_index), 'mm/dd ddd HH:MM AM'); % this is translated to a datestring.
%Now we tell the x axis to use the parameters set before.
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
set(gca,'XTickLabelRotation',45);
set(gca,'fontsize',14);
grid on;



subplot(2,2,3)
dfx=diff(s.(Stocks{i})(:,1));
plot(dfx);

tick_index = 1:15:length(date_str); % checks length of the dates with 10 steps in between.
tick_label = datestr(date_str(tick_index), 'mm/dd ddd HH:MM AM'); % this is translated to a datestring.
%Now we tell the x axis to use the parameters set before.
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
ch = get(gca,'children');
axis tight
set(gca,'XTickLabelRotation',45);
hL=get(gca,'XLabel');
set(hL,'Interpreter','latex')
grid on;
set(gca,'fontsize',14);
title('Time derivative')




end
%% 



