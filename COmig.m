clear all
close all
clc

format long

dcmp = 20;      % CMP-Distance [m]
dt   = 2e-3;    % Samplingintervall [s]
nt   = 1001;    % Number of samples
ns   = 101;     % Number of traces
nh   = 5;       % Number of Offsets
Fs   = 1/dt;    % Frequency sampling [Hz]
hmax = 1000;    % Maximum Half-Offset [m]
dh   = 250;     % Offset increment [m]
vmin = 1000; %2750 ist wohl richtig
vmax = 5000;
dv   = 1000;
aper = 250;
%% Open File

filename = 'data-7/SEIS-orig';

fid = fopen(filename,'r');
data = reshape(fread(fid, [nt nh*ns],'single'),nt,ns,nh);
fclose(fid);

filenamefilt = 'data-7/SEIS-filt';

fidfilt = fopen(filenamefilt,'r');
filtdata = reshape(fread(fidfilt, [nt nh*ns],'single'),nt,ns,nh);
fclose(fidfilt);

farbe = rand(nh,3);

%% Plot horizontal maximum data
%{
figure
hold on
for m = 1:nx
    plot(dt*(0:nt-1),max(data(:,:,m),[],2),'Color',farbe(m,:))
end
legend('h = 0km','h = .25km','h = .5km','h = .75km','h = 1km','Location','NorthWest')
xlabel('Time')
ylabel('Amplitude')


%% Frequency content

NFFT = 2^nextpow2(nt);
fdata  = fft(mean(data(:,:,1),2),NFFT)/nt;
faxis = Fs/2*linspace(0,1,NFFT/2+1);

figure
plot(faxis,abs(fdata(1:length(faxis)))/max(abs(fdata(1:length(faxis)))));
xlabel('Frequency');
ylabel('Normalized Amplitude');
title('Frequency analysis')
axis tight
%}

%% Kirchhoff Migration

half_aper = round(.5*aper/dcmp);

% Initialisierungen
h = 0:dh:hmax;
Kirchhoff(1:nt,1:ns,1:nh)=0; %(Zeit, CMP, Offset)
Skala(1:nt,1:nh) = 0;
depth(1:nt)=0;
t=(0:nt-1)'*dt;

i_v = 0;
%% Schleife ueber Geschwindigkeiten
for v = vmin:dv:vmax;
    i_v = i_v+1;
    Kirchhoff(1:nt,1:ns,1:nh)=0; %(Zeit, CMP, Offset)
    Skala(1:nt,1:nh) = 0;
    depth(1:nt)=0;
    phi(1:nt)=0;
    
    t=(0:nt-1)'*dt;
    %% Schleife ueber half offsets
    for i_h = 1:nh
        depth = sqrt((t).^2+(h(i_h)/v).^2);
        phi = max(h(i_h)./depth);
        
        [Kirchhoff(:,:,i_h) Skala(:,i_h)] = CO_kirch(filtdata(:,:,i_h), v, phi, h(i_h), dt, dcmp);
    end
    i_t=1:nt;
    % Axenskalierter tiefenmirgierter Plot (summierter CIG)
    %
    fm = figure(v);
    set(fm, 'Position', [0 0 1280 1024] );
    hold on
    for m = 1:nh
        plot(Skala(:,m),sum(Kirchhoff(:,:,m),2),'Color',farbe(m,:))  % Tiefenskaliert
    end
    axis tight
    hold off
    %{
    ff=figure;
    set(ff, 'Position', [0 0 1280 1024] );
    imagesc((1:nt)'*dt,1:ns*nh,Kirchhoff(:,:))
    title('Zeitmigration')
    colorbar
    %}
    fx=figure;
    set(fx, 'Position', [0 0 1280 1024] );
    for m = 1:nh
        subplot(1,nh,m)
        imagesc((1:ns)*dcmp,Skala(:,m),Kirchhoff(:,:,m))
    end
    title('Tiefenmigration')
    colorbar
    %}
    
end

% Aufsummieren der CO-Gather zur finalen migrierten Sektion
% Mig(1:nt,1:ns)=sum(Kirchhoff(:,:,:),3);
% figure
% contourf(Mig,100,'Linestyle','none')