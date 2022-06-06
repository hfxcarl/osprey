function osp_updateCoregWindow(gui)
%% osp_updateCoregWindow
%   This function updates the coreg tab.
%
%   USAGE:
%       osp_updateCoregWindow(gui);
%
%   INPUT:
%           gui      = gui class containing all handles and the MRSCont
%
%   AUTHORS:
%       Dr. Helge Zoellner (Johns Hopkins University, 2020-01-16)
%       hzoelln2@jhmi.edu
%
%   CREDITS:
%       This code is based on numerous functions from the FID-A toolbox by
%       Dr. Jamie Near (McGill University)
%       https://github.com/CIC-methods/FID-A
%       Simpson et al., Magn Reson Med 77:23-33 (2017)
%
%   HISTORY:
%       2020-01-16: First version of the code.


%%% 1. INITIALIZE %%%
        MRSCont = getappdata(gui.figure,'MRSCont');  % Get MRSCont from hidden container in gui class
        gui.controls.b_save_coregTab = gui.layout.(gui.layout.coregTabhandles{gui.coreg.Selected}).Children(2).Children(1).Children;
         if (isfield(MRSCont.flags, 'isPRIAM') || isfield(MRSCont.flags, 'isMRSI')) &&  (MRSCont.flags.isPRIAM || MRSCont.flags.isMRSI)
            set(gui.layout.(gui.layout.coregTabhandles{gui.coreg.Selected}).Children(2).Children(4).Children(1).Children.Children(4),'String',gui.controls.act_z)
            set(gui.layout.(gui.layout.coregTabhandles{gui.coreg.Selected}).Children(2).Children(4).Children(1).Children.Children(5),'String',gui.controls.act_y)
            set(gui.layout.(gui.layout.coregTabhandles{gui.coreg.Selected}).Children(2).Children(4).Children(1).Children.Children(6),'String',gui.controls.act_x)
         end
        gui.layout.EmptyProPlot = 0;

%%% 2. FILLING INFO PANEL FOR THIS TAB %%%
% Some useful information from the raw data headers is read out here
StatText = ['Metabolite Data -> Sequence: ' gui.load.Names.Seq '; B0: ' num2str(MRSCont.raw{1,gui.controls.Selected}.Bo) '; TE / TR: ' num2str(MRSCont.raw{1,gui.controls.Selected}.te) ' / ' num2str(MRSCont.raw{1,gui.controls.Selected}.tr) ' ms ' '; spectral bandwidth: ' num2str(MRSCont.raw{1,gui.controls.Selected}.spectralwidth) ' Hz'...
    '\nraw subspecs: ' num2str(MRSCont.raw{1,gui.controls.Selected}.rawSubspecs) '; raw averages: ' num2str(MRSCont.raw{1,gui.controls.Selected}.rawAverages) '; averages: ' num2str(MRSCont.raw{1,gui.controls.Selected}.averages)...
    '; Sz: ' num2str(MRSCont.raw{1,gui.controls.Selected}.sz) ';  dimensions: ' num2str(MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{1})) ' x ' num2str(MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{2})) ' x ' num2str(MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{3})) ' mm = '...
    num2str(MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{1}) * MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{2}) * MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{3})/1000) ' ml'];
set(gui.upperBox.coreg.Info.Children, 'String', sprintf(StatText));

