An unsusual transpose based on groups of variable names

Recent better solution
see Arthur Tabachneck simple solution on end

see stackoverflow or below
https://stackoverflow.com/questions/51972063/wide-to-long-dataset-in-sas

Arts contact
art@analystfinder.com
https://stackoverflow.com/users/10277606/arthur-tabachneck

Original solution

github
https://tinyurl.com/ybp99c72
https://github.com/rogerjdeangelis/utl_an_unsusual_transpose_based_on__groups_of_variable_names

Stackoverflow
https://stackoverflow.com/questions/51972063/wide-to-long-dataset-in-sas

nice solution by
https://stackoverflow.com/users/108797/chris-j

INPUT
=====

 WORK.HAVE total obs=2

            VAR1_    VAR1_    VAR1_    VAR2_    VAR2_    VAR2_
  USERID    2008     2009     2010     2008     2009     2010     RACE

    1         Y        N        Y       20       30       20       1
    2         N        N        N       15       30       35       0


EXAMPLE OUTPUT
==============
                                           | RULES
 WORK.WANT total obs=6                     |
                                           |
  USERID    RACE    YEAR    VAR1    VAR2   | Transpose by user_id race and
                                           | append var1 and var variables by group
    1        1      2008     Y       20    |
    1        1      2009     N       30    |
    1        1      2010     Y       20    |
                                           |
    2        0      2008     N       15    |
    2        0      2009     N       30    |
    2        0      2010     N       35    |


PROCESS
=======

data want ;
  set have ;
  retain year userid var1 var2 race;

  /* Need two arrays, as one is character, the other numeric */
  array v1{*} var1_: ; /* wildcard all 'var1_'-prefixed variables */
  array v2{*} var2_: ; /* same for var2_ */

  /* loop along v1 array */
  do i = 1 to dim(v1) ;
    /* use vname function to get variable name associated to this array element */
    year = input(scan(vname(v1{i}),-1,'_'),8.) ;
    var1 = v1{i} ;
    var2 = v2{i} ;
    drop var1_: var2_:;
    output ;
  end ;

  drop i ;
run ; quit ;


OUTPUT
======

 WORK.WANT total obs=6

  USERID    RACE    YEAR    VAR1    VAR2

    1        1      2008     Y       20
    1        1      2009     N       30
    1        1      2010     Y       20

    2        0      2008     N       15
    2        0      2009     N       30
    2        0      2010     N       35

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
 input (UserID Var1_2008 Var1_2009 Var1_2010 Var2_2008 Var2_2009 Var2_2010 Race) ($);
cards4;
 1 Y N Y 20 30 20 1
 2 N N N 15 30 35 0
;;;;
run;quit;


*   _         _
   / \   _ __| |_
  / _ \ | '__| __|
 / ___ \| |  | |_
/_/   \_\_|   \__|

;

data have;
 input (UserID Var1_2008 Var1_2009 Var1_2010 Var2_2008 Var2_2009 Var2_2010 Race) ($);
cards4;
 1 Y N Y 20 30 20 1
 2 N N N 15 30 35 0
;;;;
run;quit;

%untranspose(data=have, out=want, by=UserID, id=year, delimiter=_,
   var=Var1 Var2, copy=Race)


If you don't have it, you should, see below
https://tinyurl.com/ydbqcqmt
filename ut url 'https://raw.githubusercontent.com/FriedEgg/Papers/master/An_Easier_and_Faster_Way_to_Untranspose_a_Wide_File/src/untranspose.sas';


Up to 40 obs from WANT total obs=6

Obs    USERID    RACE    YEAR    VAR1    VAR2

 1       1        1      2008     Y       20
 2       1        1      2009     N       30
 3       1        1      2010     Y       20
 4       2        0      2008     N       15
 5       2        0      2009     N       30
 6       2        0      2010     N       35



