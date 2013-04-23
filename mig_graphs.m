function mig_graphs(switcher,varargin)

switch switcher
    case 'SingleLine'
        % Template: mig_graphs('SingleLine',data,axis,xlabel,ylabel,fileoutput)
        figure
        plot(varargin{2},varargin{1},'k');
        xlabel(varargin{3},'Fontsize',24);
        ylabel(varargin{4},'Fontsize',24);
        
    case 'CompLine'
        % Template: mig_graphs('CompLine',name1,input1,name2,input2,axis,xaxis,yaxis,output)
        figure
        hold on
        plot(varargin{5},varargin{2},'k')
        plot(varargin{5},varargin{4},'r')
        ylabel(varargin{7},'Fontsize',24)
        xlabel(varargin{6},'Fontsize',24)
        legend(varargin{1},varargin{3},'Location','NorthEast')
        
    case 'OffsetLine'
        % Template: mig_graphs('OffsetLine',data,axis,name)
        data = varargin{1};
        [nt,ns,nh] = size(data);
        farbe = rand(nh,3);
        farbe(:,1)=sort(farbe(:,1));
        farbe(:,2)=sort(farbe(:,2),'Descend');
        
        figure
        hold on
        for k=1:nh
            plot(varargin{2},max(abs(data(:,:,k)),[],1),'Color',farbe(k,:))
        end
        xlabel('CMP','Fontsize',24)
        ylabel('Maximum amplitude','Fontsize',24)
        legend('h = 0','h = 250','h = 500','h = 750','h = 1000','Location','best')
        
    case 'COG'
        % Template: mig_graphs('COG',data,CMPaxis,yaxis,ylabel,name)
        figure
        imagesc(varargin{2},varargin{3},varargin{1},[-max(max(max(abs(varargin{1})))) +max(max(max(abs(varargin{1}))))])
        xlabel('CMP [km]','Fontsize',24)
        ylabel(varargin{4},'Fontsize',24)
        colormap([ones(101,1),(0:.01:1)',(0:.01:1)';(1:-.01:0)',(1:-.01:0)',ones(101,1)])    % polarized plot
        colorbar
        set(gca,'XTick',(0:5)*2e3)                  
        set(gca,'XTickLabel',{' 0 ','2 / 0','2 / 0','2 / 0','2 / 0',' 2 '})                  % reskaling x-axis
        
        
    case 'PolarPlot'
        % Template: mig_graphs('PolarPlot',data,yaxis,xaxis,xlabel,ylabel,name)
        figure
        imagesc(varargin{2},varargin{3},varargin{1},[-max(max(max(abs(varargin{1})))) +max(max(max(abs(varargin{1}))))])
        %title('Tiefenmigration','Fontsize',24)
        xlabel(varargin{4},'Fontsize',24)
        ylabel(varargin{5},'Fontsize',24)
        colormap([ones(101,1),(0:.01:1)',(0:.01:1)';(1:-.01:0)',(1:-.01:0)',ones(101,1)])
        colorbar
        
        
    otherwise
        warndlg('Please choose valid Graph option')
end
%%% Fuer alte traceplots muesste zurueck interpoliert werden, da
%%% length(z) != length(t) und length(z) haengt von v ab, siehe
%%% t_depth=t_orig*v*0.5;
%%% zmax = max(t_depth);     % zmax nimmt mit steigendem v zu, aber
%%% z=0:dz:zmax;             % dz bleibt gleich !

set(gca,'Fontsize',24)
print('-dpng',sprintf('%s/output/%s.png',pwd,varargin{end}));
