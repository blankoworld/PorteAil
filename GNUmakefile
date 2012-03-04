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

## CONFIG PAR DEFAUT
include paconfigrc

## CONFIG UTILISATEUR
include configrc

## AUTRES CONFIGS

##--[[ adresses ]]--##
INTRO_ADDR = $(COMPOSANTS)/$(INTRO)
INDEX_ADDR = $(CIBLE)/$(INDEX)
MENU_ADDR = $(COMPOSANTS)/$(MENU)
CSS_SANS_MENU_ADDR = $(CSS)/$(CSS_SANS_MENU)
CSS_AVEC_MENU_ADDR = $(CSS)/$(CSS_AVEC_MENU)
STYLE_ADDR = $(CSS)/$(STYLE)
ENTETE_ADDR = $(COMPOSANTS)/$(ENTETE)
ENQUEUE_ADDR = $(COMPOSANTS)/$(ENQUEUE)
POST_CONTENU_ADDR = $(COMPOSANTS)/$(POST_CONTENU)
ENTETE_CAT_ADDR = $(COMPOSANTS)/$(ENTETE_CAT)
ENQUEUE_CAT_ADDR = $(COMPOSANTS)/$(ENQUEUE_CAT)
ELEMENT_ADDR = $(COMPOSANTS)/$(ELEMENT)
CONTENU_ADDR = $(COMPOSANTS)/$(CONTENU)
DEFAUT_IMG_ADDR = $(IMAGES)/$(DEFAUT_IMG)

##--[[ dépendances ]]--##
ifndef $(MENU)
	CSS_DEP = $(CSS_SANS_MENU_ADDR)
else
	CSS_DEP = $(CSS_AVEC_MENU_ADDR) 
endif
INDEX_DEP = $(ENTETE_ADDR) $(ENQUEUE_ADDR) $(POST_CONTENU_ADDR)
CSS_TOUS = $(CIBLE)/$(STYLE) $(CIBLE)/$(CSS_NOM)
CONFIG = paconfigrc configrc

