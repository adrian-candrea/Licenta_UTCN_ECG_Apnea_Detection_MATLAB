% Valoarea de clasificare dintre cazurile normale si cele cu apne
prag = 5;

% Definire matrice pentru fiecare persoana
subiect_a01_normal = [
    0 0 0 1 0 0 0 0 0 1 0 0 1;
    0 1 0 0 0 0 0 0 0 1 0 0 0;
    0 0 0 1 0 0 0 0 0 1 0 0 0;
    0 0 0 1 0 0 0 0 0 1 0 0 1;
    0 0 0 1 0 0 0 0 0 1 0 0 0;
];

subiect_a01_apnea = [
    0 0 1 0 0 1 0 0 1 1 1 0 0;
    0 0 1 0 1 0 0 0 0 1 0 1 1;
    0 0 0 1 0 0 0 0 1 1 1 1 1;
    0 0 1 1 0 0 0 0 1 1 1 1 0;
    0 0 1 1 0 0 1 0 1 1 1 1 1;
];

subiect_a07_normal = [ 
    1 1 0 0 1 0 0 1 0 0 0 0 0; 
    1 1 0 1 1 0 0 1 0 0 0 0 0; 
    0 1 0 0 1 0 0 1 0 0 0 0 0; 
    0 1 0 0 1 0 0 1 0 0 0 0 1; 
    0 1 0 0 1 0 0 1 0 0 0 0 0; 
]; 

subiect_a07_apnea = [ 
    1 1 0 1 1 1 0 1 1 1 1 1 1; 
    1 1 0 1 1 1 0 1 0 1 0 0 1; 
    1 1 0 0 1 0 0 1 0 1 0 0 1; 
    1 1 0 1 1 1 0 1 0 1 0 0 1; 
    1 1 0 1 1 1 0 1 1 1 0 1 1; 
];

subiect_a13_normal = [ 
    1 0 0 0 1 0 0 0 0 0 0 0 0; 
    1 1 0 0 1 0 0 1 0 0 0 0 0; 
    1 0 0 0 1 0 0 0 0 0 0 0 1; 
    1 0 0 0 1 0 0 0 0 0 0 0 0; 
    1 0 0 0 1 0 0 0 0 0 0 0 0; 
]; 
 
subiect_a13_apnea = [ 
    1 1 1 0 1 1 0 1 1 1 1 0 0; 
    1 1 0 0 1 1 0 1 1 1 1 0 0; 
    1 1 0 0 1 1 0 1 0 0 0 0 1; 
    1 1 0 1 1 1 0 1 0 1 0 0 0; 
    1 1 0 0 1 1 0 1 1 1 1 0 0; 
];

subiect_a14_normal = [ 
    0 0 1 1 0 0 0 0 1 1 1 1 1; 
    0 0 1 1 0 1 0 0 0 1 0 0 0; 
    0 0 1 1 0 0 0 0 0 1 0 0 0; 
    0 0 1 1 0 0 0 0 1 1 1 1 0; 
    0 0 0 1 0 1 0 0 0 1 0 1 1; 
]; 
 
subiect_a14_apnea = [ 
    0 0 1 1 0 0 1 0 1 1 1 1 1; 
    0 0 1 1 0 1 1 0 1 1 1 1 0; 
    0 0 1 1 0 1 1 0 1 1 1 1 1; 
    0 0 1 1 0 1 1 0 1 1 1 1 1; 
    1 0 1 1 0 0 0 0 1 1 1 1 1; 
];

subiect_a19_normal = [ 
    0 0 1 0 0 1 0 0 0 0 0 0 0; 
    0 0 1 0 0 1 0 0 0 0 0 0 1; 
    0 0 1 0 0 1 0 0 0 0 0 0 1; 
    0 0 1 0 0 1 0 0 0 0 0 0 1; 
    0 0 1 0 0 1 0 0 0 0 0 0 0; 
]; 
 
subiect_a19_apnea = [ 
    1 0 1 0 0 1 0 1 0 0 0 0 0; 
    1 0 1 0 0 1 0 0 0 0 0 0 0 ; 
    1 0 1 0 0 1 0 0 0 0 0 0 1; 
    1 0 1 0 0 1 0 1 0 0 0 0 0; 
    1 0 1 0 0 1 0 1 0 0 0 0 1; 
];

% stocare nume si matrici
data = {
    'Subiect_a01_Normal', subiect_a01_normal;
    'Subiect_a01_Apnea', subiect_a01_apnea;

    'Subiect_a07_Normal', subiect_a07_normal;
    'Subiect_a07_Apnea', subiect_a07_apnea;

    'Subiect_a13_Normal', subiect_a13_normal;
    'Subiect_a13_Apnea', subiect_a13_apnea;
    
    'Subiect_a14_Normal', subiect_a14_normal;
    'Subiect_a14_Apnea', subiect_a14_apnea;

    'Subiect_a19_Normal', subiect_a19_normal;
    'Subiect_a19_Apnea', subiect_a19_apnea;
};


for i = 1:size(data, 1)
    denumire = data{i, 1}; 
    sir = data{i, 2}; 
    
    % numaratoare in cadrul sirului
    for rand = 1:size(sir, 1)
        k = sum(sir(rand, :) == 1); % numaratoare cazuri apnee per esantion
        
        %Determinare rezultat
        if k >= prag
            classification = 'Apnea';
        else
            classification = 'Normal';
        end
        
        % Afisare Rezultat
        disp([denumire, ' esantion ', num2str(rand), ' Detectie: ', classification]);
    end
    disp(' ');
end
