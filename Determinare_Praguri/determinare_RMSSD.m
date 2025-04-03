% RMSSD
% a14 si a19, foarte mici,nerelevante ar fi frecta media
%media calculata 0.0097967
%media stabilita manual 0.0065
normal_values = [
    0.0152 0.0114 0.0117 0.0074 0.0143;
    0.0049 0.0053 0.0042 0.0040 0.0031;
    0.0029 0.0028 0.0020 0.0025 0.0025;
];

apnea_values = [
    0.0128 0.0152 0.0156 0.0332 0.0213;
    0.0214 0.0129 0.0088 0.0072 0.0175;
    0.0061 0.0085 0.0052 0.0070 0.0070;
    
];

% Combine all values into one vector
combined_normal_values = normal_values(:);
combined_apnea_values = apnea_values(:);

% Calculate the mean of combined values
mean_combined_normal = mean(combined_normal_values);
mean_combined_apnea = mean(combined_apnea_values);

% Determine the general threshold between normal and apnea
prag_medie = (mean_combined_normal + mean_combined_apnea) / 2;
prag_medie= 0.00609;
disp(['Pragul General/unic este: ', num2str(prag_medie)]);

% Clasificare in fucntie de prag
disp('Clasificare vector valori normale:');
for i = 1:size(normal_values, 1)
    for j = 1:size(normal_values, 2)
        value = normal_values(i, j);
        if value > prag_medie
            disp(['Vector Normal (Persoana ', num2str(i), ', Valoare ', num2str(j), '): Apnea']);
        else
            disp(['Vector Normal  (Persoana ', num2str(i), ', Valoare ', num2str(j), '): Normal']);
        end
    end
end

% Clasificare intervale cu apne
disp('Clasificare vector valori apne:');
for i = 1:size(apnea_values, 1)
    for j = 1:size(apnea_values, 2)
        value = apnea_values(i, j);
        if value > prag_medie
            disp(['Vector Apnea (Persoana ', num2str(i), ', Valoare ', num2str(j), '): Apnea']);
        else
            disp(['Vector Apnea (Persoana ', num2str(i), ', Valoare ', num2str(j), '): Normal']);
        end
    end
end


% Classify normal values based on the threshold
disp('Classifying normal values:');
for i = 1:size(normal_values, 1)
    person_data = normal_values(i, :);
    r_peak = person_data(3);

    if r_peak > prag_medie
        disp(['Person ', num2str(i), ': Apnea']);
    else
        disp(['Person ', num2str(i), ': Normal']);
    end
end

% Classify apnea values based on the threshold
disp('Classifying apnea values:');
for i = 1:size(apnea_values, 1)
    person_data = apnea_values(i, :);
    r_peak = person_data(3);

    if r_peak > prag_medie
        disp(['Person ', num2str(i), ': Apnea']);
    else
        disp(['Person ', num2str(i), ': Normal']);
    end
end