# Éléments sources
SOURCE = $(CATEGORIES)/*.$(CATEGORIES_EXT)

# programmes
PROG_ECHO = `which echo`
PROG_TEST = `which test`
PROG_SED  = `which sed`
PROG_CAT = `which cat`
PROG_CP = `which cp`
PROG_SH = `which sh`
PROG_RM = `which rm`
PROG_FIND = `which find`
PROG_SORT = `which sort`
PROG_WC = `which wc`
PROG_MKDIR = `which mkdir`

# vérification des programmes
ifndef PROG_ECHO
error_echo = 1
endif
ifndef PROG_TEST
error_test = 1
endif
ifndef PROG_SED
error_sed = 1
endif
ifndef PROG_CAT
error_cat = 1
endif
ifndef PROG_CP
error_cp = 1
endif
ifndef PROG_SH
error_sh = 1
endif
ifndef PROG_RM
error_rm = 1
endif
ifndef PROG_FIND
error_find = 1
endif
ifndef PROG_SORT
error_sort = 1
endif
ifndef PROG_WC
error_wc = 1
endif
ifndef PROG_MKDIR
error_mkdir = 1
endif

## DEBUT
# création de tous les fichiers
all: test index

## TEST
# divers tests sur l'existence des dossiers/fichiers
# création si besoin
test:
	$(if $(error_echo), exit 1)
	@$(PROG_ECHO) -e "Lancement des tests…"
	@$(PROG_ECHO) -e "\t…existence des différents programmes"
	$(if $(error_test), @$(PROG_ECHO) -e "\t\ttest : MANQUANT." ; exit 1)
	$(if $(error_sed), @$(PROG_ECHO) -e "\t\tsed : MANQUANT." ; exit 1)
	$(if $(error_cat), @$(PROG_ECHO) -e "\t\tcat : MANQUANT." ; exit 1)
	$(if $(error_cp), @$(PROG_ECHO) -e "\t\tcp : MANQUANT." ; exit 1)
	$(if $(error_sh), @$(PROG_ECHO) -e "\t\tsh : MANQUANT." ; exit 1)
	$(if $(error_rm), @$(PROG_ECHO) -e "\t\trm : MANQUANT." ; exit 1)
	$(if $(error_find), @$(PROG_ECHO) -e "\t\tfind : MANQUANT." ; exit 1)
	$(if $(error_sort), @$(PROG_ECHO) -e "\t\tsort : MANQUANT." ; exit 1)
	$(if $(error_wc), @$(PROG_ECHO) -e "\t\twc : MANQUANT." ; exit 1)
	@$(PROG_ECHO) -e "\t…existence des dossiers '$(IMAGES)', '$(CATEGORIES)' et '$(CSS)'"
	@for i in $(IMAGES) $(CATEGORIES) $(CSS) ; \
	do \
		$(PROG_TEST) -d $$i || exit 1 ; \
	done ; \
  $(PROG_ECHO) -e "\t…création des dossiers cibles '$(CIBLE)' et '$(CIBLE)/$(IMAGES_CIBLE)'"
	@for j in $(CIBLE) $(CIBLE)/$(IMAGES_CIBLE) ; \
	do \
	  $(PROG_TEST) -d $$j || $(PROG_MKDIR) $$j ; \
	done
	@$(PROG_ECHO) -e "\t…option introduction dans la page"
	$(if $(INTRO), @$(PROG_TEST) -f $(INTRO_ADDR) || exit 1)
	$(if $(INTRO), @$(PROG_ECHO) -e "\t\t-> activée", @$(PROG_ECHO) -e "\t\t-> désactivée")
	@$(PROG_ECHO) -e "\t…option ajout d'un menu (vérification de l'existence)"
	$(if $(MENU), @$(PROG_TEST) -f $(MENU_ADDR) || exit 1)
	$(if $(MENU), @$(PROG_ECHO) -e "\t\t-> activée", @$(PROG_ECHO) -e "\t\t-> désactivée")
	@$(PROG_ECHO) -e "  …terminé."

## FICHIERS CSS
# création du fichier CSS
$(CIBLE)/$(CSS_NOM): $(CONFIG) $(CSS_DEP)
	@$(PROG_ECHO) -e "Création du fichier CSS…"
	$(if $(MENU), @$(PROG_CP) $(CSS_AVEC_MENU_ADDR) $(CIBLE)/$(CSS_NOM), @$(PROG_CP) $(CSS_SANS_MENU_ADDR) $(CIBLE)/$(CSS_NOM))
	@$(PROG_ECHO) -e "  …terminée."

# création du fichier CSS de couleur
$(CIBLE)/$(STYLE): $(CONFIG) $(STYLE_ADDR)
	@$(PROG_ECHO) -e "Création du fichier CSS pour les couleurs…"
	@$(PROG_CP) $(STYLE_ADDR) $(CIBLE)/$(STYLE)
	@$(PROG_ECHO) -e "  …terminée."

## CATEGORIES
# création du fichier $(CONTENU_ADDR)
$(CONTENU_ADDR): $(CONFIG) $(GEN_CATEGORIES) $(SOURCE) $(DEFAUT_IMG_ADDR)
	@$(PROG_SED) -i "s/DEBUG=1/DEBUG=0/g" $(GEN_CATEGORIES)
	@$(PROG_ECHO) -e "Création du contenu avec les valeurs suivantes : "
	@$(PROG_ECHO) -e "\t\t- Dossier catégorie : $(CATEGORIES)"
	@$(PROG_ECHO) -e "\t\t- Destination temporaire du contenu : $(CONTENU_ADDR)"
	@$(PROG_ECHO) -e "\t\t- Extension des fichiers à lire : $(CATEGORIES_EXT)"
	@$(PROG_ECHO) -e "\t\t- Dossier ayant les composants de la page : $(COMPOSANTS)"
	@$(PROG_ECHO) -e "\t\t- Entête HTML d'une catégorie : $(ENTETE_CAT_ADDR)"
	@$(PROG_ECHO) -e "\t\t- Enqueue HTML d'une catégorie : $(ENQUEUE_ADDR)"
	@$(PROG_ECHO) -e "\t\t- Code HTML d'un élément : $(ELEMENT_ADDR)"
	@$(PROG_ECHO) -e "\t\t- Dossier contenant les images sources : $(IMAGES)"
	@$(PROG_ECHO) -e "\t\t- Dossier de destination des images : $(IMAGES_CIBLE)"
	@$(PROG_ECHO) -e "\t\t- Image par défaut : $(DEFAUT_IMG_ADDR)"
	@$(PROG_ECHO) -e "\t\t- Dossier de destination global : $(CIBLE)"
	@$(PROG_SH) $(GEN_CATEGORIES) $(CATEGORIES) $(CONTENU_ADDR) $(CATEGORIES_EXT) $(COMPOSANTS) $(ENTETE_CAT_ADDR) $(ENQUEUE_CAT_ADDR) $(ELEMENT_ADDR) $(IMAGES) $(IMAGES_CIBLE) $(DEFAUT_IMG_ADDR) $(CIBLE)

## INDEX
# création de la page d'index
index: $(CONFIG) $(INDEX_ADDR) $(CSS_TOUS)

$(INDEX_ADDR): $(CONFIG) $(INDEX_DEP) $(CONTENU_ADDR)
	@$(PROG_ECHO) -e "Création de la page de garde…"
# entete
	@$(PROG_ECHO) -e "\t…insertion de l'entête"
	@$(PROG_CAT) $(ENTETE_ADDR) > $(INDEX_ADDR)
# modification du contenu
	@$(PROG_ECHO) -e "\t…modification du contenu"
	@$(PROG_SED) -i \
		-e "s/@@TITRE_PORTEAIL@@/$(TITRE)/g"       \
		-e "s/@@ACCUEIL_PORTEAIL@@/$(ACCUEIL)/g"   \
		-e "s#@@CSS_DEFAUT@@#./$(CSS_NOM)#g"       \
		-e "s#@@CSS_COULEUR@@#./$(STYLE)#g"  \
		-e "s/^\(.*\)@@.*@@\(.*\)$$/\1\2/g"        \
		$(INDEX_ADDR)
	@$(PROG_ECHO) -e "\t  …contenu modifié avec succès !"
# introduction (SI la variable INTRO est remplie)
	$(if $(INTRO), @cat $(INTRO_ADDR) >> $(INDEX_ADDR); $(PROG_ECHO) -e "\t…insertion de l'introduction" || exit 1)
# contenu
	@$(PROG_ECHO) -e "\t…insertion du contenu"
	@$(PROG_CAT) $(CONTENU_ADDR) >> $(INDEX_ADDR)
#	fin du contenu
	@$(PROG_ECHO) -e "\t…insertion de la fin du contenu"
	@$(PROG_CAT) $(POST_CONTENU_ADDR) >> $(INDEX_ADDR)
# menu
	$(if $(MENU), @cat $(MENU_ADDR) >> $(INDEX_ADDR); $(PROG_ECHO) -e "\t…insertion du menu" || exit 1)
# enqueue
	@$(PROG_ECHO) -e "\t…insertion de l'enqueue"
	@$(PROG_CAT) $(ENQUEUE_ADDR) >> $(INDEX_ADDR)
	@$(PROG_ECHO) -e "  …terminée."

## NETTOYAGE
# nettoyage des fichiers générés
clean:
	@$(PROG_ECHO) -e "Nettoyage des fichiers en cours…"
	@$(PROG_RM) -rf $(CIBLE)
	@$(PROG_RM) -f $(CONTENU_ADDR)
	@$(PROG_ECHO) -e "  …terminé."
