%{
int nb_ligne=1;
char sauvType[20];
char tempValeur[100];
%}

%union {
int     entier;
char*   str;
float   reel;
}

%token mc_import pvg bib_io bib_lang err mc_public 
       mc_private mc_protected mc_class <str>idf aco_ov aco_fr
	   <str>mc_entier <str>mc_reel <str>mc_chaine vrg <str>idf_tab cr_ov cr_fr
	   <entier>cst mc_const mc_affectation <entier>val_entier <str>val_chaine <reel>val_reel
       mc_main par_ov par_fr mc_for
       mc_egal mc_sup mc_supEgal mc_inf mc_infEgal mc_diff mc_incrmnt
       mc_in mc_out mc_quot formatage_entier formatage_reel formatage_chaine
        mc_plus mc_mois mc_mul mc_div

%%
S: LISTE_BIB HEADER_CLASS aco_ov CORPS aco_fr{printf("\npgm syntaxiquement correcte"); 
               YYACCEPT;        }
;

HEADER_CLASS:MODIFICATEUR mc_class idf
;
MODIFICATEUR:   mc_public
                |mc_private
	        |mc_protected
			 ;
CORPS:LISTE_DEC MAIN
;
LISTE_DEC: DEC LISTE_DEC
          |
;
MAIN: mc_main par_ov par_fr aco_ov LISTE_INSTRU aco_fr
;
LISTE_INSTRU: INSTRU LISTE_INSTRU 
            |
;
INSTRU: INSTRU_AFFECTATION 
        | INSTRU_FOR 
        | INSTRU_LECTURE
         | INSTRU_ECRITURE
;
INSTRU_AFFECTATION: idf mc_affectation EXPRESSION pvg {
        if(doubleDeclaration($1) == 0)
                printf("Erreur semantique, %s est un identifiant non declare a la ligne %d\n",$1,nb_ligne);
        if (constValeur($1) == 1)
                printf("\nerreur semantique a la ligne %d, la constante %s elle a deja une valeur\n", nb_ligne, $1);
}
                    |  idf_tab cr_ov cst cr_fr mc_affectation EXPRESSION pvg {
                            if(doubleDeclaration($1) == 0)
                                printf("Erreur semantique, %s est un identifiant de table non declare a la ligne %d\n",$1,nb_ligne);
                    }
;
INSTRU_FOR: mc_for par_ov idf mc_affectation cst pvg idf COMPARAISON OPERAND pvg idf mc_incrmnt par_fr aco_ov LISTE_INSTRU aco_fr
;

INSTRU_LECTURE: mc_in par_ov mc_quot FORMATAGE mc_quot vrg idf par_fr pvg
;
INSTRU_ECRITURE: mc_out par_ov mc_quot SORTIE mc_quot vrg LISTE_IDF par_fr pvg
;
SORTIE:  FORMATAGE SORTIE | val_chaine SORTIE 
            |
;


EXPRESSION: OPERAND OPERATEUR EXPRESSION
           |OPERAND
;

DEC: DEC_VAR
     |DEC_TAB
     |DEC_CONST
;
DEC_VAR: TYPE LISTE_IDF pvg
;
LISTE_IDF: idf vrg LISTE_IDF
{
        if(doubleDeclaration($1)==0)
                insererTYPE($1,sauvType);
	else
		printf("\nerreur semantique: double declaration  de %s a la ligne %d\n",$1,nb_ligne);
}
          |idf
          {
                if (doubleDeclaration($1)==0)
                        insererTYPE($1,sauvType);
		else
			printf("\nerreur semantique: double declaration  de %s a la ligne %d\n",$1,nb_ligne);
          }
;	
DEC_TAB: TYPE LISTE_IDF_TAB pvg
;
LISTE_IDF_TAB: idf_tab cr_ov cst cr_fr vrg LISTE_IDF_TAB 
        {
        if(doubleDeclaration($1)==0) 
                insererTYPE($2,sauvType);
        else
                printf("Erreur semantique: double declaration de la table %s a la ligne %d\n",$2,nb_ligne);
        if ($3<0)
		printf("\nerreur semantique, la taille de tableau %s doit etre positive a la ligne %d\n",$1,nb_ligne);
	}
              |idf_tab cr_ov cst cr_fr  
        { 
        if(doubleDeclaration($1)==0) 
                insererTYPE($2,sauvType);
        else
                printf("Erreur semantique: double declaration de la table %s a la ligne %d\n",$2,nb_ligne);
        if ($3<0)
                printf("\nerreur semantique, la taille de tableau %s doit etre positive a la ligne %d\n",$1,nb_ligne);
	}
;	
DEC_CONST: mc_const TYPE idf pvg {
        if (doubleDeclaration($3)==0){
                insererTYPE($3,sauvType);
                insererConstante($3, "");
        } else 
                printf("\nerreur semantique double declaration  de %s a la ligne %d\n",$3,nb_ligne);
}
            | mc_const TYPE idf mc_affectation VALEUR pvg {
                    if (doubleDeclaration($3)==0){
                                 insererTYPE($3,sauvType);
                                insererConstante($3, tempValeur);
                    } else 
                        printf("\nerreur semantique double declaration  de %s a la ligne %d\n",$3,nb_ligne);
            }
;

VALEUR:val_reel {sprintf(tempValeur, "%f", $1);}
        |val_entier {sprintf(tempValeur, "%d", $1);}
        |mc_quot val_chaine mc_quot {strcpy(tempValeur,$2);}
        |cst {sprintf(tempValeur, "%d", $1);}
;

OPERAND: idf | val_entier | val_reel | cst |mc_quot val_chaine mc_quot
;

OPERATEUR: mc_plus | mc_mois | mc_mul | mc_div
;

FORMATAGE: formatage_entier | formatage_reel | formatage_chaine
;
	  
TYPE: mc_entier {strcpy(sauvType,$1);}
        |mc_reel {strcpy(sauvType,$1);}
        |mc_chaine {strcpy(sauvType,$1);}
;	

COMPARAISON: mc_egal | mc_sup | mc_supEgal | mc_inf | mc_infEgal | mc_diff
;			 
			 
LISTE_BIB: BIB LISTE_BIB
          |
;		  
BIB: mc_import NOM_BIB pvg
;
NOM_BIB:bib_io
         |bib_lang
;		  
%%
main()
{yyparse();
afficher();}
yywrap() {}
yyerror(char*msg)
{
printf("\nerreur syntaxique a la ligne %d\n", nb_ligne);
}
