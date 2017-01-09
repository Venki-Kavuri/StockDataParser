clear 
clc
close all
%%
delete([pwd '/*.pdf']);
delete([pwd '/*.png']);
delete([pwd '/Results/*.pdf'])
PERIOD =60;
DAYS=90;
Stocks=importdata('NASDAQT.txt');
CompanyInfo_all=importdata('companylist.csv');

[~,NXDT] = getStockDataFromYahoo('^NDXT',DAYS,PERIOD);
NXDTavg=(NXDT(:,1)+NXDT(:,2))./2;%average NXDT
PerChgNXDT=100.*(NXDTavg-NXDTavg(1))./NXDTavg(1);
%%
k=1;m=1;
%%
for i= 1:1%length(Stocks)
%[date_str,s.(Stocks{i})] = get_stock_data(PERIOD,DAYS,Stocks{i});

[date_str, s.(Stocks{i}) ] = getStockDataFromYahoo(Stocks{i},DAYS,PERIOD); %close,high,low,open

[ CompanyInfo ] = parseCompanyinfo(CompanyInfo_all,Stocks{i});

h1=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(3,1,1)
candle(s.(Stocks{i})(:,2),s.(Stocks{i})(:,3),s.(Stocks{i})(:,1),s.(Stocks{i})(:,4));

tick_index = 1:1:length(date_str); % checks length of the dates with 10 steps inbetween.
tick_label = datestr(date_str(tick_index), 'mm/dd ddd HH:MM AM'); % this is translated to a datestring.
%Now we tell the x axis to use the parameters set before.

ch = get(gca,'children');
set(ch(1),'FaceColor','r')
set(ch(2),'FaceColor','g')
axis tight
% set(gca,'XTick',tick_index); 
% set(gca,'XTickLabel',tick_label);
% set(gca,'XTickLabelRotation',45);
% hL=get(gca,'XLabel');
% set(hL,'Interpreter','latex')
set(gca,'xticklabel',{[]}) 
set(gca,'fontsize',14);
title([Stocks{i} ' "' CompanyInfo{2} '" "' CompanyInfo{6} '" "' CompanyInfo{7} '"']);
ylabel('USD($)');
grid on;


h=subplot(3,1,2);
bar(s.(Stocks{i})(:,5)./10^6);
axis tight
tick_index = 1:1:length(date_str); % checks length of the dates with 15 steps in between.
tick_label = datestr(date_str(tick_index), 'mm/dd ddd HH:MM AM'); % this is translated to a datestring.
%Now we tell the x axis to use the parameters set before.
% set(gca,'XTick',tick_index); 
% set(gca,'XTickLabel',tick_label);
% set(gca,'XTickLabelRotation',45);
set(gca,'xticklabel',{[]}) 
set(gca,'fontsize',14);
legend('Volume');
ylabel('Volume[millions]');
grid on;


%%
subplot(3,1,3)
AvgCurrentStock=(s.(Stocks{i})(:,1)+s.(Stocks{i})(:,2))./2;
PerChgCurStock=100.*(AvgCurrentStock-AvgCurrentStock(1))./AvgCurrentStock(1);
% dfx=diff(s.(Stocks{i})(:,1)); %time derivative
plot(PerChgNXDT,'--','linewidth',2);
hold on
plot(PerChgCurStock,'linewidth',2);
legend('NXDT', Stocks{i});


tick_index = 1:1:length(date_str); % checks length of the dates with 10 steps in between.
tick_label = datestr(date_str(tick_index), 'mm/dd ddd HH:MM AM'); % this is translated to a datestring.
%Now we tell the x axis to use the parameters set before.
set(gca,'XTick',tick_index); 
set(gca,'XTickLabel',tick_label);
ch = get(gca,'children');
axis tight
set(gca,'XTickLabelRotation',30);
hL=get(gca,'XLabel');
set(hL,'Interpreter','latex')
grid on;
set(gca,'fontsize',14);
title('Comparision with NXDT')
tightfig(h1);
ylabel('Percent(%)');

print(h1,Stocks{i},'-dpdf');

if mean(PerChgCurStock(end-5:end))>= mean(PerChgNXDT(end-5:end))
    input_list1{m}=[Stocks{i} '.pdf'];
    close(h1);
    m=m+1;
else
    input_list2{k}=[Stocks{i} '.pdf'];
    close(h1);
    k=k+1;
end

end
append_pdfs([pwd '/Results/Result_high_perf.pdf'], input_list1{:});
append_pdfs([pwd '/Results/Result_low_perf.pdf'], input_list2{:});
delete([pwd '/*.pdf'])
%% 



