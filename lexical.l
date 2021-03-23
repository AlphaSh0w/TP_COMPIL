%{
#include "synt.tab.h"
extern nb_ligne;
extern YYSTYPE yylval;
extern nb_colonne;
#include "fonctions.h"

%}
lettres [a-zA-Z]
chiffres [0-9]
constante {chiffres}+
idf "$"{lettres}({lettres}|{chiffres}|_)*
idf_tab "@"{lettres}({lettres}|{chiffres}|_)*
chaine ({lettres}|{chiffres})+
entier (-|\+){chiffres}+
reel [-+]?{chiffres}+"."{chiffres}+
%%
import {nb_colonne += yyleng; return mc_import;}
ISIL.io {  yylval.str=strdup("ISIL.io");
          nb_colonne += yyleng;
		  return bib_io;
		  }
ISIL.lang {  yylval.str=strdup("ISIL.lang");
          nb_colonne += yyleng;
		  return bib_lang;
		  }
public {nb_colonne += yyleng; return mc_public;}
private {nb_colonne += yyleng; return mc_private;}
protected {nb_colonne += yyleng; return mc_protected;}
class {nb_colonne += yyleng; return mc_class;}
Entier {  yylval.str=strdup("Entier");
          nb_colonne += yyleng;
		  return mc_entier;
		  }
Reel  {  yylval.str=strdup("Reel");
          nb_colonne += yyleng;
          return mc_reel;
	   }
Chaine { yylval.str=strdup("Chaine");
          nb_colonne += yyleng;
          return mc_chaine;
		  }
{idf} {  inserer(yytext, "idf");
         yylval.str=strdup(yytext);
         nb_colonne += yyleng;
         return idf;
		}
{idf_tab} { inserer(yytext,"idf_tab");
            yylval.str=strdup(yytext);
            nb_colonne += yyleng;
            return idf_tab;
			}
{constante} {  yylval.entier=atoi(yytext);
               nb_colonne += yyleng;
               return cst;}
"[" {nb_colonne += yyleng; return cr_ov;}
"]" {nb_colonne += yyleng; return cr_fr;}
"," {nb_colonne += yyleng; return vrg;}
"{" {nb_colonne += yyleng; return aco_ov;}
"}" {nb_colonne += yyleng; return aco_fr;}
"(" {nb_colonne += yyleng; return par_ov;}
")" {nb_colonne += yyleng; return par_fr;}
"+" {nb_colonne += yyleng; return mc_plus;}
"-" {nb_colonne += yyleng; return mc_mois;}
"*" {nb_colonne += yyleng; return mc_mul;}
"/" {yylval.str=strdup(yytext);
            nb_colonne += yyleng;
            return mc_div;}
"==" {nb_colonne += yyleng; return mc_egal;}
">" {nb_colonne += yyleng; return mc_sup;}
">=" {nb_colonne += yyleng; return mc_supEgal;}
"<" {nb_colonne += yyleng; return mc_inf;}
"<=" {nb_colonne += yyleng; return mc_infEgal;}
"!=" {nb_colonne += yyleng; return mc_diff;}
"++" {nb_colonne += yyleng; return mc_incrmnt;}
"##".*"##" 
\" {nb_colonne += yyleng; return mc_quot;}
; {nb_colonne += yyleng; return pvg;}
CONST {nb_colonne += yyleng; return mc_const;}
:= {nb_colonne += yyleng; return mc_affectation;}
{entier} {  yylval.entier=atoi(yytext);
            nb_colonne += yyleng;
            return val_entier;}
{reel} {  yylval.reel=atof(yytext);
            nb_colonne += yyleng;
            return val_reel;}
main {nb_colonne += yyleng; return mc_main;}
for {nb_colonne += yyleng; return mc_for;}
In {nb_colonne += yyleng; return mc_in;}
Out {nb_colonne += yyleng; return mc_out;}
"%d" {nb_colonne += yyleng; return formatage_entier;}
"%f" {nb_colonne += yyleng; return formatage_reel;}
"%s" {nb_colonne += yyleng; return formatage_chaine;}
{chaine} { yylval.str=strdup(yytext);
            nb_colonne += yyleng;
            return val_chaine;
		    }
[ ] {nb_colonne += yyleng;}
[\t] {nb_colonne += yyleng;}
[\n] {nb_colonne = 1; nb_ligne++;}
. {printf("erreur lexicale a ligne %d colonne %d sur l'entite %s\n",nb_ligne,nb_colonne,yytext);
   return err;  }

