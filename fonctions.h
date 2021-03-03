// je vais commencer a programmer ma table de symbole
 //1-decalration
 
		typedef struct
		{
		char NomEntite[20];
		char CodeEntite[20];
		char TypeEntite[20];
		char Constante[4];
		char Valeur[100];
		} TypeTS;
		//initiation d'un tableau qui va contenir les elements de la table de symbole
        TypeTS ts[100]; 
		// un compteur global pour la table de symbole
        int CpTabSym=0;
		
  //2- definir une fonction recherche
		int recherche(char entite[])
		{
		int i=0;
		while(i<CpTabSym)
		{
		if (strcmp(entite,ts[i].NomEntite)==0) return i;
		i++;
		}

		return -1;
		}
		
  //3-definir la fonction inserer
  void inserer(char entite[], char code[])
	{

	if ( recherche(entite)==-1)
	{
	strcpy(ts[CpTabSym].NomEntite,entite); 
	strcpy(ts[CpTabSym].CodeEntite,code);
	strcpy(ts[CpTabSym].Constante,"non");
	CpTabSym++;
	}
	}
  //4-definir la fonction afficher
	  void afficher ()
	{
	printf("\n\n/*****************************Table des symboles****************************/\n");
	printf("_____________________________________________________________________________\n");
	printf("\t| NomEntite |  CodeEntite | TyepEntite   |  Constante   |  Valeur\n");
	printf("_____________________________________________________________________________\n");
	int i=0;
	  while(i<CpTabSym)
	  {
		printf("\t|%10s |%12s | %12s |%12s |%12s\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite,ts[i].Constante, ts[i].Valeur);
		 i++;
	   }
	}
	
	//5-definir une focntion pour inserer le type
	
	 void insererTYPE(char entite[], char type[])
	{
       int pos;
	   pos=recherche(entite);
	if(pos!=-1)
	   strcpy(ts[pos].TypeEntite,type); 
	}
    //6- definir une focntion qui detecte la double declaration
	int doubleDeclaration(char entite[])
	{
	int pos;
	pos=recherche(entite);
	if(strcmp(ts[pos].TypeEntite,"")==0) return 0;
	   else return -1;
	}

	void insererConstante(char entite[], char valeur[])
	{
       int pos;
	   pos=recherche(entite);
	if(pos!=-1)
	   strcpy(ts[pos].Constante,"oui");
	   strcpy(ts[pos].Valeur,valeur);
	}

	// retourne 1 si l'entite est une constante + elle a une valeur
	int constValeur(char entite[])
	{
		int pos;
		pos=recherche(entite);
		if(pos!=-1){
			if(strcmp(ts[pos].Constante,"oui")==0){
				if (strcmp(ts[pos].Valeur, "") == 0)
					return 0;
				else 
					return 1;
			} else
				return -1;
		}
	}

	char* typeEntite(char entite[])
	{
		int pos;
		pos=recherche(entite);
		if(pos!=-1){
			return ts[pos].TypeEntite;
		} else
			return "";
	}