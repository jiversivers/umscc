toDos = FolderFinder('ORR_SHG_G_S_Ph_Tm_A2Percent_X2.mat');
for ii = 1:numel(toDos)
    % Load vars
    load([toDos{ii} filesep 'ORR_SHG_G_S_Ph_Tm_A2Percent_X2.mat'])
    
    close all
    fig = figure;
    ax = axes(fig);
    cmap = colormap('gray').*colormap('jet');
    
    % Reshape back into image chain
    Tm = reshape(Tm, 512, []);
    A2Percent = reshape(A2Percent, 512, []);
    X2 = reshape(X2, 512, []);
    ORR = reshape(ORR, 512, []);
    
    % Thresh out bad fits
    chiLim = [0.7 1.4];
    wInChiLims = @(x) x>=chiLim(1) & x<=chiLim(2);
    Tm(~wInChiLims(X2)) = NaN;
    A2Percent(~wInChiLims(X2)) = NaN;
    
    % Set vars for histograms
    Var1 = Tm;
    Var2 =  A2Percent;
    colorBasis = ORR;
    
    % Threshold by fit quality
    colorBasis(~wInChiLims(X2)) = NaN;
    
    % Create bins (1 bin for every 10 ps and 1 bin 1%)
    ctrs{1} = 0:10:max(Tm, [], 'all');
    ctrs{2} = 0:1:100;
    
    % Set limits for final plots
    lims = [1000 2200 15 30];
    
    % Bivariate histogram
    N = hist3([Var1(:), Var2(:)], 'Ctrs', ctrs);
    N = 100*(N'/numel(Var1));
    N = N(ctrs{2}>lims(3) & ctrs{2}<lims(4), ctrs{1}>lims(1) & ctrs{1}<lims(2));
    limtdbins{1} = linspace(lims(1), lims(2), sum(ctrs{1}>lims(1) & ctrs{1}<lims(2)));
    limtdbins{2} = linspace(lims(3), lims(4), sum(ctrs{2}>lims(3) & ctrs{2}<lims(4)));
    surf(ax, limtdbins{:}, N);
    view(2)
    shading interp
    ax.XLabel.String = '\tau_M (ps)';
    ax.YLabel.String = '\alpha_2%';
    ax.PlotBoxAspectRatio = [2 1 1];
    colormap(cmap)
    clim([0 0.25])
    exportgraphics(ax, [toDos{ii} filesep 'spc2d_TmvA2Percent_Histogram_withLimits_noCBar.png'], 'Resolution', 300)
    cbar = colorbar;
    cbar.Label.String = '% of Total Pixels';
    savefig(fig, [toDos{ii} filesep 'spc2d_TmvA2Percent_Histogram_withLimits.fig'])
    exportgraphics(ax, [toDos{ii} filesep 'spc2d_TmvA2Percent_Histogram_withLimits.png'], 'Resolution', 300)
    
    % Tri-variate histogram
    C = HistogramColorCalculator(Var1, Var2, colorBasis, limtdbins);
    surf(ax, limtdbins{:}, N, C)
    shading interp
    view(3)
    ax.XLabel.String = '\tau_M (ps)';
    ax.YLabel.String = '\alpha_2%';
    ax.ZLabel.String = '% of Total Pixels';
    ax.XLim = lims(1:2);
    ax.YLim = lims(3:4);
    ax.ZLim = [0 .25];
    ax.XTick = lims(1):200:lims(2);
    ax.YTick = lims(3):5:lims(4);
    ax.ZTick = 0:0.1:0.25;
    ax.PlotBoxAspectRatio = [8 4 3];
    ax.XLabel.Position = [ax.XLim(1)+0.5*diff(ax.XLim) ax.YLim(1)-0.1*ax.PlotBoxAspectRatio(1)/ax.PlotBoxAspectRatio(2)*diff(ax.YLim) 0];
    ax.YLabel.Position = [ax.XLim(1)-0.1*ax.PlotBoxAspectRatio(2)/ax.PlotBoxAspectRatio(1)*diff(ax.XLim) ax.YLim(1)+0.5*diff(ax.YLim) 0];
    xl = text(ax.XLim(1)+0.5*diff(ax.XLim), ax.YLim(2)+0.1*ax.PlotBoxAspectRatio(1)/ax.PlotBoxAspectRatio(2)*diff(ax.YLim), 0, ax.XLabel.String, 'FontSize', ax.XLabel.FontSize);
    yl = text(ax.XLim(2)+0.1*ax.PlotBoxAspectRatio(2)/ax.PlotBoxAspectRatio(1)*diff(ax.XLim), ax.YLim(1)+0.5*diff(ax.YLim), 0, ax.YLabel.String, 'FontSize', ax.XLabel.FontSize);
    colormap(cmap);
    clim([0 0.8])
    exportgraphics(ax, [toDos{ii} filesep 'spc3d_Redox_v_Fit__Lifetime_Histogram_withLimits_noCBar.png'], 'Resolution', 300)
    cbar = colorbar;
    cbar.Label.String = 'Mean ORR';
    exportgraphics(ax, [toDos{ii} filesep 'spc3d_Redox_v_Fit__Lifetime_Histogram_withLimits.png'], 'Resolution', 300)
    savefig(gcf, [toDos{ii} filesep 'spc3d_Redox_v_Fit__Lifetime_Histogram_withLimits.fig']);
    
    % Make rotation video
    set(gcf, 'WindowState', 'maximized', 'Position', [1 41 1600 783])
    vidObj = VideoWriter([toDos{ii} filesep 'fit_ORR_3dHistVideo_withLimits.mp4'], 'MPEG-4');
    open(vidObj)
    cbar.Visible = 'off';
    ax.CameraViewAngle = 9;
    
    delete([toDos{ii} filesep 'fit_ORR_3dHistAnimation_withLimits.gif'])
    im = frame2im(getframe(fig));
    [im, map] = rgb2ind(im, 256);
    imwrite(im, map, [toDos{ii} filesep 'fit_ORR_3dHistAnimation_withLimits.gif'], "gif", "LoopCount", Inf, "DelayTime", 1);
    for jj = 0:359
        view(jj-37.5, 30);
        drawnow;
        frame = getframe(fig);        
        if jj && ~mod(jj, 2)
            im = frame2im(frame);
            [im, map] = rgb2ind(im, 256);
            imwrite(im, map, [toDos{ii} filesep 'fit_ORR_3dHistAnimation_withLimits.gif'], "gif", "WriteMode", "append", "DelayTime", 1/30);
        end
        writeVideo(vidObj, frame);
    end
    close(vidObj)

end
