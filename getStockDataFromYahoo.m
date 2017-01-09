function [DateStr, StockData ] = getStockDataFromYahoo( TICK,days,mins )
tic 
url=['http://chartapi.finance.yahoo.com/instrument/1.0/' urlencode(TICK) '/chartdata;type=quote;range=' num2str(days) 'd/csv'];


data = webread(url);
toc
data=strsplit(data,'\n');
tic
idx=find(cellfun('isempty',strfind(data,'vol'))==0);
data(1:idx(2))=[];

data(end)=[];
DateStr = zeros(length(data),1);
StockData = zeros(length(data),4);

data=(cellfun(@(x) strsplit(x,','),data , 'UniformOutput', false))';

data2=cellfun(@(x) x{:},data , 'UniformOutput', false);



for i=1:length(data)
    datainst=strsplit(data{i},',');
    DateStr(i,1)= unixtime_in_ms_to_datenum(str2num(datainst{1,1}));
    for j=1:5
        StockData(i,j)=[str2num(datainst{1,j+1})]  ;
    end
end

DateStr = DateStr(1:mins:end);
StockData= StockData(1:mins:end,:);
toc
end


function dn = unixtime_in_ms_to_datenum( unix_time_ms )
   dn= datenum(datetime(unix_time_ms,'ConvertFrom','posixtime','TimeZone','America/Los_Angeles'));
end

 

