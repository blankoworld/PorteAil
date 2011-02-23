#########################################
#########################################
## Copyright (C) 2011 DOSSMANN Olivier ##
## Auteur : DOSSMANN Olivier           ##
## Courriel : olivier@dossmann.net     ##
#########################################
#########################################
# définition de cibles particulières
.PHONY: clean

# définition de variables
## obligatoires
DESTINATION = porteail
INDEX = $(DESTINATION)/index.html
CSS_DEFAUT = defaut.css
TITRE = Titre par défaut
ACCUEIL = Accueil - $(TITRE)
## facultatives
MENU = menu.html

# création de tous les fichiers
all: test index

# divers tests sur l'existence des dossiers/fichiers
# création si besoin
test:
	@echo -e "Lancement des tests…"
	@test -f entete.html || exit
	@test -f enqueue.html || exit
	@test -d img || mkdir img
	@test -d categ || mkdir categ
	@test -d style || mkdir style
	@test -f style/$(CSS_DEFAUT) || exit
	$(if $(MENU), @test -f $(MENU) || exit, @echo -e "Pas de menu")
	@test -d $(DESTINATION) || mkdir $(DESTINATION)
	@test -d $(DESTINATION)/image || mkdir $(DESTINATION)/image
	@echo -e "\t…terminé."

# création de la page d'index
index:
	@echo -e "Création de la page de garde…"
	$(if $(MENU), @cat entete.html menu.html enqueue.html > $(INDEX), @cat entete.html enqueue.html > $(INDEX))
	@echo -e "\t…terminée."
	@echo -e "Modification du contenu…"
	@sed -i "s/TITRE_PORTEAIL/$(TITRE)/g" $(INDEX)
	@sed -i "s/ACCUEIL_PORTEAIL/$(ACCUEIL)/g" $(INDEX)
	@cp style/$(CSS_DEFAUT) $(DESTINATION)
	@sed -i "s#CSS_DEFAUT#./$(CSS_DEFAUT)#g" $(INDEX)
	@echo -e "\t…terminée."

# nettoyage des fichiers générés
clean:
	@echo -e "Nettoyage des fichiers en cours…"
	@rm -rf $(DESTINATION)
	@echo -e "\t…terminé."
