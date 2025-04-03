%     UNDA R
normal_values = [
    0.6037 0.611 0.6057 0.5778 0.5801;
    0.7411 0.7458 0.729 0.7111 0.7253;
    0.7412 0.7631 0.742 0.7363 0.74565;
    0.6341 0.6256 0.6376 0.6326 0.628;
    0.7223 0.7216 0.7071 0.7126 0.7159;
];

apnea_values = [
    0.6508 0.6557 0.6533 0.6625 0.63;
    0.847 0.8364 0.7813 0.77 0.8086;
    0.8577 0.9004 0.8669 0.8942 0.8984;
    0.7126 0.7114 0.7025 0.7103 0.7446;
    0.8524 0.7931 0.8322 0.8821 0.83995;
];

% Combină toate valorile intr-un singur vector
combined_normal_values = normal_values(:);
combined_apnea_values = apnea_values(:);

% calcul media valori normale si cu apnee
mean_combined_normal = mean(combined_normal_values);
mean_combined_apnea = mean(combined_apnea_values);

% Determinare Prag General
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



%disp('Classifying normal values:');
%for i = 1:size(normal_values, 1)
%    person_data = normal_values(i, :);
%    r_peak = person_data(3);
%
%    if r_peak > prag_medie
%        disp(['Person ', num2str(i), ': Apnea']);
%    else
%        disp(['Person ', num2str(i), ': Normal']);
%    end
%end

% Classify apnea values based on the threshold
%disp('Classifying apnea values:');
%for i = 1:size(apnea_values, 1)
%    person_data = apnea_values(i, :);
%    r_peak = person_data(3);
%

%    if r_peak > prag_medie
%        disp(['Person ', num2str(i), ': Apnea']);
%    else
%        disp(['Person ', num2str(i), ': Normal']);
%    end
%end
