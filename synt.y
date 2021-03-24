%{
int nb_ligne=1;
int nb_colonne=1;
char sauvType[20];
char tempValeur[100];
char typeValeur[20];
int bibIoExiste = 0;
int bibLangExiste = 0;
char typeFormatage[20];
char sauvOpr[20];
char sauvEntite[50];
char idfGauche[50];
char typesIdfsAffectation[10][10];
int nbrTypesIdfsAffectation = 0;
int sauvConst;
//déclarer les variables qui seront utiliser pour la sémantique des sorties écritures.
int nbFormatagesSortie = 0;
int nbIdfSortie = 0;
//initialiser des tableaux qui seront utilisé pour la sémantique des sorties écritures.
char typesFormatagesEcriture[10][20];
char typesIdfsEcriture[10][20];
%}

%union {
int     entier;
char*   str;
float   reel;
}

%token mc_import pvg <str>bib_io <str>bib_lang err mc_public 
       mc_private mc_protected mc_class <str>idf aco_ov aco_fr
	   <str>mc_entier <str>mc_reel <str>mc_chaine vrg <str>idf_tab cr_ov cr_fr
	   <entier>cst mc_const mc_affectation <entier>val_entier <str>val_chaine <reel>val_reel
       mc_main par_ov par_fr mc_for
       mc_egal mc_sup mc_supEgal mc_inf mc_infEgal mc_diff mc_incrmnt
       mc_in mc_out mc_quot formatage_entier formatage_reel formatage_chaine
        mc_plus mc_mois mc_mul <str>mc_div

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
        strcpy(idfGauche,(char*)$1);
        if (bibLangExiste == 0)
                printf("erreur semantique a la ligne %d, la bibliothèque ISIL.lang est manquante\n",nb_ligne);
        if(doubleDeclaration($1) == 0)
                printf("erreur semantique a la ligne %d, l'identifiant %s n'est pas declaree\n",nb_ligne, $1);
        else
        {
                int i;
                int erreur = 0;
                if(nbrTypesIdfsAffectation != 0)
                {
                        if(nbrTypesIdfsAffectation == 1)
                        {
                                if(strcmp(typesIdfsAffectation[0],(char*)typeEntite(idfGauche)) != 0)
                                {
                                        printf("erreur semantique a la ligne %d, incompatibilite de type.\n",nb_ligne);
                                }
                        }
                }
                nbrTypesIdfsAffectation = 0;
        }
        if (constValeur($1) == 1)
                printf("erreur semantique a la ligne %d, la constante %s a deja une valeur.\n", nb_ligne, $1);
        
}
                    |  idf_tab cr_ov cst cr_fr mc_affectation EXPRESSION pvg {
                        if(doubleDeclaration($1) == 0)
                                printf("erreur semantique a la ligne %d, l'identifiant de table %s n'est pas declaree\n",nb_ligne, $1);
                        if ($3 >= tailleTableau($1))
                                printf("erreur semantique a la ligne %d, depassement de la taille du tableau %s\n",nb_ligne, $1);
                    }
;
INSTRU_FOR: mc_for par_ov idf mc_affectation cst pvg idf COMPARAISON OPERAND pvg idf mc_incrmnt par_fr aco_ov LISTE_INSTRU aco_fr
;

INSTRU_LECTURE: mc_in par_ov mc_quot FORMATAGE mc_quot vrg idf par_fr pvg {
        if (bibIoExiste == 0)
                printf("erreur semantique a la ligne %d, la bibliothèque ISIL.io est manquante\n", nb_ligne);
        
        if (strcmp((char*)typeEntite($7), typeFormatage) != 0)
                printf("erreur semantique a la ligne %d, non compatibilite de formatage de l'idf %s.\n", nb_ligne, $7);
}
;
INSTRU_ECRITURE: mc_out par_ov mc_quot SORTIE mc_quot vrg LISTE_IDF_ECRITURE par_fr pvg {
        if (bibIoExiste == 0)
                printf("erreur semantique a la ligne %d, la bibliothèque ISIL.io est manquante\n", nb_ligne);
        if (nbIdfSortie != nbFormatagesSortie)
                printf("erreur semantique a la ligne %d, le nombre de formatages n'est pas egale au nombre d'idf.\n", nb_ligne);
        else
        {
                //on verifie la compatibilité des types des idfs et des formatages.
                int indexFormatages;
                int indexIdfs = nbIdfSortie - 1;
                for(indexFormatages = 0; indexFormatages < nbIdfSortie; ++indexFormatages,--indexIdfs)
                {
                        if (strcmp(typesFormatagesEcriture[indexFormatages],typesIdfsEcriture[indexIdfs]) != 0)
                        {
                                //L'un des types n'est pas compatible
                                printf("Erreur semantique a la ligne %d, le type de l'idf %d n'est pas compatible avec son formattage.\n",nb_ligne,indexFormatages+1);
                                break;
                        }
                }
        }
        nbIdfSortie = 0;
        nbFormatagesSortie = 0;
}
;
SORTIE:  FORMATAGE_ECRITURE SORTIE 
        | val_chaine SORTIE 
        |
;


EXPRESSION: OPERAND OPERATEUR EXPRESSION {
        if((strcmp(sauvOpr,"/")==0) && (sauvConst==0))
        printf("erreur semantique a la ligne %d, division sur zero\n", nb_ligne);
        }
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
		printf("erreur semantique a la ligne %d, double declaration  de %s\n",nb_ligne,$1);
}
          |idf
          {
                if (doubleDeclaration($1)==0)
                        insererTYPE($1,sauvType);
		else
			printf("erreur semantique a la ligne %d, double declaration  de %s\n",nb_ligne,$1);
          }
