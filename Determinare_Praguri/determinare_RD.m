% RD
%prag 0.0015504,nu strica poate ceva ales
normal_values = [
    -0.005 -0.001 -0.0027 0.0018818 0;
    0.00666 0.01 -0.00182 0.0025 -0.0016;
    0.0015 -0.0007 0.0028 -0.0008 -0.003;
    0.0088 -0.01 0.01 -0.01 -0.0075;
    0.0027 0.0083 0.0016 0.0033 0.0025;
];

apnea_values = [
    0.011818 -0.00182 0.002727 -0.004 -0.01375;
    0.01 0.0009 -0.0075 0.004546 0.005;
    0.01 -0.019 -0.0064 -0.007 -0.015;
    0.01375 0.0275 0.031429 0.0257 0.0011;
    -0.0051 0.0016 -0.0033 -0.0046 -0.0005;
];

% Combine all values into one vector
combined_normal_values = normal_values(:);
combined_apnea_values = apnea_values(:);

% Calculate the mean of combined values
mean_combined_normal = mean(combined_normal_values);
mean_combined_apnea = mean(combined_apnea_values);

% Determine the general threshold between normal and apnea
prag_medie = (mean_combined_normal + mean_combined_apnea) / 2;
prag_medie = 0.003;
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
