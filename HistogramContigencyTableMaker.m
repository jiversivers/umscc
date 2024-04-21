% Histogram stats prep for JMP
% First, find all the histogram data
IMProc = FolderFinder('orr_pimo_hif_RegionalAnalysis.tiff');
pp = pathpieces(IMProc);
cat1 = unique(pp(:, 4));
cat2 = unique(pp(:, 5));
cat3 = unique(pp(:, 6));

%%
contigencyDataForJMP = {'Cellline', 'Treatment', 'Timepoint', 'Group', 'Bin#', 'ORR Bin Center', 'ORR Counts', 'Pimo Bin Centers', 'Pimo Counts', 'HIF Bin Centers', 'HIF Counts'};


%%
pm = 0.020843;
hm = 0.000927;
groups = {[0 1], [0 1], 'All';
          [0 1], [0 hm], 'Low HIF';
          [0 pm], [0 hm], 'Low Pimo, Low HIF';
          [0 pm], [hm 1], 'Low Pimo, High HIF';
          [0 pm], [0 1], 'Low Pimo';
          [pm 1], [0 1], 'High Pimo';
          [pm 1], [hm 1], 'High Pimo, High HIF';
          [pm 1], [0 hm], 'High Pimo, Low HIF';
          [0 1], [hm 1], 'High HIF'};
for ii = 1:numel(cat1)
    sub1 = [pwd filesep cat1{ii}];
    for jj = 1:numel(cat2)
        sub2 = [sub1 filesep cat2{jj}];
        for kk = 1:numel(cat3)
            if (strcmp(cat2{jj}, 'NT') && ~strcmp(cat3{kk}, '0hpt-Baseline')) || strcmp(cat3{kk}, '1hpt')
                continue
            end
            sub3 = [sub2 filesep cat3{kk}];
            ims = cellfun(@(x) squeeze(tiffreadVolume([x filesep 'orr_pimo_hif_RegionalAnalysis.tiff'])), IMProc(strcmp(pp(:,4), cat1{ii}) & strcmp(pp(:,5), cat2{jj}) & strcmp(pp(:,6), cat3{kk})), 'UniformOutput', false);
            if isempty(ims)
                continue
            end

            ims = cellfun(@(x) reshape(x, prod(size(x, [1 2])), []), ims, 'UniformOutput', false);
            ims = vertcat(ims{:});
            bad = any(isnan(ims), 2) | all(ims==0, 2);
            orr = ims(~bad,1);
            pim = ims(~bad,2);
            hif = ims(~bad,3);

            for ll = 1:size(groups, 1)
                % Prep bins for each
                nbins = 25;
                orrLim = [0 1];
                [pimLim, hifLim, regionName] = groups{ll,:};
                inLims = @(x, y) x>=y(1) & x<=y(2);
                allLim = inLims(orr, orrLim) & inLims(pim, pimLim) & inLims(hif, hifLim);
    
                x = linspace(0, 1, nbins+1);

                fprintf('\nPrcessing %s for %s %s %s...', regionName, cat1{ii}, cat2{jj}, cat3{kk})
    
                % Counts
                [NO, edges] = histcounts(orr(allLim), x);
                NO = 100*NO'/sum(allLim);
                ctrsORR = (edges(2:end)-((edges(2:end)-edges(1:end-1))/2))';
    
                [NP, edges] = histcounts(pim(allLim), x);
                NP = 100*NP'/sum(allLim);
                ctrsPim = (edges(2:end)-((edges(2:end)-edges(1:end-1))/2))';
    
                [NH, edges] = histcounts(hif(allLim), x);
                NH = 100*NH'/sum(allLim);
                ctrsHIF = (edges(2:end)-((edges(2:end)-edges(1:end-1))/2))';
                
                contigencyDataForJMP(end+1:end+25, :) = [repmat([cat1(ii), cat2(jj), cat3(kk)], 25, 1), repmat({horzcat(cat1{ii}, cat2{jj}, cat3{kk}, ' ', regionName)}, 25, 1), ... 
                    num2cell(1:25)', num2cell(ctrsORR), num2cell(NO), num2cell(ctrsPim), num2cell(NP), num2cell(ctrsHIF), num2cell(NH)];
            end
        end
    end
end

writecell(contigencyDataForJMP, sprintf('grouped_wholesection_contingencyDataForJMP.xlsx', orrLim, 100*pimLim, 100*hifLim));