%%% 3. VISUALIZATION PART OF THIS TAB %%%
if gui.coreg.Selected == 1 %Is first structural tab?
    if MRSCont.flags.didSeg && length(gui.Results.coreg.Children) == 2 %Did seg & has been visualized already
        temp = figure( 'Visible', 'off' );
        if ~isfield(MRSCont.flags,'isPRIAM')  && ~MRSCont.flags.isPRIAM
            temp = osp_plotCoreg(MRSCont, gui.controls.Selected);
        else
            temp = osp_plotCoreg(MRSCont, gui.controls.Selected,gui.controls.act_x);
        end
        set( temp.Children.Children, 'Parent', gui.Results.coreg.Children(2));
        delete( gui.Results.coreg.Children(2).Children(2) );
        colormap(gui.Results.coreg.Children(1),'gray');
        close( temp );
        temp = figure( 'Visible', 'off' );
        if gui.controls.Selected <= length(MRSCont.seg.tissue.fGM)
            if ~isfield(MRSCont.flags,'isPRIAM')  && ~MRSCont.flags.isPRIAM
                temp = osp_plotSegment(MRSCont, gui.controls.Selected);
            else
                temp = osp_plotSegment(MRSCont, gui.controls.Selected,gui.controls.act_x);
            end
            set( temp.Children.Children, 'Parent', gui.Results.coreg.Children(1));
            delete( gui.Results.coreg.Children(1).Children(10:end));
            set(gui.Results.coreg.Children(1),'Children',flipud(gui.Results.coreg.Children(1).Children));
            colormap(gui.Results.coreg.Children(1),'gray');
            set( gui.Results.coreg.Children(2).Title, 'String', temp.Children.Title.String);
            close( temp );
            temp = figure( 'Visible', 'off' );
            if gui.controls.Selected <= length(MRSCont.seg.tissue.fGM)
                if ~isfield(MRSCont.flags,'isPRIAM')  && ~MRSCont.flags.isPRIAM
                    temp = osp_plotSegment(MRSCont, gui.controls.Selected);
                else
                    temp = osp_plotSegment(MRSCont, gui.controls.Selected,gui.controls.act_x);
                end
                set( temp.Children.Children, 'Parent', gui.Results.coreg.Children(1));
                set( gui.Results.coreg.Children(1).Title, 'String', temp.Children.Title.String);
                delete( gui.Results.coreg.Children(1).Children(10:end));
                set(gui.Results.coreg.Children(1),'Children',flipud(gui.Results.coreg.Children(1).Children));
                colormap(gui.Results.coreg.Children(1),'gray');
                close( temp );
            end
        end
    elseif MRSCont.flags.didSeg && length(gui.Results.coreg.Children) == 1 %Did seg but has not been visualized yet (Initial run of segement button)
        temp = figure( 'Visible', 'off' );
        if ~isfield(MRSCont.flags,'isPRIAM')  && ~MRSCont.flags.isPRIAM
            temp = osp_plotCoreg(MRSCont, gui.controls.Selected);
        else
            temp = osp_plotCoreg(MRSCont, gui.controls.Selected,gui.controls.act_x);
        end
        set( temp.Children.Children, 'Parent', gui.Results.coreg.Children(1));
        colormap(gui.Results.coreg.Children(1),'gray');
        close( temp );
        temp = figure( 'Visible', 'off' );
        if ~isfield(MRSCont.flags,'isPRIAM')  && ~MRSCont.flags.isPRIAM
            temp = osp_plotSegment(MRSCont, gui.controls.Selected);
        else
            temp = osp_plotSegment(MRSCont, gui.controls.Selected,gui.controls.act_x);
        end
        set( temp.Children.Children, 'Parent', gui.Results.coreg.Children(2));
        colormap(gui.Results.coreg.Children(1),'gray');
        close( temp );
    elseif length(gui.Results.coreg.Children) == 1 %Only coreg has been performed
        temp = figure( 'Visible', 'off' );
        if ~isfield(MRSCont.flags,'isPRIAM')  && ~MRSCont.flags.isPRIAM
            temp = osp_plotCoreg(MRSCont, gui.controls.Selected);
        else
            temp = osp_plotCoreg(MRSCont, gui.controls.Selected,gui.controls.act_x);
        end
        set( temp.Children.Children, 'Parent', gui.Results.coreg.Children(1) );
        delete( gui.Results.coreg.Children(1).Children(2) );
        colormap(gui.Results.coreg.Children,'gray')
        set( gui.Results.coreg.Children(1).Title, 'String', temp.Children.Title.String);
        close( temp );
    else % Neither coreg nor segment has been performed
        temp = figure( 'Visible', 'off' );
        if ~isfield(MRSCont.flags,'isPRIAM')  && ~MRSCont.flags.isPRIAM
            temp = osp_plotCoreg(MRSCont, gui.controls.Selected);
        else
            temp = osp_plotCoreg(MRSCont, gui.controls.Selected,gui.controls.act_x);
        end
        set( temp.Children, 'Parent', gui.Results.coreg );
        colormap(gui.Results.coreg.Children,'gray')
        close( temp );
        set( temp.Children.Children, 'Parent', gui.Results.coreg.Children(1) );
        delete( gui.Results.coreg.Children(1).Children(2) );
        colormap(gui.Results.coreg.Children,'gray')
        close( temp );
    end
    
elseif gui.coreg.Selected == 2 %Is this the tab for the second structural image?
    delete( gui.Results.coreg.Children(1) );
    temp = figure( 'Visible', 'off' );
    temp = osp_plotCoregSecond(MRSCont, gui.controls.Selected);
    set( temp.Children, 'Parent', gui.Results.coreg);
    colormap(gui.Results.coreg.Children(1),'gray');
    close( temp );

