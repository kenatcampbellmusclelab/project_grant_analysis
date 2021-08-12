function grant_analysis

fs = '../data/grant_spreadsheet.xlsx';

% Code
[~,year_sheets] = xlsfinfo(fs);

year_sheets = sort_nat(year_sheets);

for y = 1 : numel(year_sheets)
    
    t = readtable(fs, 'Sheet', year_sheets{y});
    
    vn = t.Properties.VariableNames;
    % Restrict table to application rows
    vi = find(~cellfun(@isempty, t.Agency));
    t = t(vi,:);
    
    % Find status
    fi = find(strcmp(t.Status, 'Funded'));
    
    budget_to_Campbell = t.AvailableToCampbell(fi);
    try
        budget_to_Campbell = str2num(budget_to_Campbell);
    end
    
    btc = budget_to_Campbell;

    
    % Store
    out.grants_submitted(y) = size(t,1);
    out.grants_funded(y) = numel(fi);
    out.success_rate(y) = out.grants_funded(y) / out.grants_submitted(y);
    out.budget_to_Campbell(y) = sum(budget_to_Campbell);
    out.year(y) = str2num(year_sheets{y});
end
% 
% out = out
% 
out = struct2table(columnize_structure(out));
out.cum_budget_to_Campbell = cumsum(out.budget_to_Campbell)

% Average success
success_rate = sum(out.grants_funded) / sum(out.grants_submitted)

a = sum(out.grants_funded)
b = sum(out.grants_submitted)



figure(1);
clf;
s = stackedplot(out, 'XVariable', 'year','Marker','o','FontSize',10);

