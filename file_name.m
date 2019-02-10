function f_name=file_name(topic)
% Takes in the integer 'topic' and returns the relevant file prefix string
% If topic is > 10, we assume it is theory
switch (topic)
   case 1, f_name='af_';
   case 2, f_name='sl_';
   case 3, f_name='nl_';
   case 4, f_name='ia_';
   case 5, f_name='sli_';
   case 6, f_name='mat_';
   case 11, f_name='taf_';
   case 12, f_name='tsl_';
   case 13, f_name='tnl_';
   case 14, f_name='tia_';   
   case 15, f_name='tsli_';
end
