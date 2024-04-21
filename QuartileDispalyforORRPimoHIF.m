% Histogram stats prep for JMP
% First, find all the histogram data
IMProc = FolderFinder('orr_pimo_hif_RegionalAnalysis.tiff');

%%
crit = {'NT\0hpt-Baseline', 'XT\24hpt', 'XT\48hpt'};
ims = cellfun(@(x) squeeze(tiffreadVolume([x filesep 'orr_pimo_hif_RegionalAnalysis.tiff'])), IMProc(strcmp(pp(:,5), cat2{jj}) & strcmp(pp(:,6), cat3{kk})), 'UniformOutput', false);

ims = cellfun(@(x) reshape(x, prod(size(x, [1 2])), []), ims, 'UniformOutput', false);
ims = vertcat(ims{:});
bad = any(isnan(ims), 2) | all(ims==0, 2);
orr = ims(~bad,1);
pim = ims(~bad,2);
hif = ims(~bad,3);

orr = sort(orr);
pim = sort(pim);
hif = sort(hif);

fprintf('\nORR 25th%%ile = %2.4f\n', orr(round(0.25*numel(orr))));
fprintf('>>> 50th%%ile = %2.4f\n', orr(round(0.50*numel(orr))));
fprintf('>>> 75th%%ile = %2.4f\n', orr(round(0.75*numel(orr))));

fprintf('\nPimo 25th%%ile = %2.4f\n', 100*pim(round(0.25*numel(pim))));
fprintf('>>>> 50th%%ile = %2.4f\n', 100*pim(round(0.50*numel(pim))));
fprintf('>>>> 75th%%ile = %2.4f\n', 100*pim(round(0.75*numel(pim))));

fprintf('\nHIF1a 25th%%ile = %2.4f\n', 100*hif(round(0.25*numel(hif))));
fprintf('>>>>> 50th%%ile = %2.4f\n', 100*hif(round(0.50*numel(hif))));
fprintf('>>>>> 75th%%ile = %2.4f\n', 100*hif(round(0.75*numel(hif))));