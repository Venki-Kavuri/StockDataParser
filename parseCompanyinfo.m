function [ CompanyInfo ] = parseCompanyinfo(CompanyInfo_all,TICKER)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

idx=not(cellfun('isempty',strfind(CompanyInfo_all,TICKER)));
CompanyName=CompanyInfo_all(idx);

CompanyInfo = strsplit(CompanyName{1},',');

end