;	
DEC_TAB: TYPE LISTE_IDF_TAB pvg
;
LISTE_IDF_TAB: idf_tab cr_ov cst cr_fr vrg LISTE_IDF_TAB 
        {
        if(doubleDeclaration($1)==0) {
                insererTYPE($2,sauvType);
                insererTaille($2, $3);
        }
        else
                printf("erreur semantique a la ligne %d, double declaration de la table %s\n",nb_ligne, $2);
        if ($3<0)
		printf("erreur semantique a la ligne %d, la taille de tableau %s doit etre positive.\n",nb_ligne, $1);
	}
              |idf_tab cr_ov cst cr_fr  
        { 
        if(doubleDeclaration($1)==0) {
                insererTYPE($2,sauvType);
                insererTaille($2, $3);
        }
        else
                printf("erreur semantique a la ligne %d, double declaration de la table %s\n",nb_ligne, $2);
        if ($3<0)
                printf("erreur semantique a la ligne %d, la taille de tableau %s doit etre positive.\n",nb_ligne, $1);
	}
;	
LISTE_IDF_ECRITURE: idf vrg LISTE_IDF_ECRITURE {
        strcpy(typesIdfsEcriture[nbIdfSortie],(char*)typeEntite($1));
        //printf("Type idf %d sortie : %s\n",nbIdfSortie+1,typesIdfsEcriture[nbIdfSortie]);
        nbIdfSortie++;
        }
                |idf {
                        strcpy(typesIdfsEcriture[nbIdfSortie],(char*)typeEntite($1));
                        //printf("Type idf %d sortie : %s\n",nbIdfSortie+1,typesIdfsEcriture[nbIdfSortie]);
                        nbIdfSortie++;
                }

;
DEC_CONST: mc_const TYPE idf pvg {
        if (doubleDeclaration($3)==0){
                insererTYPE($3,sauvType);
                insererConstante($3, "");
        } else 
                printf("erreur semantique a la ligne %d, double declaration  de %s\n",nb_ligne,$3);
}
            | mc_const TYPE idf mc_affectation VALEUR pvg {
                    if (doubleDeclaration($3)==0){
                                 insererTYPE($3,sauvType);
                                insererConstante($3, tempValeur);
                    } else 
                        printf("erreur semantique a la ligne %d, double declaration  de %s\n",nb_ligne,$3);

                        if (strcmp(typeValeur, sauvType) != 0)
                                printf("erreur semantique a la ligne %d, non compatibilite du type de la constante %s.", nb_ligne, $3);
            }
;

VALEUR:val_reel {strcpy(typeValeur,"Reel");   sprintf(tempValeur, "%f", $1);}
        |val_entier {strcpy(typeValeur,"Entier");   sprintf(tempValeur, "%d", $1);}
        |mc_quot val_chaine mc_quot {strcpy(typeValeur,"Chaine");   strcpy(tempValeur,$2);}
        |cst {strcpy(typeValeur,"Entier");   sprintf(tempValeur, "%d", $1);}
;

OPERAND: idf |
 val_entier {strcpy(typesIdfsAffectation[nbrTypesIdfsAffectation],"Entier"); ++nbrTypesIdfsAffectation;} |
  val_reel {strcpy(typesIdfsAffectation[nbrTypesIdfsAffectation],"Reel"); ++nbrTypesIdfsAffectation;} |
   cst { sauvConst=$1; strcpy(typesIdfsAffectation[nbrTypesIdfsAffectation],"Entier"); ++nbrTypesIdfsAffectation;} |
   mc_quot val_chaine mc_quot {strcpy(typesIdfsAffectation[nbrTypesIdfsAffectation],"Chaine"); ++nbrTypesIdfsAffectation;}
;

OPERATEUR: mc_plus | mc_mois | mc_mul | mc_div { strcpy(sauvOpr,$1); }
;

FORMATAGE: formatage_entier {strcpy(typeFormatage,"Entier");}
| formatage_reel {strcpy(typeFormatage,"Reel");}
| formatage_chaine {strcpy(typeFormatage,"Chaine");}
;

FORMATAGE_ECRITURE: formatage_entier {
        strcpy(typesFormatagesEcriture[nbFormatagesSortie],"Entier");
        //printf("Type formatage %d sortie : %s\n",nbFormatagesSortie+1,typesFormatagesEcriture[nbFormatagesSortie]);
        nbFormatagesSortie++;}
| formatage_reel {
        strcpy(typesFormatagesEcriture[nbFormatagesSortie],"Reel");
        //printf("Type formatage %d sortie : %s\n",nbFormatagesSortie+1,typesFormatagesEcriture[nbFormatagesSortie]);
        nbFormatagesSortie++;}
| formatage_chaine {
        strcpy(typesFormatagesEcriture[nbFormatagesSortie],"Chaine");
        //printf("Type formatage %d sortie : %s\n",nbFormatagesSortie+1,typesFormatagesEcriture[nbFormatagesSortie]);
        nbFormatagesSortie++;}
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
NOM_BIB:bib_io {bibIoExiste = 1;}
         |bib_lang {bibLangExiste = 1;}
;		  
%%
main()
{yyparse();
afficher();}
yywrap() {}
yyerror(char*msg)
{
printf("\nerreur syntaxique a la ligne %d colonne %d.\n", nb_ligne,nb_colonne);
}

