% This program is for the random generation of 'Numerical Computing' exams.
% The user is supposed to give the number of:
%    - topics
%    - questions that exist in the database for each topic
%    - questions that should be chosen for each exam prepared.
% The prepared exam will be in LaTeX format.

rand('state',sum(100*clock));   % reset the random number generator to a different state each time
nt=input('Quanti capitoli? ');  % no of topics
numexercises=zeros(nt,1);       % array for holding the number of questions in each topic
disp('Quando ci sono solo 4 gruppi di compiti/teoria, questi gruppi sono:');
disp('1  aritmetica finita (af) 16');
disp('2  sistemi lineari (sl) 24');
disp('3  equazioni non lineari (nl) 11');
disp('4  interpolazione e approssimazione (ia) 14');
for i=1:nt
    exercise_s=['Quanti compiti ci sono sul capitolo ' int2str(i) '? '];
    numexercises(i)=input(exercise_s);
end
% we do not include theory questions in this version!!!
% ndt=input('Quanti sotto gruppi di teoria ci sono? '); % how many different groups of theory questions 
% dt_a=zeros(ndt,1);            % array for holding the number of questions in each theory sub-group
% for i=1:nt
%     dt_s=['Quanti domande ci sono in gruppo ' int2str(i) '? '];
%     dt_a(i)=input(dt_s);
% end
nexam=input('Quanti compiti si deve creare? '); % the number of different exam papers to generate
date=input('Dato del esame (ggmmaa): ','s'); % the date of the exam, in string format
date_s=int2str(date);
fid=fopen('examdate.tex','w');

% add more exercises
    
new_ex=input('Quanti esercizi da aggiungere? ');

for j=1:nexam
    exercises_array=zeros(nt,1);
    for i=1:nt
        exercises_array(i)=ceil(numexercises(i)*rand); % for each topic choose which exercise at random
    end
%    domande_s=zeros(2,1);  % need to choose two different theory topics first
%    domande_s(1)=ceil(ndt*rand);
%    domande_s(2)=ceil(ndt*rand);
%    while domande_s(1)==domande_s(2)
%        domande_s(2)=ceil(ndt*rand);
%    end
%    theory_array=zeros(2,1);
%    for i=1:2
%        tmp=dt_a(domande_s(i));
%        theory_array(i)=ceil(tmp*rand);  % choose which question to ask for each theory group chosen, at random
%    end    
    
% Now we know which questions/exercises will be in this exam.
% We should begin forming the exam paper and the solution paper for the exam paper under question.
    
% First create the file 'examdate.tex', which include the 'letter' of 'compito' and the 'date' of the exam.

    examletter=chooseletter(j);
    filename=['examdate_' examletter '.tex'];
    fid=fopen(filename,'w');
    day=str2num(date(1:2));
    month=str2num(date(3:4));
    year=2000+str2num(date(5:6));
    new_month=write_month(month);
    fprintf(fid,'\\centerline{\\large {\\bf CALCOLO NUMERICO--%s }} \n',examletter);
    fprintf(fid,'\\centerline{Compito del %d %s %d } \n',day,new_month,year);
    fprintf(fid,'\\centerline{Tempo concesso: 1 ora e mezzo} \n');
    fclose(fid);
% Begin creating the exam paper; make a random ordering of exercises, i.e., each exam paper generated should have a different order
% of topics
% We assume that the topics have the following order:
%    1  aritmetica finita (af)
%    2  sistemi non lineari (nl)
%    3  sistemi lineari (sl)
%    4  interpolazione e approssimazione (ia)
 
