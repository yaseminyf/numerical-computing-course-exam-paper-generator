function f_names=files_name(topic)
% Takes in the integer 'topic' and returns the relevant file prefix string
% If topic is > 10, we assume it is theory
switch (topic)
   case 1, f_names='afs_';
   case 2, f_names='sls_';
   case 3, f_names='nls_';
   case 4, f_names='ias_';
   case 11, f_names='taf_';
   case 12, f_names='tsl_';
   case 13, f_names='tnl_';
   case 14, f_names='tia_';    
end
