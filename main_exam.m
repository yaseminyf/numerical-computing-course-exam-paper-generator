% This program is for the random generation of 'Numerical Computing' exams.
% The user is supposed to give the number of:
%    
%    - questions that exist in the database for each topic
%    - questions that should be chosen for each exam prepared.
% The prepared exam will be in LaTeX format.

rand('state',sum(100*clock));   % reset the random number generator to a different state each time

% nt=input('Quanti capitoli? ');  % no of topics

nt=6;  % number of topics is fixed to 6! 5 topics + Matlab
numexercises=zeros(nt,1);       % array for holding the number of questions in each topic
disp('I 5 capitoli di esercizi/teoria sono:');
disp('1  aritmetica finita (af) (8 esercizi - 7 domande di teoria)');
disp('2  sistemi lineari (sl) (31 esercizi - 9 domande di teoria)');
disp('3  equazioni non lineari (nl) (24 esercizi - 6 domande di teoria)');
disp('4  interpolazione e approssimazione (ia) (23 esercizi - 10 domande di teoria)');
disp('5  metodi iterativi (sli) (7 esercizi - 5 domande di teoria)');
disp('6  Poi abbiamo Matlab (mat) (senza domande di teoria di Matlab - solo 15 esercizi');

% We should ask how many exercises there are in each topic since new
% exercises can be added to the database any time

for i=1:nt
    exercise_s=['Quanti esercizi in totale ci sono sul capitolo ' int2str(i) '? '];
    numexercises(i)=input(exercise_s);
end

% ndt=input('Quanti sotto gruppi di teoria ci sono? '); % how many different groups of theory questions % the answer is: 5 

ndt=5;                        % number of topics for theory questions; fixed to 5
dt_a=zeros(ndt,1);            % array for holding the number of questions in each theory sub-group
for i=1:ndt
    dt_s=['Quanti domande di teoria ci sono in gruppo ' int2str(i) '? '];
    dt_a(i)=input(dt_s);
end

nexam=input('Quanti diversi compiti si deve creare? '); % the number of different exam papers to generate
separate=input('Due esami separati (il primo solo di esercizi, il secondo di domande e Matlab)? (Y/N)','s');
if separate=='n' || separate=='N'
    date=input('Dato del esame (ggmmaa): ','s'); % the date of the exam, in string format
else
    date1=input('Dato del primo esame (ggmmaa): ','s'); % the date of the exam, in string format
    date2=input('Dato del secondo esame (ggmmaa): ','s'); % the date of the exam, in string format
        
end
for j=1:nexam
    % we need to choose 3 topics out of 5 topics first
    
    topics_array=zeros(3,1);
    topics_array(1)=ceil(5*rand);
    topics_array(2)=ceil(5*rand);
    while topics_array(2)==topics_array(1)
        topics_array(2)=ceil(5*rand);
    end
    topics_array(3)=ceil(5*rand);
    while topics_array(3)==topics_array(2) || topics_array(3)==topics_array(1)
        topics_array(3)=ceil(5*rand);
    end
    
    % topics are chosen, now we should choose the exercises
    
    exercises_array=zeros(3,1);
    for i=1:3
        exercises_array(i)=ceil(numexercises(topics_array(i))*rand); % for each topic choose which exercise at random
    end
    domande_s=zeros(2,1);           % need to choose two different theory topics out of 5
    domande_s(1)=ceil(ndt*rand);
    domande_s(2)=ceil(ndt*rand);
    while domande_s(1)==domande_s(2)
        domande_s(2)=ceil(ndt*rand);
    end
    theory_array=zeros(2,1);
    for i=1:2
        tmp=dt_a(domande_s(i));
        theory_array(i)=ceil(tmp*rand);  % choose which question to ask for each theory group chosen, at random
    end    
    
    % we should choose one Matlab exercise as well
    
    matlab_exercise=ceil(numexercises(6)*rand);
    
% Now we know which questions/exercises will be in this exam.
% We should begin forming the exam paper.
  
    examletter=chooseletter(j);
    if separate=='n' || separate=='N'
       day=str2num(date(1:2));
       month=str2num(date(3:4));
       year=2000+str2num(date(5:6));
       compito_file=[date '_' examletter '.tex'];
    else
       day=str2num(date1(1:2));
       month=str2num(date1(3:4));
       year=2000+str2num(date1(5:6)); 
       compito_file=[date1 '_' examletter '.tex'];
    end   
    new_month=write_month(month);
    
    fid_c=fopen(compito_file,'w');
    fprintf(fid_c,'\\input{exam_header} \n');       % initialize the exam file with the header lines
    
    fprintf(fid_c,'\\centerline{\\large {\\bf CALCOLO NUMERICO -- %s }} \n',examletter);
    fprintf(fid_c,'\\centerline{Compito del %d %s %d } \n',day,new_month,year);
    if separate=='n' || separate=='N'
        fprintf(fid_c,'\\centerline{Tempo concesso: 2 ore} \n');
    else
        fprintf(fid_c,'\\centerline{Tempo concesso: 1 ora e 15 minuti} \n');
    end
    fprintf(fid_c,'\\bigskip \n\n');
    fprintf(fid_c,'\\noindent \n');
    
% write the exercises in the exam paper
    
    for k=1:3
        kk=num2str(k);
        fprintf(fid_c,'{\\bf Esercizio %s: (7pt)} \n',kk);
        current_topic=topics_array(k);          % which topic?
        current_ex=exercises_array(k);    % which exercise of that topic?
        ex_file=[file_name(current_topic) num2str(current_ex)];
        fprintf(fid_c,'\\input{%s} \n',ex_file);
     
        fprintf(fid_c,'\\bigskip \n\n');
        fprintf(fid_c,'\\noindent \n');
    end
    
    if separate=='y' || separate=='Y'
        fprintf(fid_c,'\\end{document} \n');
        fclose(fid_c);
        
        % Create and open the exam paper for the second day
       
        day=str2num(date2(1:2));
        month=str2num(date2(3:4));
        year=2000+str2num(date2(5:6)); 
        compito_file=[date2 '_' examletter '.tex'];
        
        new_month=write_month(month);
    
        fid_c=fopen(compito_file,'w');
        fprintf(fid_c,'\\input{exam_header} \n');       % initialize the exam file with the header lines
    
        fprintf(fid_c,'\\centerline{\\large {\\bf CALCOLO NUMERICO--%s }} \n',examletter);
        fprintf(fid_c,'\\centerline{Compito del %d %s %d } \n',day,new_month,year);
        fprintf(fid_c,'\\centerline{Tempo concesso: 45 minuti} \n');
        fprintf(fid_c,'\\bigskip \n\n');
        fprintf(fid_c,'\\noindent \n');
    end
        
        
% Now write the theory questions    

    for k=1:2
        kk=num2str(k);
        current_topic=10+domande_s(k);
        dom_file=[file_name(current_topic) num2str(theory_array(k))];
        fprintf(fid_c,'{\\bf Domanda %s: (3pt)} \n',kk);
        fprintf(fid_c,'\\input{%s} \n',dom_file);
 
        fprintf(fid_c,'\\bigskip \n\n');
        fprintf(fid_c,'\\noindent \n');          
    end
    
% Write the Matlab exercise.

    fprintf(fid_c,'{\\bf Esercizio di Matlab: (3pt)} \n');
    ex_file=[file_name(6) num2str(matlab_exercise)];
    fprintf(fid_c,'\\input{%s} \n',ex_file);
    
% Finish writing the exam paper; close file.
    
    fprintf(fid_c,'\\end{document} \n');
    fclose(fid_c);
end    
