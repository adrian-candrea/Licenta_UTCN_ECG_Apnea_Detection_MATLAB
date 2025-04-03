%Candrea Ioan Adrian
%DETECTOR 
%Pan_Tompkins Algoritm
clear variables;
% Fisierul CSV
%data = csvread('a01s.csv');
%'t10s.csv'
%'t1m.csv'
[time,signal] = importfile('a01s.csv');
%time = data(:, 1);
%signal = data(:, 2);
fs= 100;
time=time+abs(time(1));
N= length(signal);
%VALOARE LINIA ISOELECTRICA
linia_isoelectrica = 0;
t = 1 / fs;

% Slectare intervale afisare
min_time = input('Valuare minimă în secunde: ');
max_time = input('Valuare maximă în secunde: ');

% interval in secunde,min si max
start_index = find(time >= min_time, 1);
end_index = find(time <= max_time, 1, 'last');

time_axis = (start_index:end_index) / fs;
% Afisare semnal ECG Original
figure,
subplot(4,1,1);
plot(time(start_index:end_index), signal(start_index:end_index));
xlabel('Timp (s)');
ylabel('Amplitudine (mV)');
title('Semnal ECG Original');
grid on;

%Pas 0 Eliminarea componentei continue
signal= signal-mean(signal);
signal= signal.*100;

%Pas 1 filtrare FTB apicat prin FTS si FTJ
%FTS-eliminare baseline wander and offseturi de tip curent continu
%FTJ-pentru a atenua zgomotu de nivel inalt
%definire frecvente de taiere filtre
fjos=2;
fsus=40;
ord=4;

%filtrare trece sus
f1 = fdesign.highpass('n,F3dB', ord, fjos, fs);
ftss = design(f1,'butter');
s_filtrat_1 = filter(ftss,signal);

%filterea trece jos
f2 = fdesign.lowpass('n,F3dB', ord, fsus, fs);
ftjj = design(f2, 'butter');

s_filtrat_2 = filter(ftjj,s_filtrat_1);

subplot(4,1,2);
plot(time(start_index:end_index), s_filtrat_2(start_index:end_index));
xlabel('Timp (s)');
ylabel('Amplitudine (mV)');
title('Semnal filtrat');
grid on;

%Pas2 NORMALIZARE,includ semnalul intre un interval mai mic si bine
%stabilit(-1->1)

numitor=max(abs(s_filtrat_2));
s_normalizat=(1/numitor)*s_filtrat_2;

subplot(4,1,3);
plot(time(start_index:end_index), s_normalizat(start_index:end_index));
xlabel('Timp (s)');
ylabel('Amplitudine (mV)');
title('Semnal Normalizat');
grid on;

%PAS3 DIFERENTIERE 
sem_dif = diff(s_normalizat); 
sem_dif_fin = sem_dif;

subplot(4,1,4);
plot(time(start_index:end_index), sem_dif_fin(start_index:end_index));
xlabel('Timp (s)');
ylabel('Amplitudine (mV)');
title('Semnal diff');
grid on;

%PAS 4 Ridicare la pătrat 
% Squaring
% o sa am caracteristici pozitive si se vor evedentia mai bine semnalele
semnal_squ = sem_dif_fin .^ 2;

figure,
subplot(4,1,1);
plot(time(start_index:end_index), semnal_squ(start_index:end_index));
xlabel('Timp (s)');
ylabel('Amplitudine (mV)');
title('Semnal cu Squaring');
grid on;

%PAS 5
%INtegrare
%Moving Window Integration
%obține informații atât despre panta cât și despre lățimea complexului QRS
%PAS 5 Integrare
integreare_f = round(0.150 * fs);
filterrr=ones(1,integreare_f)/integreare_f;
s_integrat= conv(semnal_squ,filterrr, 'same');
%s_integrat = movmean(semnal_squ, integreare_f);

subplot(4,1,2);
plot(time(start_index:end_index), s_integrat(start_index:end_index));
xlabel('Timp (s)');
ylabel('Amplitudine (mV)');
title('Semnal Integrare');
grid on;

