// je vais commencer a programmer ma table de symbole
//1-decalration

typedef struct
{
	char NomEntite[20];
	char CodeEntite[20];
	char TypeEntite[20];
	char Constante[4];
	char Valeur[100];
	int Taille;
} TypeTS;

typedef struct node
{
  TypeTS data;
  struct node *next;
};

struct node *head;
//initiation d'un tableau qui va contenir les elements de la table de symbole
TypeTS ts[100];
// un compteur global pour la table de symbole
int CpTabSym = 0;

//2- definir une fonction recherche
int recherche(char entite[])
{
	int i = 0;
	struct node *temp = head;
	printf("\n\nList elements are - \n");
	while(temp != NULL)
	{
		if (strcmp(entite, temp->data.NomEntite) == 0)
			return i;
		i++;
		temp = temp->next;
	}

	return -1;
}

//3-definir la fonction inserer
void inserer(char entite[], char code[])
{

	if (recherche(entite) == -1)
	{

		struct node *newNode;
		newNode = malloc(sizeof(struct node));
		strcpy(newNode->data.NomEntite, entite);
		strcpy(newNode->data.CodeEntite, code);
		strcpy(newNode->data.Constante, "non");
		newNode->data.Taille = 1;
		newNode->next = NULL;

		if (head == NULL){
			head = newNode;
		} else {
			struct node *temp = head;
			while(temp->next != NULL){
			temp = temp->next;
			}
			temp->next = newNode;
		}
		
	}
}
//4-definir la fonction afficher
void afficher()
{
	printf("\n\n/*****************************Table des symboles****************************/\n");
	printf("_____________________________________________________________________________\n");
	printf("| NomEntite |  CodeEntite | TyepEntite   |  Constante   |  Valeur   |  Taille\n");
	printf("_____________________________________________________________________________\n");
	int i = 0;
	while (i < CpTabSym)
	{
		printf("|%10s |%12s | %12s |%12s |%12s |	%d\n", ts[i].NomEntite, ts[i].CodeEntite, ts[i].TypeEntite, ts[i].Constante, ts[i].Valeur, ts[i].Taille);
		i++;
	}
}

//5-definir une focntion pour inserer le type

void insererTYPE(char entite[], char type[])
{
	int pos;
	struct node *temp,*ptr;
	pos = recherche(entite);
	if (pos != -1){
		if (head != NULL){
			if(pos==0)
                {
						strcpy(head->data.TypeEntite, type);
                }
                else
                {
                        ptr=head;
						int i;
                        for(i=0;i<pos;i++) {
							temp=ptr;
							ptr=ptr->next ;
                        }
						if (i == pos && ptr != NULL){
							strcpy(ptr->data.TypeEntite, type);
						}
                }
		}
	}
}

struct node *get(int pos)
{
	struct node *temp,*ptr;
	if(pos==0)
                {
						return head;
                }
                else
                {
                        ptr=head;
						int i;
                        for(i=0;i<pos;i++) {
							temp=ptr;
							ptr=ptr->next ;
                        }
						if (i == pos && ptr != NULL){
							return ptr;
						}
                }
}

void insererTaille(char entite[], int taille)
{
	int pos;
	struct node *temp,*ptr;
	pos = recherche(entite);
	if (pos != -1){
		if (head != NULL){
			if(pos==0)
                {
						head->data.Taille = taille;
                }
                else
                {
                        ptr=head;
						int i;
                        for(i=0;i<pos;i++) {
							temp=ptr;
							ptr=ptr->next ;
                        }
						if (i == pos && ptr != NULL){
							ptr->data.Taille = taille;
						}
                }
		}
	}
}

//6- definir une focntion qui detecte la double declaration
int doubleDeclaration(char entite[])
{
	int pos;
	pos = recherche(entite);
	if (strcmp(ts[pos].TypeEntite, "") == 0)
		return 0;
	else
		return -1;
}

void insererConstante(char entite[], char valeur[])
{
	int pos;
	pos = recherche(entite);
	if (pos != -1)
		strcpy(ts[pos].Constante, "oui");
	strcpy(ts[pos].Valeur, valeur);
}

// retourne 1 si l'entite est une constante + elle a une valeur
int constValeur(char entite[])
{
	int pos;
	pos = recherche(entite);
	if (pos != -1)
	{
		if (strcmp(ts[pos].Constante, "oui") == 0)
		{
			if (strcmp(ts[pos].Valeur, "") == 0)
				return 0;
			else
				return 1;
		}
		else
			return -1;
	}
}

char *typeEntite(char entite[])
{
	int pos;
	pos = recherche(entite);
	if (pos != -1)
	{
		return ts[pos].TypeEntite;
	}
	else
		return "";
}

int tailleTableau(char entite[])
{
	int pos;
	pos = recherche(entite);
	if (pos != -1)
	{
		return ts[pos].Taille;
	}
	else
		return -1;
}
