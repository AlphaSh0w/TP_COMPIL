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
} node;

struct node *head;
//initiation d'un tableau qui va contenir les elements de la table de symbole
// TypeTS ts[100];
// un compteur global pour la table de symbole
// int CpTabSym = 0;

//2- definir une fonction recherche
int recherche(char entite[])
{
	int i = 0;
	struct node *temp = head;
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
		strcpy(newNode->data.TypeEntite, "");
		strcpy(newNode->data.Valeur, "");
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
						} else
							return NULL;
                }
}

//4-definir la fonction afficher
void afficher()
{
	struct node *ptr;
        if(head==NULL)
        {
                printf("\nLe tableau est vide\n");
        }
        else
        {
                ptr=head;
				printf("\n\n/*****************************Table des symboles****************************/\n");
				printf("_____________________________________________________________________________\n");
				printf("| NomEntite |  CodeEntite | TypeEntite   |  Constante   |  Valeur   |  Taille\n");
				printf("_____________________________________________________________________________\n");
                while(ptr!=NULL)
                {
                        printf("|%10s |%12s | %12s |%12s |%12s |	%d\n", ptr->data.NomEntite, ptr->data.CodeEntite, ptr->data.TypeEntite, ptr->data.Constante, ptr->data.Valeur, ptr->data.Taille);
                        ptr=ptr->next ;
                }
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
	struct node *ourNode = get(pos);
	if (strcmp(ourNode->data.TypeEntite, "") == 0)
		return 0;
	else
		return -1;
}

void insererConstante(char entite[], char valeur[])
{
	struct node *temp,*ptr;
	int pos;
	pos = recherche(entite);
	if (pos != -1){
		if (head != NULL){
			if(pos==0)
                {
						strcpy(head->data.Constante, "oui");
						strcpy(head->data.Valeur, valeur);
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
							strcpy(ptr->data.Constante, "oui");
							strcpy(ptr->data.Valeur, valeur);
						}
                }
		}
	}
}

// retourne 1 si l'entite est une constante + elle a une valeur
int constValeur(char entite[])
{
	int pos;
	pos = recherche(entite);
	if (pos != -1)
	{
		struct node *ourNode = get(pos);
		if (strcmp(ourNode->data.Constante, "oui") == 0)
		{
			if (strcmp(ourNode->data.Valeur, "") == 0)
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
		struct node *ourNode = get(pos);
		return ourNode->data.TypeEntite;
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
		struct node *ourNode = get(pos);
		return ourNode->data.Taille;
	}
	else
		return -1;
}
