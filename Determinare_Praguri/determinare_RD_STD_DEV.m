% RD ST DEV
normal_values = [
    0.047776 0.036 0.038886 0.024421 0.015166;
    0.015336 0.013038 0.014014 0.013598 0.010661;
    0.0102 0.0103 0.0069 0.0092 0.0085;
    0.076 0.043 0.035 0.063 0.0493;
];

apnea_values = [
    0.040479 0.050417 0.051708 0.10489 0.058522;
    0.066708 0.042736 0.029 0.028 0.06070;
    0.0205 0.0214 0.0180 0.0220 0.0220;
    0.1837 0.109 0.1028 0.107 0.0954;
];

% Combine all values into one vector
combined_normal_values = normal_values(:);
combined_apnea_values = apnea_values(:);

% Calculate the mean of combined values
mean_combined_normal = mean(combined_normal_values);
mean_combined_apnea = mean(combined_apnea_values);

% Determine the general threshold between normal and apnea
prag_medie = (mean_combined_normal + mean_combined_apnea) / 2;
prag_medie=0.048;
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
