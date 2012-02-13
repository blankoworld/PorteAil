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
# configuration
include configrc
# programmes
PROG_ECHO = `which echo`
PROG_TEST = `which test`
PROG_SED  = `which sed`
PROG_CAT = `which cat`
PROG_CP = `which cp`
PROG_SH = `which sh`
PROG_RM = `which rm`
PROG_SORT = `which sort`
PROG_AWK = `which awk`
PROG_MD5SUM = `which md5sum`

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
ifndef PROG_SORT
error_sort = 1
endif
ifndef PROG_AWK
error_awk = 1
endif
ifndef PROG_MD5SUM
error_md5sum = 1
endif

## DEBUT
# création de tous les fichiers
all: test index.html

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
	$(if $(error_sort), @$(PROG_ECHO) -e "\t\tsort : MANQUANT." ; exit 1)
	$(if $(error_awk), @$(PROG_ECHO) -e "\t\tawk : MANQUANT." ; exit 1)
	$(if $(error_md5sum), @$(PROG_ECHO) -e "\t\tmd5sum : MANQUANT." ; exit 1)
	@$(PROG_ECHO) -e "\t…existence de la somme de contrôle MD5"
	@if $(PROG_TEST) -f $(somme_md5); \
	then $(PROG_ECHO) -e "\t\t-> OK"; \
	else $(PROG_ECHO) -e "\t\t-> manquant"; \
	fi
	@$(PROG_ECHO) -e "\t…existence des dossiers img, categ et style"
	@$(PROG_TEST) -d img || mkdir img
	@$(PROG_TEST) -d $(categ) || mkdir $(categ)
	@$(PROG_TEST) -d style || mkdir style
	@$(PROG_ECHO) -e "\t…option introduction dans la page"
	$(if $(INTRO), @$(PROG_TEST) -f $(INTRO) || exit 1)
	$(if $(INTRO), @$(PROG_ECHO) -e "\t\t-> activée", @$(PROG_ECHO) -e "\t\t-> désactivée")
	@$(PROG_ECHO) -e "\t…option ajout d'un menu (vérification de l'existence)"
	$(if $(MENU), @$(PROG_TEST) -f $(MENU) || exit 1)
	$(if $(MENU), @$(PROG_ECHO) -e "\t\t-> activée", @$(PROG_ECHO) -e "\t\t-> désactivée")
	@$(PROG_ECHO) -e "\t…création de la destination"
	@$(PROG_TEST) -d $(DESTINATION) || mkdir $(DESTINATION)
	@$(PROG_ECHO) -e "\t…création du dossier image"
	@$(PROG_TEST) -d $(DESTINATION)/image || mkdir $(DESTINATION)/image
	@$(PROG_ECHO) -e "\t…copie des fichiers images"
	@$(PROG_CP) -r img/* $(DESTINATION)/image
	@$(PROG_ECHO) -e "  …terminé."

# création du fichier CSS
css: $(dependances_css)
	@$(PROG_ECHO) -e "Création du fichier CSS…"
	$(if $(MENU), @cp style/$(CSS_AVEC_MENU) $(DESTINATION)/$(CSS_NOM), @cp style/$(CSS_SANS_MENU) $(DESTINATION)/$(CSS_NOM))
#	@cp style/$(CSS_DEFAUT) $(DESTINATION)/$(CSS_NOM)
	@$(PROG_ECHO) -e "  …terminée."

# vérification de la somme de contrôle des catégories et des éléments, création si besoin
$(somme_md5):
	@$(PROG_ECHO) -e "Création d'un fichier 'somme de contrôle' pour l'ensemble des catégories…"
	@$(PROG_FIND) ./$(categ) -type f -name *.$(ext) -exec $(PROG_MD5SUM) {} + | $(PROG_AWK) '{print $1}' | $(PROG_SORT) | $(PROG_MD5SUM) > $(somme_md5)
	@$(PROG_ECHO) -e "  …terminée."

# création du fichier $(contenu)
contenu: $(script_contenu) $(somme_md5)
	@$(PROG_SED) -i "s/DEBUG=1/DEBUG=0/g" $(script_contenu)
	@$(PROG_ECHO) -e "Création du contenu avec les valeurs suivantes : "
	@$(PROG_ECHO) -e "\t\t- Dossier catégorie : $(categ)"
	@$(PROG_ECHO) -e "\t\t- Destination temporaire du contenu : $(contenu)"
	@$(PROG_ECHO) -e "\t\t- Extension des fichiers à lire : $(ext)"
	@$(PROG_ECHO) -e "\t\t- Dossier ayant les composants de la page : $(composants)"
	@$(PROG_ECHO) -e "\t\t- Entête HTML d'une catégorie : $(categ_deb)"
	@$(PROG_ECHO) -e "\t\t- Enqueue HTML d'une catégorie : $(categ_fin)"
	@$(PROG_ECHO) -e "\t\t- Code HTML d'un élément : $(elem)"
	@$(PROG_SH) $(script_contenu) $(categ) $(contenu) $(ext) $(composants) $(categ_deb) $(categ_fin) $(elem)

# création de la page d'index
index.html: $(DOSSIER_HTML) css contenu $(dependances_index) $(contenu)
	@$(PROG_ECHO) -e "Création de la page de garde…"
# entete
	@$(PROG_ECHO) -e "\t…insertion de l'entête"
	@$(PROG_CAT) $(entete) > $(INDEX)
# modification du contenu
	@$(PROG_ECHO) -e "\t…modification du contenu"
	@$(PROG_SED) -i -e "s/@@TITRE_PORTEAIL@@/$(TITRE)/g" -e "s/@@ACCUEIL_PORTEAIL@@/$(ACCUEIL)/g" -e "s#@@CSS_DEFAUT@@#./$(CSS_NOM)#g" -e "s/^\(.*\)@@.*@@\(.*\)$$/\1\2/g" $(INDEX)
	@$(PROG_ECHO) -e "\t  …contenu modifié avec succès !"
# introduction (SI la variable INTRO est remplie)
	$(if $(INTRO), @cat $(INTRO) >> $(INDEX); $(PROG_ECHO) -e "\t…insertion de l'introduction" || exit 1)
# contenu
	@$(PROG_ECHO) -e "\t…insertion du contenu"
	@$(PROG_CAT) $(contenu) >> $(INDEX)
#	fin du contenu
	@$(PROG_ECHO) -e "\t…insertion de la fin du contenu"
	@$(PROG_CAT) $(contenu_fin) >> $(INDEX)
# menu
	$(if $(MENU), @cat $(MENU) >> $(INDEX); $(PROG_ECHO) -e "\t…insertion du menu" || exit 1)
# enqueue
	@$(PROG_ECHO) -e "\t…insertion de l'enqueue"
	@$(PROG_CAT) $(enqueue) >> $(INDEX)
	@$(PROG_ECHO) -e "  …terminée."

# nettoyage des fichiers générés
clean:
	@$(PROG_ECHO) -e "Nettoyage des fichiers en cours…"
	@$(PROG_RM) -rf $(DESTINATION)
	@$(PROG_RM) -f $(contenu)
	@$(PROG_ECHO) -e "  …terminé."
