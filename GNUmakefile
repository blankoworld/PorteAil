#########################################
#########################################
## Copyright (C) 2011 DOSSMANN Olivier ##
## Auteur : DOSSMANN Olivier           ##
## Courriel : olivier@dossmann.net     ##
#########################################
#########################################
# définition de cibles particulières
.PHONY: clean

## VARIABLES ##
## configuration
DESTINATION = porteail
INDEX = $(DESTINATION)/index.html
CSS_DEFAUT = bicolore_sans_menu.css
CSS_PATCH_AJOUT_MENU = bicolore_ajout_menu.patch
CSS_NOM = defaut.css
TITRE = Titre par défaut
ACCUEIL = Accueil - $(TITRE)
DOSSIER_HTML = composants
## divers
#MENU = $(DOSSIER_HTML)/menu.html
## utiles pour le makefile
ifndef $(MENU)
	dependances_css = style/$(CSS_DEFAUT)
else
	dependances_css = style/$(CSS_DEFAUT) style/$(CSS_PATCH_AJOUT_MENU)
endif
entete = $(DOSSIER_HTML)/entete.html
enqueue = $(DOSSIER_HTML)/enqueue.html
dependances_index = $(entete) $(enqueue)
PROG_ECHO = `which echo`

## DEBUT
# création de tous les fichiers
all: test index.html

# divers tests sur l'existence des dossiers/fichiers
# création si besoin
test: 
	@$(PROG_ECHO) -e "Lancement des tests…"
	@test -d img || mkdir img
	@test -d categ || mkdir categ
	@test -d style || mkdir style
	@test -f style/$(CSS_DEFAUT) || exit
	$(if $(MENU), @test -f $(MENU) || exit, @$(PROG_ECHO) -e "\tPas de menu")
	$(if $(MENU), @test -f style/$(CSS_DEFAUT) || exit)
	@test -d $(DESTINATION) || mkdir $(DESTINATION)
	@test -d $(DESTINATION)/image || mkdir $(DESTINATION)/image
	@$(PROG_ECHO) -e "\t…terminé."

# création du fichier CSS
css: $(dependances_css)
	@$(PROG_ECHO) -e "Création du fichier CSS…"
	@cp style/$(CSS_DEFAUT) $(DESTINATION)/$(CSS_NOM)
	$(if $(MENU), @patch -u -p0 $(DESTINATION)/$(CSS_NOM) style/$(CSS_PATCH_AJOUT_MENU))
	@$(PROG_ECHO) -e "\t…terminée."

# création de la page d'index
index.html: $(DOSSIER_HTML) css $(dependances_index)
	@$(PROG_ECHO) -e "Création de la page de garde…"
	$(if $(MENU), @cat $(entete) $(MENU) $(enqueue) > $(INDEX), @cat $(entete) $(enqueue) > $(INDEX))
	@$(PROG_ECHO) -e "\t…terminée."
	@$(PROG_ECHO) -e "Modification du contenu…"
	@sed -i "s/TITRE_PORTEAIL/$(TITRE)/g" $(INDEX)
	@sed -i "s/ACCUEIL_PORTEAIL/$(ACCUEIL)/g" $(INDEX)
	@sed -i "s#CSS_DEFAUT#./$(CSS_NOM)#g" $(INDEX)
	@$(PROG_ECHO) -e "\t…terminée."

# nettoyage des fichiers générés
clean:
	@$(PROG_ECHO) -e "Nettoyage des fichiers en cours…"
	@rm -rf $(DESTINATION)
	@$(PROG_ECHO) -e "\t…terminé."