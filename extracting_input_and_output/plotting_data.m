segments = interictal_segment_1.data(:,1:239760);

f = figure(1)
for i = 1:16
    t = linspace(1,10, 239760);
    y = segments(i,:);

    subplot(16,1,i);
    %ts1 = timeseries(y);
    %ts1.TimeInfo.Units = 'minutes';
    %ts1.TimeInfo.Increment= 10 / 239760;
    
    plot(t, y);
    xticklabel = get(gca,'XTickLabel');
    set(gca, 'XTickLabel', [])
end
set(gca,'XTickLabel',xticklabel);
xlabel('Minutes');
saveas(f, 'abc.png','png');