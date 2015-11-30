%% export2pdf
%
% Example :
%
% for i=1:5
%
%   subplot(5,1,i);plot(linspace(0,10,10),  rand(1,10));
%   xlabel('t [s]'); ylabel(sprintf('x_%i',i));title(sprintf('Title %i',i));
%
% end
%
% export2pdf('FileName','fig1','DimPlot',[6,15],'CorrectionPaperPosition',[0,-1,0,2])
%
% Parameters (optional):
%
% 'FileName' (by Default the name is required with a GUI)
% 'Handle' ( Default gcf)
% 'Units' ( Default 'centimeters')
% 'RestoreSettings' ( Default 1) restore original settings after exporting
% 'CorrectionPaperPosition' ( Default zeros(1,4) ) is used to reduce the
%       margin of the figure 'PaperPosition',[0,0,dimPlot]+correctionPaperPosition
%       see PaperPosition
% 'dpi' (Default 150)
% 'DimPlot' Dimention of the plot in the predefined unit
% 'SaveFile' (Default 1), if set to 0, can be used to only apply the
%       graphical changes without exporting the pdf
% 'FontSize' (Default 9) Size font x-y-z-labels
% 'FontSizeTitle' (Default 10) Size font title





function export2pdf(varargin)

handle                 = gcf;
dpi                    = 150;
units                  = 'centimeters';
fontName               = 'Times New Roman';
fontSize               = 9;
fontSizeTitle          = 10;
predefinedFileName     = 0;
dimPlot                = [];
parameterPointer       = 1;
saveFile                = 1;
correctionPaperPosition = zeros(1,4);
restoreSettings         = 1;

hasParameters = length(varargin)-parameterPointer>=0;


while hasParameters
    
    if (ischar(varargin{parameterPointer}))
        
        switch varargin{parameterPointer}
            
            case 'FileName'
                
                fileName = varargin{parameterPointer+1};
                
                predefinedFileName = 1;
                
                parameterPointer = parameterPointer+2;
                
            case 'Units'
                
                units = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            case 'Handle'
                
                handle = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            case 'RestoreSettings'
                
                restoreSettings = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            case 'dpi'
                
                dpi = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            case 'DimPlot'
                
                dimPlot = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            case 'SaveFile'
                
                saveFile = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            case 'FontSize'
                
                fontSize = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            case 'FontSizeTitle'
                
                fontSizeTitle = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            case 'CorrectionPaperPosition'
                
                correctionPaperPosition = varargin{parameterPointer+1};
                
                parameterPointer = parameterPointer+2;
                
            otherwise
                
                parameterPointer = parameterPointer+1;
                
        end
    else
        parameterPointer = parameterPointer+1;
    end
    
    hasParameters = length(varargin)-parameterPointer>=0;
    
end



grid on



if not(predefinedFileName) && saveFile
    [fileName,pathName] = uiputfile('*.pdf','Save to PDF file:');
    if fileName == 0; return; end
    fileName = [pathName,fileName];
end

ax = gca;
if restoreSettings
    
    prePaperType     = get(handle,'PaperType');
    prePaperUnits    = get(handle,'PaperUnits');
    preUnits         = get(handle,'Units');
    prePaperPosition = get(handle,'PaperPosition');
    prePaperSize     = get(handle,'PaperSize');
    preFontSize      = get(get(ax,'xlabel'),'FontSize');
    preFontSizeTitle = get(get(ax,'title') ,'FontSize');
    preFontName      = get(get(ax,'title') ,'FontName');
    
end

%% Labels settings
hAllAxes = findobj(gcf,'type','axes');
for i = 1:length(hAllAxes)
    
    set(get(hAllAxes(i),'xlabel'),'FontSize',fontSize,'FontName',fontName);
    set(get(hAllAxes(i),'ylabel'),'FontSize',fontSize,'FontName',fontName);
    set(get(hAllAxes(i),'zlabel'),'FontSize',fontSize,'FontName',fontName);
    set(get(hAllAxes(i),'title') ,'FontSize',fontSizeTitle,'FontName',fontName);
    set(hAllAxes(i),'fontsize',fontSize,'FontName',fontName);
    grid on
end

% Set units to all be the same
set(handle,'PaperUnits',units);
set(handle,'Units',units);

position = get(handle,'Position');

if isempty(dimPlot)
    dimPlot =position(3:4);
end

set(handle,'PaperPosition',[0,0,dimPlot]+correctionPaperPosition);
set(handle,'PaperSize',dimPlot);


if saveFile
    print(handle,'-dpdf',fileName,sprintf('-r%d',dpi))
end


if restoreSettings
    set(handle,'PaperType'    ,prePaperType);
    set(handle,'PaperUnits'   ,prePaperUnits);
    set(handle,'Units'        ,preUnits);
    set(handle,'PaperPosition',prePaperPosition);
    set(handle,'PaperSize'    ,prePaperSize);
    
    
    for i = 1:length(hAllAxes)
        
        set(get(hAllAxes(i),'xlabel'),'FontSize',preFontSize,'FontName',preFontName);
        set(get(hAllAxes(i),'ylabel'),'FontSize',preFontSize,'FontName',preFontName);
        set(get(hAllAxes(i),'zlabel'),'FontSize',preFontSize,'FontName',preFontName);
        set(get(hAllAxes(i),'title') ,'FontSize',preFontSizeTitle,'FontName',preFontName);
        set(hAllAxes(i),'fontsize',preFontSize,'FontName',preFontName);
        grid off
    end
    
    
end


end