%PAS 6 Initializarea de praguri -> Thresholding
thr=0.01 * max(s_integrat);
s_date = s_integrat > thr;

subplot(4,1,3);
plot(time(start_index:end_index), s_date(start_index:end_index));
xlabel('Timp (s)');
ylabel('Amplitudine (mV)');
title('Semnal cu Thrshold - Prag');
grid on;

%DETECTARE UNDE

%Detectare R
%per_r perioada de refractară - folosit pentru determinarea lungimii
%ferestrei, evită punctele fals pozitive și asigură că unda R este
%detectată într-o fereastră
%fer_r fereastră refractară - asigură detecarea unei singure unde R la un
%moment dat
per_r = round(0.25 * fs);
fer_r = zeros(1, per_r);
r_vs = zeros(size(s_date)); % va stoca amplitudiniile undelor R
r_locs = []; %va stoca locațiile undelor R
%se produce o iterare peste fiecare proabă a senalului s_date
for i = 1:length(s_date) - per_r 
%verifică dacă valoare curentă e zero și că nici o undă R anterioară nu
%este în fereastra curentă
    if s_date(i) && all(fer_r == 0)
%detectare amplitudine și locație unda R
        [r_v, r_loc] = max(s_normalizat(i:i + per_r));
        r_vs(i + r_loc - 1) = r_v; 
        r_locs = [r_locs i + r_loc - 1];
        fer_r = ones(1, per_r); 
    else
        fer_r = [0 fer_r(1:end - 1)]; 
% dacă condiția nu este adevărată atunci fereastra se mută cu o poziție
% spre dreapta
    end
end

%UNDA Q
% Q
referinta_q = round(0.2 * fs);
q_locs = zeros(size(r_locs)); 

% Se cauta Q fix inainte de pozitia lui R
for i = 1:length(r_locs)
    r_loc = r_locs(i);
    
    start_cq = max(r_loc - referinta_q, 1);
    end_cq = r_loc - 1;
    
    [q_v, q_idx] = min(s_normalizat(start_cq:r_loc)); 
    q_locs(i) = start_cq + q_idx - 1;
end

%Unda S
% referinta aproape unda R(imediat dupa ea)
referinta_s = round(0.05 * fs); 
s_locs = zeros(size(r_locs)); 

% cautare unda s dupa unda r
for i = 1:length(r_locs)
    r_loc = r_locs(i); 
    
    start_cs = r_loc + 1; 
    end_cs = min(r_loc + referinta_s, length(s_normalizat)); 
    
    [s_v, s_idx] = min(s_normalizat(start_cs:end_cs)); 
    s_locs(i) = start_cs + s_idx - 1; 
end

%UNDA T
referinta_t = round(0.15 * fs); 
t_locs = zeros(size(r_locs)); 

for i = 1:length(r_locs)
    r_loc = r_locs(i); 
    
    start_ct = r_loc + referinta_t; 
    end_ct = min(r_loc + referinta_t, length(s_normalizat));
    
    [t_v, t_idx] = max(s_normalizat(start_ct:end_ct)); 
    t_locs(i) = start_ct + t_idx - 1; 
end

% UNDA P
referinta_p = round(0.13 * fs);
p_locs = zeros(size(r_locs));
p_vs = zeros(size(r_locs));

for i = 1:length(r_locs)
    r_loc = r_locs(i); 

    start_cp = max(r_loc - referinta_p, 1);
    end_cp = r_loc - referinta_p; 

    [p_v, p_idx] = max(s_normalizat(start_cp:end_cp)); 
    p_vs(i) = p_v; 
    p_locs(i) = start_cp + p_idx - 1; 
end

