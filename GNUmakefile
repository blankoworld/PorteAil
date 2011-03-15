###########
# LICENCE #
###########

# Copyright (C) 2011 DOSSMANN Olivier <olivier@dossmann.net> ##

#  This file is part of PorteAil.
#
#  PorteAil is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  PorteAil is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with PorteAil. If not, see <http://www.gnu.org/licenses/>.

######################################################################

# définition de cibles particulières
.PHONY: clean

## VARIABLES ##
## configuration
DESTINATION = porteail
INDEX = $(DESTINATION)/index.xhtml
CSS_SANS_MENU = bicolore_sans_menu.css
CSS_AVEC_MENU = bicolore_avec_menu.css
CSS_NOM = defaut.css
TITRE = Titre par défaut
ACCUEIL = Accueil - $(TITRE)
DOSSIER_HTML = composants
## divers
#MENU = $(DOSSIER_HTML)/menu.html
INTRO = $(DOSSIER_HTML)/introduction.html
## utiles pour le makefile
ifndef $(MENU)
	dependances_css = style/$(CSS_SANS_MENU)
else
	dependances_css = style/$(CSS_AVEC_MENU) 
endif
entete = $(DOSSIER_HTML)/entete.html
enqueue = $(DOSSIER_HTML)/enqueue.html
contenu_fin = $(DOSSIER_HTML)/contenu_fin.html
dependances_index = $(entete) $(enqueue) $(contenu_fin)
script_contenu = creation_categ.sh
contenu = categories.html
# programmes
PROG_ECHO = `which echo`
PROG_TEST = `which test`
PROG_SED  = `which sed`
PROG_PATCH = `which patch`
PROG_CAT = `which cat`
PROG_CP = `which cp`
PROG_BASH = `which bash`

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
	@$(PROG_ECHO) -e "\t…option introduction dans la page"
	$(if $(INTRO), @test -f $(INTRO) || exit)
	$(if $(INTRO), @$(PROG_ECHO) -e "\t\t-> activée", @$(PROG_ECHO) -e "\t\t-> désactivée")
	@$(PROG_ECHO) -e "\t…option ajout d'un menu (vérification de l'existence)"
	$(if $(MENU), @test -f $(MENU) || exit)
	$(if $(MENU), @$(PROG_ECHO) -e "\t\t-> activée", @$(PROG_ECHO) -e "\t\t-> désactivée")
	@$(PROG_ECHO) -e "\t…création de la destination"
	@test -d $(DESTINATION) || mkdir $(DESTINATION)
	@$(PROG_ECHO) -e "\t…création du dossier image"
	@test -d $(DESTINATION)/image || mkdir $(DESTINATION)/image
	@$(PROG_ECHO) -e "\t…copie des fichiers images"
	@cp -r img/* $(DESTINATION)/image
	@$(PROG_ECHO) -e "  …terminé."

# création du fichier CSS
css: $(dependances_css)
	@$(PROG_ECHO) -e "Création du fichier CSS…"
	$(if $(MENU), @cp style/$(CSS_AVEC_MENU) $(DESTINATION)/$(CSS_NOM), @cp style/$(CSS_SANS_MENU) $(DESTINATION)/$(CSS_NOM))
#	@cp style/$(CSS_DEFAUT) $(DESTINATION)/$(CSS_NOM)
	@$(PROG_ECHO) -e "  …terminée."

# création du fichier $(contenu)
contenu: $(script_contenu)
	@sed -i "s/DEBUG=1/DEBUG=0/g" $(script_contenu)
	@$(PROG_BASH) $(script_contenu) || exit

# création de la page d'index
index.html: $(DOSSIER_HTML) css contenu $(dependances_index) $(contenu)
	@$(PROG_ECHO) -e "Création de la page de garde…"
# entete
	@$(PROG_ECHO) -e "\t…insertion de l'entête"
	@cat $(entete) > $(INDEX)
# modification du contenu
	@$(PROG_ECHO) -e "\t…modification du contenu"
	@sed -i -e "s/@@TITRE_PORTEAIL@@/$(TITRE)/g" -e "s/@@ACCUEIL_PORTEAIL@@/$(ACCUEIL)/g" -e "s#@@CSS_DEFAUT@@#./$(CSS_NOM)#g" -e "s/^\(.*\)@@.*@@\(.*\)$$/\1\2/g" $(INDEX)
	@$(PROG_ECHO) -e "\t  …contenu modifié avec succès !"
# introduction (SI la variable INTRO est remplie)
	$(if $(INTRO), @cat $(INTRO) >> $(INDEX); $(PROG_ECHO) -e "\t…insertion de l'introduction" || exit)
# contenu
	@$(PROG_ECHO) -e "\t…insertion du contenu"
	@cat $(contenu) >> $(INDEX)
#	fin du contenu
	@$(PROG_ECHO) -e "\t…insertion de la fin du contenu"
	@cat $(contenu_fin) >> $(INDEX)
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
	@rm -f $(contenu)
	@$(PROG_ECHO) -e "  …terminé."
