open('my3d_Redox_v_3x3MedFilt_PhotonThresh15_Lifetime_Histogram.fig');
fig = gcf;
set(fig, 'WindowState', 'maximize')
ax = gca;
ax.Colorbar.Visible = 'off';
view(-37.5, 30)
ax.CameraViewAngle = 7.5;
ax.PlotBoxAspectRatio = [4 3 1];

ax.XLabel.Position = [ax.XLim(1)+0.5*diff(ax.XLim) ax.YLim(1)-0.1*ax.PlotBoxAspectRatio(1)/ax.PlotBoxAspectRatio(2)*diff(ax.YLim) 0];
ax.YLabel.Position = [ax.XLim(1)-0.1*ax.PlotBoxAspectRatio(2)/ax.PlotBoxAspectRatio(1)*diff(ax.XLim) ax.YLim(1)+0.5*diff(ax.YLim) 0];
xl = text(ax.XLim(1)+0.5*diff(ax.XLim), ax.YLim(2)+0.1*ax.PlotBoxAspectRatio(1)/ax.PlotBoxAspectRatio(2)*diff(ax.YLim), 0, ax.XLabel.String, 'FontSize', ax.XLabel.FontSize);
yl = text(ax.XLim(2)+0.1*ax.PlotBoxAspectRatio(2)/ax.PlotBoxAspectRatio(1)*diff(ax.XLim), ax.YLim(1)+0.5*diff(ax.YLim), 0, ax.YLabel.String, 'FontSize', ax.XLabel.FontSize);

exportgraphics(ax, 'Phasor_ORR_3D_capture_w-out_cbar.png', 'Resolution', 300)
vidObj = VideoWriter('phasor_ORR_3dHistVideo.mp4', 'MPEG-4');
open(vidObj)

im = frame2im(getframe(fig));
[im, map] = rgb2ind(im, 256);
imwrite(im, map, 'phasor_ORR_3dHistAnimation.gif', "gif", "LoopCount", Inf, "DelayTime", 1);
for jj = 0:359
    view(jj-37.5, 30);
    drawnow;
    frame = getframe(fig);        
    if jj && ~mod(jj, 2)
        im = frame2im(frame);
        [im, map] = rgb2ind(im, 256);
        imwrite(im, map, 'phasor_ORR_3dHistAnimation.gif', "gif", "WriteMode", "append", "DelayTime", 1/30);
    end
    writeVideo(vidObj, frame);
end
close(vidObj)
close(gcf)

%%
open('spc3d_Redox_v_Fit__Lifetime_Histogram.fig')
set(gcf, 'WindowState', 'maximize', 'Position', [1 41 1600 783])
ax = gca;
ax.PlotBoxAspectRatio = [2 2 1];
ax.Colorbar.Visible = 'off';
view(-37.5, 15)
ax.CameraViewAngle = 7.5;

ax.XLabel.Position = [ax.XLim(1)+0.5*diff(ax.XLim) ax.YLim(1)-0.1*ax.PlotBoxAspectRatio(1)/ax.PlotBoxAspectRatio(2)*diff(ax.YLim) 0];
ax.YLabel.Position = [ax.XLim(1)-0.1*ax.PlotBoxAspectRatio(2)/ax.PlotBoxAspectRatio(1)*diff(ax.XLim) ax.YLim(1)+0.5*diff(ax.YLim) 0];
xl = text(ax.XLim(1)+0.5*diff(ax.XLim), ax.YLim(2)+0.1*ax.PlotBoxAspectRatio(1)/ax.PlotBoxAspectRatio(2)*diff(ax.YLim), 0, ax.XLabel.String, 'FontSize', ax.XLabel.FontSize);
yl = text(ax.XLim(2)+0.1*ax.PlotBoxAspectRatio(2)/ax.PlotBoxAspectRatio(1)*diff(ax.XLim), ax.YLim(1)+0.5*diff(ax.YLim), 0, ax.YLabel.String, 'FontSize', ax.XLabel.FontSize);

vidObj = VideoWriter('fit_ORR_3dHistVideo.mp4', 'MPEG-4');
open(vidObj)
for ii = 0:359
view(ii-37.5, 15);
drawnow;
writeVideo(vidObj, getframe(gcf));
end
close(vidObj)
close(gcf)