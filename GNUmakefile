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
MENU = $(DOSSIER_HTML)/menu.html
## utiles pour le makefile
ifndef $(MENU)
	dependances_css = style/$(CSS_DEFAUT)
else
	dependances_css = style/$(CSS_DEFAUT) style/$(CSS_PATCH_AJOUT_MENU)
endif
entete = $(DOSSIER_HTML)/entete.html
enqueue = $(DOSSIER_HTML)/enqueue.html
dependances_index = $(entete) $(enqueue)
# programmes
PROG_ECHO = `which echo`
PROG_TEST = `which test`
PROG_SED  = `which sed`
PROG_PATCH = `which patch`
PROG_CAT = `which cat`

## DEBUT
# création de tous les fichiers
all: test index.html

# divers tests sur l'existence des dossiers/fichiers
# création si besoin
test: 
	@$(PROG_ECHO) -e "Lancement des tests…"
	@$(PROG_ECHO) -e "\t…existence des dossiers img, categ et style"
	@test -d img || mkdir img
	@test -d categ || mkdir categ
	@test -d style || mkdir style
	@$(PROG_ECHO) -e "\t…existence de la feuille de style par défaut : '$(CSS_DEFAUT)'"
	@test -f style/$(CSS_DEFAUT) || exit
	@$(PROG_ECHO) -e "\t…vérification du choix de l'utilisateur sur l'ajout d'un menu ou non"
	$(if $(MENU), @test -f $(MENU) || exit, @$(PROG_ECHO) -e "\t\t-> option menu : désactivée")
	$(if $(MENU), @test -f style/$(CSS_DEFAUT); $(PROG_ECHO) -e "\t\t-> option menu : activée" || exit)
	@test -d $(DESTINATION) || mkdir $(DESTINATION)
	@test -d $(DESTINATION)/image || mkdir $(DESTINATION)/image
	@$(PROG_ECHO) -e "  …terminé."

# création du fichier CSS
css: $(dependances_css)
	@$(PROG_ECHO) -e "Création du fichier CSS…"
	@cp style/$(CSS_DEFAUT) $(DESTINATION)/$(CSS_NOM)
	$(if $(MENU), @patch -u -p0 $(DESTINATION)/$(CSS_NOM) style/$(CSS_PATCH_AJOUT_MENU); $(PROG_ECHO) -e "\t…patch pour affichage du menu")
	@$(PROG_ECHO) -e "  …terminée."

# création de la page d'index
index.html: $(DOSSIER_HTML) css $(dependances_index)
	@$(PROG_ECHO) -e "Création de la page de garde…"
# entete
	@$(PROG_ECHO) -e "\t…insertion de l'entête"
	@cat $(entete) > $(INDEX)
# modification du contenu
	@$(PROG_ECHO) -e "\t…modification du contenu"
	@sed -i -e "s/TITRE_PORTEAIL/$(TITRE)/g" -e "s/ACCUEIL_PORTEAIL/$(ACCUEIL)/g" -e "s#CSS_DEFAUT#./$(CSS_NOM)#g" $(INDEX)
	@$(PROG_ECHO) -e "\t  …contenu modifié avec succès !"
# introduction (SI la variable INTRO est remplie)
# TODO: insérer ici possibilité de mettre une INTRODUCTION à la page du site
# contenu
# TODO: insérer ici le contenu
#	@$(PROG_ECHO) -e "\t…insertion du contenu"
# menu
	$(if $(MENU), @cat $(MENU) >> $(INDEX); $(PROG_ECHO) -e "\t…insertion du menu" || exit)
# enqueue
	@$(PROG_ECHO) -e "\t…insertion de l'enqueue"
	@cat $(enqueue) >> $(INDEX)
	@$(PROG_ECHO) -e "  …terminée."

# nettoyage des fichiers générés
clean:
	@$(PROG_ECHO) -e "Nettoyage des fichiers en cours…"
	@rm -rf $(DESTINATION)
	@$(PROG_ECHO) -e "  …terminé."