elseif gui.coreg.Selected == 3 % Is this the tab for the PET image?

    if MRSCont.flags.didSeg && length(gui.Results.coreg.Children) == 3 % Did seg & has been visualized already
        delete(gui.Results.coreg.Children(1)); %delete distribution plot
        delete(gui.Results.coreg.Children(1)); %delete distribution plot
        delete(gui.Results.coreg.Children(1)); %delete image
        temp = figure('Visible', 'off');
        if gui.controls.Selected <= length(MRSCont.seg.tissue.fGM)
            temp = osp_plotSegmentPET(MRSCont, gui.controls.Selected);
            set(temp.Children, 'Parent', gui.Results.coreg);
            colormap(gui.Results.coreg.Children(1), 'gray');
            close(temp);
            set(gui.Results.coreg, 'Heights', -0.49*ones(length(gui.Results.coreg.Children),1));
            set(gui.Results.coreg.Children(1), 'Units', 'normalized')
            set(gui.Results.coreg.Children(1), 'OuterPosition', [0,0.5,1,0.5])
            set(gui.Results.coreg.Children(2), 'Units', 'normalized')
            set(gui.Results.coreg.Children(2), 'OuterPosition', [0,0,0.5,0.5])
            set(gui.Results.coreg.Children(3), 'Units', 'normalized')
            set(gui.Results.coreg.Children(3), 'OuterPosition', [0.5,0,0.5,0.5])
        end
    else
        if MRSCont.flags.didSeg && length(gui.Results.coreg.Children) == 2 %Did seg but has not been visualized yet (Initial run of segment button)
            delete(gui.Results.coreg.Children(1)); %delete distribution plot
            delete(gui.Results.coreg.Children(1)); %delete image
            temp = figure('Visible', 'off');
            temp = osp_plotSegmentPET(MRSCont, gui.controls.Selected);
            set(temp.Children, 'Parent', gui.Results.coreg);
            colormap(gui.Results.coreg.Children(1), 'gray');
            close(temp);
            set(gui.Results.coreg, 'Heights', -0.49*ones(length(gui.Results.coreg.Children),1));
            set(gui.Results.coreg.Children(1), 'Units', 'normalized')
            set(gui.Results.coreg.Children(1), 'OuterPosition', [0,0.5,1,0.5])
            set(gui.Results.coreg.Children(2), 'Units', 'normalized')
            set(gui.Results.coreg.Children(2), 'OuterPosition', [0,0,0.5,0.5])
            set(gui.Results.coreg.Children(3), 'Units', 'normalized')
            set(gui.Results.coreg.Children(3), 'OuterPosition', [0.5,0,0.5,0.5])

        else
            if length(gui.Results.coreg.Children) == 2 %Only coreg has been performed
                temp = figure('Visible', 'off');
                temp = osp_plotCoregPET(MRSCont, gui.controls.Selected);
                delete(gui.Results.coreg.Children(1));
                delete(gui.Results.coreg.Children(1));
                set(temp.Children, 'Parent', gui.Results.coreg );
                colormap(gui.Results.coreg.Children(1), 'gray');
                close(temp);
                set(gui.Results.coreg, 'Heights', -0.49*ones(length(gui.Results.coreg.Children),1));
                set(gui.Results.coreg.Children(1), 'Units', 'normalized')
                set(gui.Results.coreg.Children(1), 'OuterPosition', [0,0.5,1,0.5])
                set(gui.Results.coreg.Children(2), 'Units', 'normalized')
                set(gui.Results.coreg.Children(2), 'OuterPosition', [0,0,1,0.5])
            else % Neither coreg nor segment has been performed
                temp = figure('Visible', 'off');
                temp = osp_plotCoregPET(MRSCont, gui.controls.Selected);
                set(temp.Children, 'Parent', gui.Results.coreg);
                colormap(gui.Results.coreg.Children(1), 'gray')
                close(temp);
            end
        end
    end

end

% Clean up
setappdata(gui.figure, 'MRSCont', MRSCont); %Write MRSCont into hidden container in gui class

% Set callback action
set(gui.controls.b_save_coregTab, 'Callback', {@osp_onPrint, gui});

        set(gui.controls.b_save_coregTab,'Callback',{@osp_onPrint,gui});
        setappdata(gui.figure,'MRSCont',MRSCont); %Write  MRSCont into hidden container in gui class
end
