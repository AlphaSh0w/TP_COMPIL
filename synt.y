%token mc_import pvg bib_io bib_lang err mc_public 
       mc_private mc_protected mc_class idf aco_ov aco_fr
	   mc_entier mc_reel mc_chaine vrg idf_tab cr_ov cr_fm
	   cst mc_const mc_affectation val_entier

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
CORPS:LISTE_DEC
;
LISTE_DEC: DEC LISTE_DEC
          |
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
LISTE_IDF_TAB: idf_tab cr_ov cst cr_fm vrg LISTE_IDF_TAB
              |idf_tab cr_ov cst cr_fm
;	
DEC_CONST: mc_const TYPE idf pvg
            | mc_const TYPE idf mc_affectation val_entier pvg
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
