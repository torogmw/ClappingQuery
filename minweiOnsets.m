function [ onsets, bpm ] = minweiOnsets( wavfile )
sro = 8000;         % resample rate 
                    % specgram: 256 bin @ 8kHz = 32 ms / 4 ms hop
swin = 256;
shop = 32;
nmel = 40;          % mel channels
sgsrate = sro/shop; % sample rate for specgram frames (granularity for rest of processing)
% autoco out to 1.5 s
acmax = round(1.5*sgsrate);
D = 0;
sr=44100;

[d sr] = wavread(wavfile);
d = mean(d, 2);

if (sr ~= sro)
gg = gcd(sro,sr);
d = resample(d,sro/gg,sr/gg);
sr = sro;
end

% D = specgram(d,swin,sr,swin,swin-shop);
D = stft(d, swin, shop, 32, 'hann');

% Construct db-magnitude-mel-spectrogram
mlmx = fft2melmx(swin,sr,nmel);
D = 20*log10(max(1e-10,mlmx(:,1:(swin/2+1))*abs(D)));

% Only look at the top 80 dB
D = max(D, max(max(D))-80);

% D(1:end-1, :) = 0;


% The raw onset decision waveform
mm = (mean(max(0,diff(D')')));
eelen = length(mm);

% dc-removed mm
onsetenv = filter([1 -1], [1 -.99],mm);

% find the peak point in onest as segment~
% self adaptve
onsetsRaw = find(onsetenv>30); 
tempindex=[];
for index=2:length(onsetsRaw)
    if onsetsRaw(index)-onsetsRaw(index-1)<20
        tempindex=[tempindex index];
    end
end
onsetsRaw(tempindex)=[];
onsets=onsetsRaw*shop/sro;

% onsetenv = mm;

%% tempo estimation
twtime = 9;
thtime = 1;
twlen = twtime / (shop / sr); % tempo window length
thsize = thtime / (shop / sr); % tempo window hopsize
twnum = floor((eelen - twlen) / thsize) + 1;

% tmean = 120;
% tsd = 3.0;
% % a weighting function centered at 120 BPM ranged from 40 to 240
% fun_l = round(60 / 240 / 0.004);
% fun_r = round(60 / 40 / 0.004);
% fun_c = round(60 / 120 / 0.004);
% xcrwin = zeros(1, acmax+1);
% xcrwin(fun_l+1:fun_c) = sin(0.5*pi/(fun_c-fun_l)*(1:fun_c-fun_l)).^4;
% xcrwin(fun_c+1:fun_r) = cos(0.5*pi/(fun_r-fun_c)*(1:fun_r-fun_c)).^4;

tempos = zeros(acmax+1, twnum);

for ii=1:twnum
    win = onsetenv((ii-1)*thsize+1:(ii-1)*thsize+twlen);
    xcr = xcorr(win, win, acmax);

    rawxcr = xcr(acmax+1+[0:acmax]);
    
    for jj=1:acmax+1
        if rawxcr(jj) > 0
            tempos(jj, ii) = rawxcr(jj);
        else
            tempos(jj, ii) = 0;
        end
    end
    
end

acmax = floor((acmax+1)/2) - 1;
% harmonic product
for ii=1:twnum
    for jj=1:acmax+1
        tempos(jj, ii) = (tempos(jj, ii) * tempos(jj*2, ii))^0.5;
    end
end
tempos = tempos(1:acmax+1, :);

fun_l = 75; % tempo high bound 200
fun_r = 188; % tempo low bound 80
xcrwin = [zeros(1, fun_l-1) ones(1, fun_r-fun_l+1) zeros(1, acmax-fun_r+1)];

tempos = bsxfun(@times, tempos, xcrwin');

a=zeros(1,length(tempos(1,:)));

for index=1:length(tempos(1,:))
    a(index)=find(tempos(:,index)==max(tempos(:,index)));
end



bpm=60/mode(a)/0.004

end

