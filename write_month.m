function n_month=write_month(mmonth)
% Takes an integer and returns the corresponding month in Italian.

switch (mmonth)
   case 1, n_month='gennaio';
   case 2, n_month='febbraio';
   case 3, n_month='marzo';
   case 4, n_month='aprile';
   case 5, n_month='maggio';
   case 6, n_month='giugno';
   case 7, n_month='luglio';
   case 8, n_month='agosto';
   case 9, n_month='settembre';
   case 10, n_month='ottobre';
   case 11, n_month='novembre';
   case 12, n_month='dicembre';
end
