% Script to Retrieve Historical Stock Data from Google Finance
function [date_str,data] = get_stock_data(PERIOD,DAYS,TICKER)
% 
% PERIOD =900;
% DAYS=1;
% TICKER='AAPL';
% format long

url_string = 'http://www.google.com/finance/getprices?';
url_string = strcat(url_string,'q=',upper(TICKER));
url_string = strcat(url_string,'&i=',num2str(PERIOD));
url_string = strcat(url_string,'&p=',num2str(DAYS));
url_string = strcat(url_string,'d&f=d,c,h,l,o,v');
%HighPrices, LowPrices, ClosePrices, OpenPrices volume

% Open a connection to the URL and retrieve data into a buffer
buffer      = java.io.BufferedReader(...
              java.io.InputStreamReader(...
              openStream(...
              java.net.URL(url_string))));


% Read all remaining lines in buffer
ptr = 1;
itr=1;

 idx_max=round(((6.5*60*60)/PERIOD)*DAYS);
 data=zeros(idx_max,5);



while 1
    % Read line
    buff_line = char(readLine(buffer));
    

    if itr<8 
    itr=itr+1;
    continue
        
    elseif strcmp(buff_line,'')==1
    break;
    end
    
    
    C = strsplit(buff_line,',');
    C2=C(1,2:end);
    
    if strcmp(C{1,1}(1),'a')==1
       first_day = str2double(C{1,1}(2:end));
       date_str(ptr,:) = datenum(epoch2date(first_day));
       temp=cellfun(@str2num,C2);
       data(ptr,:)=[temp(2) temp(3) temp(1) temp(4) temp(5)];
       
    else
       temp = cellfun(@str2num,C2);
       
       try
       data(ptr,:)=[temp(2) temp(3) temp(1) temp(4) temp(5)];
       catch
       end
       
       offset = str2double(C{1,1});
       date_str(ptr,:) = datenum(epoch2date(first_day + str2double(C{1,1})*PERIOD));
    end
    

    ptr = ptr + 1;
    itr=itr+1;
end

data( ~any(data,2), : ) = [];%remove extra zeros
end


function [date_str] = epoch2date(epochTime)
% converts epoch time to human readable date string
% import java classes
import java.lang.System;
import java.text.SimpleDateFormat;
import java.util.Date;
% convert current system time if no input arguments
if (~exist('epochTime','var'))
    epochTime = System.currentTimeMillis/1000;
end
% convert epoch time (Date requires milliseconds)
jdate = Date(epochTime*1000);
% format text and convert to cell array
%sdf = SimpleDateFormat('dd/MM/yyyy HH:mm:ss.SS');
sdf = SimpleDateFormat('MM/dd/yyyy HH:mm:ss');
date_str = sdf.format(jdate);
date_str = char(cell(date_str));

end
