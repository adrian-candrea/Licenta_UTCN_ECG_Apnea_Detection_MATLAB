% RR ST DEV
%0.05138
%0.054
normal_values = [
    0.053861 0.0323 0.045218 0.024639 0.052953;
    0.0299954 0.026926 0.010523 0.01118 0.01441;
    0.0094 0.011 0.014 0.014 0.012;
    0.0647 0.0457 0.051 0.063 0.0409;
    0.0141 0.0092 0.0122 0.0201 0.01 ;
];

apnea_values = [
    0.076082 0.040778 0.054454 0.085229 0.066884;
    0.05831 0.048208 0.045 0.035883 0.052;
    0.589 0.0868 0.037553 0.0388 0.0708;
    0.1077 0.078 0.098 0.069 0.0554;
    0.0175 0.0171 0.0158 0.0149 0.0165;
];

% Combine all values into one vector
combined_normal_values = normal_values(:);
combined_apnea_values = apnea_values(:);

% Calculate the mean of combined values
mean_combined_normal = mean(combined_normal_values);
mean_combined_apnea = mean(combined_apnea_values);

% Determine the general threshold between normal and apnea
prag_medie = (mean_combined_normal + mean_combined_apnea) / 2;
prag_medie=0.054;
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
