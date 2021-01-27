%token mc_import pvg bib_io bib_lang err mc_public 
       mc_private mc_protected mc_class idf aco_ov aco_fr
	   mc_entier mc_reel mc_chaine vrg idf_tab cr_ov cr_fr
	   cst mc_const mc_affectation val_entier val_chaine val_reel
       mc_main par_ov par_fr mc_operation

%%
S: LISTE_BIB HEADER_CLASS aco_ov CORPS aco_fr{printf("pgm syntaxiquement correcte"); 
               YYACCEPT;        }
;

HEADER_CLASS:MODIFICATEUR mc_class idf
;
MODIFICATEUR: mc_public
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
;
INSTRU_AFFECTATION: idf mc_affectation EXPRESSION pvg
                    |  idf_tab cr_ov cst cr_fr mc_affectation EXPRESSION pvg
;
EXPRESSION: idf | VALEUR | LISTE_EXPR_ENTRE_ARG
;
LISTE_EXPR_ENTRE_ARG: ARG mc_operation LISTE_EXPR_ENTRE_ARG 
                    |  ARG
;
ARG: idf
    | val_entier
    | val_reel
;
DEC: DEC_VAR
     |DEC_TAB
     |DEC_CONST
;
DEC_VAR: TYPE LISTE_IDF pvg
;
LISTE_IDF: idf vrg LISTE_IDF
          |idf
;	
DEC_TAB: TYPE LISTE_IDF_TAB pvg
;
LISTE_IDF_TAB: idf_tab cr_ov cst cr_fr vrg LISTE_IDF_TAB
              |idf_tab cr_ov cst cr_fr
;	
DEC_CONST: mc_const TYPE idf pvg
            | mc_const TYPE idf mc_affectation VALEUR pvg
;

VALEUR:val_reel
        |val_entier
        |val_chaine
;

	  
TYPE:mc_entier
    |mc_reel
	|mc_chaine
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
{yyparse();}
yywrap() {}
