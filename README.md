# Licenta_UTCN_ECG_Apnea_Detection_MATLAB
 Proiect de Diplomă Nivel Licență - Tehnici de detectare a evenimentelor de apnee bazate pe analiza  semnalului ECG - Media 9.20 - MATLAB

 ## Context
 Proiect nivel licență 
    - Creat în anul 2024 (aprilie-iulie) 
    - Prezentat la Universitstea Tehnică din Cluj-Napoca (UTCN), Facultatea de Electronică, Telecomunicații și Tehnologia Informației
    - Promoția 2020-2024

 ### Descriere
 Acest proiect utilizează tehnici de procesare a semnalului ECG pentru detectarea episoadelor de apnee.
 Proiectul utilizaează 
    - algoritmi pentru detectarea undelor PQRST
        - Algoritmul Pan-Tompkins (FTB, Derviare, Squaring, Integration)
    - calcularea unor parmaetrii relevanți: 
        - intervale RR,QRS,PR 
        - Heart Rate
        - Puterea Totală 
        - SDNN  (Standard Deviation of Normal-to-Normal Intervals) 
        - RMSSD (Root Mean Square of Successive Differences) 
        - NEP   (Number of Extreme Points)
    - clasificarea episoadelor de apnee
 - bază de date semnale folosite: PhysioNet

 #### Structura Proiectului
    1. Main_Code.m
        - Codul principal MATLAB care implementează procesarea semnalelor ECG și determinarea parametriclor care să arate apariția sindromului de apnee
    2. Determinare_Praguri
        - Scripturi MATLAB auxiliare folosite pentru a calcula pragurile necesare pentru a clasifica dacă un semnal are sau nu sindrom de apnee
    3. Documentation
        - Lucrarea de licență în format PDF ce detaliată care conține partea de metodologie, rezultate și concluzii


