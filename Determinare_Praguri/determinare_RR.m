% Lungimea RR
normal_values = [
    0.903 0.881 0.8591 0.8355 0.934;
    0.7517 0.855 0.8073 0.755 0.7442;
    %0.7215 0.6636 0.6579 0.6614 0.6761;
    %0.9922 1.0775 1.0567 1.045 1.08;
    0.81 0.7725 0.78 0.7842 0.7866;
];

apnea_values = [
    0.7945 0.8491 0.8273 0.886 1.04;
    0.92 0.8382 0.725 0.8282 0.82785;
    %0.6686 0.7483 0.6457 0.84 0.7725;
    %1.1138 1.1687 1.1829 1.1781 0.1071;
    0.7442 0.7642 0.74 0.7292 0.7444;
];

% Combine all values into one vector
combined_normal_values = normal_values(:);
combined_apnea_values = apnea_values(:);

% Calculate the mean of combined values
mean_combined_normal = mean(combined_normal_values);
mean_combined_apnea = mean(combined_apnea_values);

% Determine the general threshold between normal and apnea
prag_medie = (mean_combined_normal + mean_combined_apnea) / 2;

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
