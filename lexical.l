%{
#include "synt.tab.h"
int nb_ligne=1;
%}
lettres [a-zA-Z]
chiffres [0-9]
idf "$"{lettres}({lettres}|{chiffres}|_)*
idf_tab "@"{lettres}({lettres}|{chiffres}|_)*
chaine \"({lettres}|{chiffres})+\"
entier (-|\+){chiffres}+
reel (-|\+){chiffres}+,{chiffres}+
operation [+\-*\/]
%%
import return mc_import;
ISIL.io return bib_io;
ISIL.lang return bib_lang;
public return mc_public;
private return mc_private;
protected return mc_protected;
class return mc_class;
Entier return mc_entier;
Reel return mc_reel;
Chaine return mc_chaine;
{idf} return idf;
{idf_tab} return idf_tab;
{chiffres} return cst;
"[" return cr_ov;
"]" return cr_fr;
"," return vrg;
"{" return aco_ov;
"}" return aco_fr;
"(" return par_ov;
")" return par_fr;
{operation} return mc_operation;
; return pvg;
CONST return mc_const;
:= return mc_affectation;
{entier} return val_entier;
{chaine} return val_chaine;
{reel} return val_reel;
main return mc_main;
[ \t] 
[\n] nb_ligne++;
. {printf("erreur lexicale a ligne %d sur l'entite %s\n",nb_ligne,yytext);
   return err;  }