% While creating the exam papers create their solution keys also at the same time!

    permuted_exercises=randperm(nt);                % the permuted order of exercises
    compito_file=[date '_' examletter '.tex'];
    fid_c=fopen(compito_file,'w');
    examdate_j=filename(1:10);
    fprintf(fid_c,'\\input{exam_header} \n');       % initialize the exam file
    fprintf(fid_c,'\\input{%s} \n',examdate_j);
    fprintf(fid_c,'\\bigskip \n\n');
    fprintf(fid_c,'\\noindent \n');
    
    solutions_file=['r_' compito_file];             % initialize the solutions file
    fid_r=fopen(solutions_file,'w');
    fprintf(fid_r,'\\input{solution_header} \n');
    fprintf(fid_r,'\\centerline{\\large {\\bf CALCOLO NUMERICO--%s }} \n',examletter);
    fprintf(fid_r,'\\centerline{Compito del %d %s %d } \n',day,new_month,year);
    
    for k=1:nt
        kk=num2str(k);
        fprintf(fid_c,'{\\bf Esercizio %s: } \n',kk);
        current_topic=permuted_exercises(k);          % which topic?
        current_ex=exercises_array(current_topic);    % which exercise of that topic?
        ex_file=[file_names(current_topic) num2str(current_ex)];
        fprintf(fid_c,'\\input{%s} \n',ex_file);
        if mod(k,2)==1
            fprintf(fid_c,'\\bigskip \n\n');
            fprintf(fid_c,'\\noindent \n');
        else
       %     fprintf(fid_c,'\\newpage \n');
            fprintf(fid_c,'\\noindent \n');
        end
        r_file=['r_' ex_file];                         % write the solution in solutions file
        fprintf(fid_r,'\\noindent \n');
        fprintf(fid_r,'{\\bf Esercizio %s: } \n',kk);
        fprintf(fid_r,'\\input{%s} \n',r_file);
        fprintf(fid_r,'\\medskip \n');
    end
    
    % generate at random new_ex exercises; first choose from which
    % arguments to take these new exercises
    
    % new_arguments_array=zeros(new_ex,1);
    % new_arguments_array(1)=ceil(nt*rand);
    
    % add a new exercise from group 2 or 4 depending on the 'compito'
    % 'letter'
    
    new_arguments_array=zeros(new_ex,1);
    if mod(j,2)==0 
        new_arguments_array(1)=2;
    else       
        new_arguments_array(1)=4;
    end        
    for i=2:new_ex
        k=ceil(nt*rand);
        not_there=0;
        while not_there < (i-1)
            for jj=1:i-1
                if k ~= new_arguments_array(jj)
                    not_there=not_there+1;
                end
            end
            if not_there < (i-1)
                k=ceil(nt*rand);
            end
        end
        new_arguments_array(i)=k;
    end
    
    % now choose exercises from the new arguments; control that these
    % exercises have not been already chosen!
    
    for i=1:new_ex
        current_ex=ceil(numexercises(new_arguments_array(i))*rand); % for each topic choose which exercise at random
        if current_ex==exercises_array(new_arguments_array(i))
            while current_ex==exercises_array(new_arguments_array(i))
                current_ex=ceil(numexercises(new_arguments_array(i))*rand);
            end
        end
        
        % write this new exercise on the exam paper
        
        k=nt+i;      % the number of the current exercise on the exam paper
        kk=num2str(k);
        fprintf(fid_c,'{\\bf Esercizio %s: } \n',kk);
        current_topic=new_arguments_array(i);          % which topic?
                                                       % current_ex is the
                                                       % exercise of the
                                                       % chosen topic
        ex_file=[file_names(current_topic) num2str(current_ex)];
        fprintf(fid_c,'\\input{%s} \n',ex_file);
        if mod(i,2)==1
            fprintf(fid_c,'\\bigskip \n\n');
            fprintf(fid_c,'\\noindent \n');
        else
        %    fprintf(fid_c,'\\newpage \n');
            fprintf(fid_c,'\\noindent \n');
        end
        r_file=['r_' ex_file];                         % write the solution in solutions file
        fprintf(fid_r,'\\noindent \n');
        fprintf(fid_r,'{\\bf Esercizio %s: } \n',kk);
        fprintf(fid_r,'\\input{%s} \n',r_file);
        fprintf(fid_r,'\\medskip \n');
    end
    % if mod(i,2)==1   % make a newpage before the theory questions
       % fprintf(fid_c,'\\newpage \n');
      %  fprintf(fid_c,'\\noindent \n');
    % end
    fprintf(fid_r,'\\end{document} \n');
    fclose(fid_r);
    
% Now write the theory questions    

    % for k=1:2
%         kk=num2str(k);
%         current_topic=10+domande_s(k);
%         dom_file=[file_names(current_topic) num2str(theory_array(k))];
%         fprintf(fid_c,'{\\bf Domanda %s: } \n',kk);
%         fprintf(fid_c,'\\input{%s} \n',dom_file);
%         if k==1
       %    fprintf(fid_c,'\\newpage \n');
%           fprintf(fid_c,'\\noindent \n');
%        end           
%     end
    fprintf(fid_c,'\\end{document} \n');
    fclose(fid_c);
end    
