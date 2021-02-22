// je vais commencer a programmer ma table de symbole
 //1-decalration
 
		typedef struct
		{
		char NomEntite[20];
		char CodeEntite[20];
		char TypeEntite[20];
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
		
  //3-d�finir la fonction inserer
  void inserer(char entite[], char code[])
	{

	if ( recherche(entite)==-1)
	{
	strcpy(ts[CpTabSym].NomEntite,entite); 
	strcpy(ts[CpTabSym].CodeEntite,code);
	CpTabSym++;
	}
	}
  //4-d�finir la fonction afficher
	  void afficher ()
	{
	printf("\n/***************Table des symboles ******************/\n");
	printf("_____________________________________________________\n");
	printf("\t| NomEntite |  CodeEntite | TyepEntite\n");
	printf("_____________________________________________________\n");
	int i=0;
	  while(i<CpTabSym)
	  {
		printf("\t|%10s |%12s | %12s\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite);
		 i++;
	   }
	}
	
	//5-d�finir une focntion pour inserer le type
	
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