% TOATE undele PQRST din intervalul ales
r_loc_specific = r_locs(r_locs >= start_index & r_locs <= end_index);
q_loc_specific = q_locs(q_locs >= start_index & q_locs <= end_index);
s_loc_specific = s_locs(s_locs >= start_index & s_locs <= end_index); 
t_loc_specific = t_locs(t_locs >= start_index & t_locs <= end_index); 
p_loc_specific = p_locs(p_locs >= start_index & p_locs <= end_index);
% AMPLITUDINI SPECIFICE TOATE UNDELE
r_amp_specific = s_normalizat(r_loc_specific);
p_amp_specific = s_normalizat(p_loc_specific);
t_amp_specific = s_normalizat(t_loc_specific);
%Afisare amplitudini in consola
disp('R Valori perioada aleasa:');
disp(num2str(r_amp_specific', '%.4f '));
disp('P Valori perioada aleasa:');
disp(num2str(p_amp_specific', '%.4f '));
disp('T Valori perioada aleasa:');
disp(num2str(t_amp_specific', '%.4f '));

% AFISARE QRSPT Unde detectate
figure,
plot(time(start_index:end_index), s_normalizat(start_index:end_index), 'b');
hold on;
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('ECG Detectie puncte QRSPT');
%grid on;

scatter(time(r_loc_specific), s_normalizat(r_loc_specific), 'r', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
scatter(time(q_loc_specific), s_normalizat(q_loc_specific), 'g', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
scatter(time(s_loc_specific), s_normalizat(s_loc_specific), 'm', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
scatter(time(t_loc_specific), s_normalizat(t_loc_specific), 'c', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
scatter(time(p_loc_specific), s_normalizat(p_loc_specific), 'yellow', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
%legend({'Semnal ECG', 'Vârf R', 'Vârf Q', 'Vârf S', 'Vârf T', 'Vârf P'})



%Calcul intervale axa timp rr
intervale_rr = diff(time(r_locs));
avg_rr_interval = mean(intervale_rr);

%Determinare Intervale RR perioadă aleasă
rr_intervale = diff(time(r_loc_specific));
intervale_rr_spec = diff(time(r_loc_specific));
disp('Intervale RR:');
disp(num2str(rr_intervale', '%.4f '));


avg_rr_interval2 = mean(rr_intervale);
rr_times = time(r_loc_specific(1:end-1)) + rr_intervale / 2;


figure,
subplot(3,1,1);
plot(rr_times, rr_intervale, '-o', 'MarkerFaceColor', 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('RR Interval (s)');
title('Valori intervale RR');
grid on;

for i = 1:length(rr_intervale)
    text(rr_times(i), rr_intervale(i), sprintf('%.2f', rr_intervale(i)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end


% DETERMINARE AMPLITUDINE MEDIE UNDA R
% calcul amplitudini unda r
r_amp_amplitudine = s_normalizat(r_loc_specific) - linia_isoelectrica;
r_amplitudine_medie = mean(r_amp_amplitudine);
%disp(['AMPLITUDINEA MEDIA A UNDEI R PE INTERVALUL ALES ESTE: ', num2str(r_amplitudine_medie, '%.4f')]);
% distanta unde rr media
r_dis_medie=mean(rr_intervale);
%disp(['Distanta MEDIE A undelor RR PE INTERVALUL ALES ESTE: ', num2str(r_dis_medie, '%.4f')]);

%disp('R Valori perioada aleasa:');
%disp(num2str(r_amp_specific', '%.4f '));
%disp(['AMPLITUDINEA MEDIA A UNDEI R PE INTERVALUL ALES ESTE: ', num2str(r_amplitudine_medie, '%.4f')]);

k=0;
% Verificare prag amplitudini R
%r_ampl_prag = 0.10 * r_amplitudine_medie;

%r_prag_sup= r_amplitudine_medie + r_ampl_prag;
%r_prag_inf= r_amplitudine_medie - r_ampl_prag;
%disp(['Praguri amplitudini R: ', num2str(r_prag_inf, '%.4f'), ' si ', num2str(r_prag_sup, '%.4f')]);
%for i = 1:length(r_amp_amplitudine)
%    if r_amp_amplitudine(i) > r_prag_sup
%        disp(['Unda R la indexul ', num2str(i), ' este mai mare cu peste 10% fata de media.']);
%        k=1;
%    elseif r_amp_amplitudine(i) < r_prag_inf
%        disp(['Unda R la indexul ', num2str(i), ' este mai mica cu peste 10% fata de media.']);
%        k=1;
%    end
%end
%if k==1
%    disp('Nu toate undele R respecta conditia ');
%elseif k==0
%    disp('Toate undele R respecta conditia ');
%end


% distanta unde rr media
%r_dis_medie=mean(rr_intervale);
%disp(['Distanta MEDIE A undelor RR PE INTERVALUL ALES ESTE: ', num2str(r_dis_medie, '%.4f')]);

% Verificare prag lungini RR
%r_per_prag = 0.10 * r_dis_medie;
%z=0;
%rri_prag_sup= r_dis_medie + r_per_prag;
%rri_prag_inf= r_dis_medie - r_per_prag;
%disp(['Praguri intervale RR: ', num2str(rri_prag_inf, '%.4f'), ' si ', num2str(rri_prag_sup, '%.4f')]);
%for i = 1:length(rr_intervale)
%    if rr_intervale(i) > rri_prag_sup
%        disp(['Distanta RR la indexul ', num2str(i), ' este mai mare cu peste 10% fata de media.']);
%        z=1;
%    elseif rr_intervale(i) < rri_prag_inf
%        disp(['Distanta RR la indexul ', num2str(i), ' este mai mica cu peste 10% fata de media.']);
%        z=1; 
%    end
%end

%if z==1
%    disp('Nu toate intervalele RR respecta conditia ');
%elseif z==0
%    disp('Toate intervalele RR respecta conditia ');
%end

% Amplitudini unda P
% calcul amplitudini unda P
p_amp_amplitudine = s_normalizat(p_loc_specific) - linia_isoelectrica;

% amplitudinea medie unda P
p_amplitudine_medie = mean(p_amp_amplitudine);
%disp(['AMPLITUDINEA MEDIA A UNDEI P PE INTERVALUL ALES ESTE: ', num2str(p_amplitudine_medie, '%.4f')]);

% Verificare prag amplitudini P
%p_ampl_prag = 0.10 * p_amplitudine_medie;
%k=0;
%p_prag_sup= p_amplitudine_medie + p_ampl_prag;
%p_prag_inf= p_amplitudine_medie - p_ampl_prag;
%disp(['Praguri amplitudini P: ', num2str(p_prag_inf, '%.4f'), ' si ', num2str(p_prag_sup, '%.4f')]);
%for i = 1:length(p_amp_amplitudine)
%    if p_amp_amplitudine(i) > p_prag_sup
%        disp(['Unda P la indexul ', num2str(i), ' este mai mare cu peste 10% fata de media.']);
 %       k=1;
%    elseif p_amp_amplitudine(i) < p_prag_inf
%        disp(['Unda P la indexul ', num2str(i), ' este mai mica cu peste 10% fata de media.']);
 %       k=1;
 %   end
%end
%if k==1
%    disp('Nu toate undele P respecta conditia ');
%elseif k==0
%    disp('Toate undele P respecta conditia ');
%end

% amplitudini unda T
% calcul amplitudini unda T
t_amp_amplitudine = s_normalizat(t_loc_specific) - linia_isoelectrica;

% amplitudinea medie unda T
t_amplitudine_medie = mean(t_amp_amplitudine);
%disp(['AMPLITUDINEA MEDIA A UNDEI T PE INTERVALUL ALES ESTE: ', num2str(t_amplitudine_medie, '%.4f')]);

% Verificare prag amplitudini T
%t_ampl_prag = 0.10 * t_amplitudine_medie;
%k=0;
%t_prag_sup= t_amplitudine_medie + t_ampl_prag;
%t_prag_inf= t_amplitudine_medie - t_ampl_prag;
%disp(['Praguri amplitudini T: ', num2str(t_prag_inf, '%.4f'), ' si ', num2str(t_prag_sup, '%.4f')]);
%for i = 1:length(t_amp_amplitudine)
%    if t_amp_amplitudine(i) > t_prag_sup
%        disp(['Unda T la indexul ', num2str(i), ' este mai mare cu peste 10% fata de media.']);
%        k=1;
%    elseif t_amp_amplitudine(i) < t_prag_inf
%        disp(['Unda T la indexul ', num2str(i), ' este mai mica cu peste 10% fata de media.']);
%        k=1;
%    end
%end
%if k==1
%    disp('Nu toate undele T respecta conditia ');
%elseif k==0
%    disp('Toate undele T respecta conditia ');
%end

% Spectrul de PUTERE si calculul PUTERII totale
% se aplica prima data FFT
N_s = length(s_normalizat(start_index:end_index));
f_s = (0:N_s-1) * (fs / N_s);
n_s = floor(N_s / 2);
FFT_ECG = fft(s_normalizat(start_index:end_index));

% amplitudinii spectrului
ecg_amplitudine_putere = abs(FFT_ECG/ N_s);

% calcul pt. spectru de putere 
putere_ECG = ecg_amplitudine_putere.^2;

%separareinterval pozitiv de cel negativ
%f_s = (0:N_s-1) * (fs / N_s);
%n_s = floor(N_s/2);
 
figure();
plot(f_s(1:n_s), putere_ECG(1:n_s));
title('Spectrul de putere al semnalului ECG');
xlabel('Freventa');
ylabel('Putere');
 
putere_Totala = sum(putere_ECG);
disp('Puterea totală a spectrului de putere semnal ECG:');
disp(putere_Totala);

%  H R
% 60 RC  100
timpul = (N/fs)/60;
RC= round(mean(length(r_locs))/timpul);
disp(['Heart rate general:  = ', num2str(RC), ' bătăi pe minut']);

% Detectie HR interval scurt
time_segment = time(start_index:end_index);
time_segment_min = length(time_segment) / (fs * 60); 
RCs = round(length(r_loc_specific) / time_segment_min);
disp(['Heart rate interval: = ', num2str(RCs), ' bătăipe minut']);

%VERIFICARE HR metoda 2
%heart_rate = 60 / avg_rr_interval;
%disp(['R  Heart Rate: ', num2str(heart_rate), ' bpm']);

%heart_rate2 = 60 / avg_rr_interval2;
%disp(['R  Heart Rate: ', num2str(heart_rate2), ' bpm']);

%HRV
%SDNN = std(intervale_rr);
%RMSSD = sqrt(mean((intervale_rr - mean(intervale_rr)).^2));
%RMSSD = sqrt(mean(diff(intervale_rr).^2));
%disp(['SDNN_General: ', num2str(SDNN, '%.4f')]);
%disp(['RMSSD: ', num2str(RMSSD, '%.4f')]);
%disp(['RMSSp: ', num2str(RMSSD, '%.4f')]);

%AHR = mean(60 ./ intervale_rr);
%disp(['Average Heart Rate: ', num2str(AHR), ' bpm']);

%HRV
SDNNS = std(intervale_rr_spec);
%RMSSDp = sqrt(mean((intervale_rr_spec - mean(intervale_rr_spec)).^2));
%RMSSDS = sqrt(mean(diff(intervale_rr_spec).^2));
disp(['SDNN_Interval: ', num2str(SDNNS, '%.4f')]);
%disp(['RMSSD: ', num2str(RMSSDS, '%.4f')]);
%disp(['RMSSpnemodificat: ', num2str(RMSSDp, '%.4f')]);

%AHRS = mean(60 ./ intervale_rr_spec);
%disp(['Average Heart Rate: ', num2str(AHRS), ' bpm']);

% Calculate HRV
%hrv = std(intervale_rr);

% m - numar intervale RR
m = length(intervale_rr_spec);

% Calcul mean (μ) intervale RR
mean_rr = sum(intervale_rr_spec) / m;

% Calcul standard deviation (σ) intervale RR
standard_dev_rr = sqrt(sum((intervale_rr_spec - mean_rr).^2) / m);

% Calcul interbeat differentials (rd_i)
rd_interval = diff(intervale_rr_spec);

m_rd = length(rd_interval);

% Calcul mean of interbeat differentials (μ_rd)
mean_rd = sum(rd_interval) / m;

% Standard deviation of interbeat differentials rd
standard_dev_rd = sqrt(sum((rd_interval - mean_rd).^2) / m);

%RMSSD
rmssd2= sqrt(sum((rd_interval).^2)) / m;

disp(['Mean RR interval (μ): ', num2str(mean_rr)]);
disp(['Standard Deviation of RR intervals (σ): ', num2str(standard_dev_rr)]);
disp(['Mean RD interval (μ_rd): ', num2str(mean_rd)]);
disp(['Standard Deviation of interbeat differentials rd (σ): ', num2str(standard_dev_rd)]);
disp(['RMSSD: ', num2str(rmssd2, '%.4f')]);



%  NEP (Number of Extreme Points)
%unit 1 -> pozitiv, 0 -> negativ
% deci daca produsul este pozitiv unit pozitiv => unit = 1 => SUMA 1-1 = 0
% deci daca produsul este negativ unit negativ => unit = 0 => SUMA 1-0 = 1
m_NEP = length(rr_intervale);

NEP_sum = 0;
for i = 2:m_NEP-1
    if ((rr_intervale(i) - rr_intervale(i-1)) * (rr_intervale(i+1) - rr_intervale(i))) < 0
        NEP_sum = NEP_sum + 1;
    end
end

NEP = (1 / (m_NEP - 2)) * NEP_sum;
disp(['Number of Extreme Points (NEP): ', num2str(NEP)]);

%filename = input('Introduceți numele fișierului pentru salvare (includeți ".csv"): ', 's');
%csvwrite(filename, [time(start_index:end_index), data(start_index:end_index)]);


%INTERVALU QRS
val = length(intervale_rr_spec);
s_end = zeros(1, val); 
%Detactare punct final interval QRS
for i = 1:val
    start_s_idx = s_loc_specific(i);
     s_end_idx = find(s_normalizat(start_s_idx:end) >= linia_isoelectrica, 1, 'first') + start_s_idx - 1;
    s_end(i) = s_end_idx;
end
% Detectie Interval QRS
qrs_durata = zeros(1,val);
qrs_start_points = zeros(1,val);
qrs_end_points = zeros(1,val);

for i = 1:val 
qrs_start = find(s_normalizat(p_loc_specific(i):q_loc_specific(i)) <= linia_isoelectrica, 1, 'first') - 1; 
qrs_start = p_loc_specific(i)+ qrs_start -1;

qrs_end = s_end(i); 
qrs_duration_samples = qrs_end - qrs_start + 1; 
qrs_duration_seconds = qrs_duration_samples / fs; 
qrs_durata(i) = qrs_duration_seconds; 

qrs_start_points(i)=qrs_start;
qrs_end_points(i)= qrs_end;
end
disp('Intervale QRS:');
disp(num2str(qrs_durata, '%.4f '));

% Plot QRS 
figure;
plot(time_axis, s_normalizat(start_index:end_index));
hold on;

% Afisare interval
for i = 1:length(qrs_start_points)  
    plot(qrs_start_points(i) / fs, linia_isoelectrica * ones(size(qrs_start_points(i))), 'bo', 'MarkerSize', 5);
    plot(qrs_end_points(i) / fs, linia_isoelectrica * ones(size(qrs_end_points(i))), 'ko', 'MarkerSize', 5);
    plot([qrs_start_points(i) / fs qrs_end_points(i) / fs], [linia_isoelectrica linia_isoelectrica], 'g', 'LineWidth', 2);
end

% afisare interval selectat
xlim([start_index / fs end_index / fs]);
% interval QRS legenda
hold off;
title('Intervale QRS Semnal ECG');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
legend('Semnal ECG ', 'QRS start ', 'QRS end ', 'QRS interval');



% INTERVALUL PR
pr_intervals = zeros(size(p_loc_specific));
pr_start_points = zeros(size(p_loc_specific));
pr_end_points = zeros(size(p_loc_specific));


for i = 1:length(p_loc_specific)
    pr_start = find(s_normalizat(1:p_loc_specific(i)) <= linia_isoelectrica, 1, 'last');
    
    if i <= length(q_loc_specific) 
        qrs_start = find(s_normalizat(p_loc_specific(i):q_loc_specific(i)) <= linia_isoelectrica, 1, 'first') - 1; 
        pr_end = p_loc_specific(i) + qrs_start - 1;
    end
    
    if ~isempty(pr_start) && ~isempty(pr_end)
        pr_intervals(i) = time(pr_end) - time(pr_start);
        pr_start_points(i) = pr_start;
        pr_end_points(i) = pr_end;
    else
        pr_intervals(i) = NaN;
    end
end
disp('Intervale PR:');
disp(num2str(pr_intervals, '%.4f '));

% Plot ECG signal
figure;
plot(time_axis, s_normalizat(start_index:end_index));
hold on;

% AFISRE PR
for i = 1:length(pr_start_points)
    if ~isnan(pr_intervals(i))
        plot(pr_start_points(i) / fs, linia_isoelectrica, 'ro', 'MarkerSize', 5);
        plot(pr_end_points(i) / fs, linia_isoelectrica, 'mo', 'MarkerSize', 5);
        plot([pr_start_points(i) / fs pr_end_points(i) / fs], [linia_isoelectrica linia_isoelectrica], 'b', 'LineWidth', 2);
    end
end
xlim([start_index / fs end_index / fs]);
hold off;
title('Intervale PR Semnal ECG');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
legend('Semnal ECG', 'PR start ', 'PR end', 'PR interval');


%Afisare cautare


figure,
plot(time, s_normalizat, 'b');
hold on;
xlabel('Time (s)');
ylabel('Amplitude (mV)');
title('ECG Detectie puncte QRSPT');
grid on;

scatter(time(r_locs), s_normalizat(r_locs), 'r', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
scatter(time(q_locs), s_normalizat(q_locs), 'g', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
scatter(time(s_locs), s_normalizat(s_locs), 'm', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
scatter(time(t_locs), s_normalizat(t_locs), 'c', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
scatter(time(p_locs), s_normalizat(p_locs), 'yellow', 'filled', 'MarkerEdgeColor', 'none', 'SizeData', 50, 'MarkerFaceAlpha', 0.5);
legend({'Semnal ECG', 'Vârf R', 'Vârf Q', 'Vârf S', 'Vârf T', 'Vârf P'})


% DETERMINARE AMPLITUDINE MEDIE UNDA R
% calcul amplitudini unda r
r_amp_amplitudine = s_normalizat(r_loc_specific) - linia_isoelectrica;
r_amplitudine_medie = mean(r_amp_amplitudine);
disp(['AMPLITUDINEA MEDIA A UNDEI R PE INTERVALUL ALES ESTE: ', num2str(r_amplitudine_medie, '%.4f')]);

% DETERMINARE AMPLITUDINE MEDIE UNDA T
% calcul amplitudini unda T
t_amp_amplitudine = s_normalizat(t_loc_specific) - linia_isoelectrica;
t_amplitudine_medie = mean(t_amp_amplitudine);
disp(['AMPLITUDINEA MEDIA A UNDEI T PE INTERVALUL ALES ESTE: ', num2str(t_amplitudine_medie, '%.4f')]);

% DETERMINARE AMPLITUDINE MEDIE UNDA P
% calcul amplitudini unda P
p_amp_amplitudine = s_normalizat(p_loc_specific) - linia_isoelectrica;
p_amplitudine_medie = mean(p_amp_amplitudine);
disp(['AMPLITUDINEA MEDIA A UNDEI P PE INTERVALUL ALES ESTE: ', num2str(p_amplitudine_medie, '%.4f')]);

% distanta unde rr media
r_dis_medie=mean(rr_intervale);
disp(['Distanta MEDIE A undelor RR PE INTERVALUL ALES ESTE: ', num2str(r_dis_medie, '%.4f')]);

% distanta unde qrs media
qrs_dis_medie=mean(qrs_durata);
disp(['Distanta MEDIE A undelor QRS PE INTERVALUL ALES ESTE: ', num2str(qrs_dis_medie, '%.4f')]);

% distanta unde pr media
pr_dis_medie=mean(pr_intervals);
disp(['Distanta MEDIE A undelor PR PE INTERVALUL ALES ESTE: ', num2str(pr_dis_medie, '%.4f')]);


