%{
#include "synt.tab.h"
extern nb_ligne;
extern YYSTYPE yylval;
#include "fonctions.h"

%}
lettres [a-zA-Z]
chiffres [0-9]
constante {chiffres}+
idf "$"{lettres}({lettres}|{chiffres}|_)*
idf_tab "@"{lettres}({lettres}|{chiffres}|_)*
chaine ({lettres}|{chiffres})+
entier (-|\+){chiffres}+
reel [-+]?{chiffres}+","{chiffres}+
%%
import return mc_import;
ISIL.io return bib_io;
ISIL.lang return bib_lang;
public return mc_public;
private return mc_private;
protected return mc_protected;
class return mc_class;
Entier {  yylval.str=strdup("Entier");
		  return mc_entier;
		  }
Reel  {  yylval.str=strdup("Reel");
               return mc_reel;
	   }
Chaine { yylval.str=strdup("Chaine");
          return mc_chaine;
		  }
{idf} {  inserer(yytext, "idf");
         yylval.str=strdup(yytext);
         return idf;
		}
{idf_tab} {yylval.str=strdup(yytext);
            return idf_tab;
			}
{constante} {  yylval.entier=atoi(yytext);
               return cst;}
"[" return cr_ov;
"]" return cr_fr;
"," return vrg;
"{" return aco_ov;
"}" return aco_fr;
"(" return par_ov;
")" return par_fr;
"+" return mc_plus;
"-" return mc_mois;
"*" return mc_mul;
"/" return mc_div;
"==" return mc_egal;
">" return mc_sup;
">=" return mc_supEgal;
"<" return mc_inf;
"<=" return mc_infEgal;
"!=" return mc_diff;
"++" return mc_incrmnt;
"##".*"##" 
\" return mc_quot;
; return pvg;
CONST return mc_const;
:= return mc_affectation;
{entier} {  yylval.entier=atoi(yytext);
            return val_entier;}
{reel} return val_reel;
main return mc_main;
for return mc_for;
In return mc_in;
Out return mc_out;
"%d" return formatage_entier;
"%f" return formatage_reel;
"%s" return formatage_chaine;
{chaine} { yylval.str=strdup(yytext);
          return val_chaine;
		  }
[ \t] 
[\n] nb_ligne++;
. {printf("erreur lexicale a ligne %d sur l'entite %s\n",nb_ligne,yytext);
   return err;  }
