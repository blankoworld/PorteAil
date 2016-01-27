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

VERSION=0.1.3

## CONFIG PAR DEFAUT
include paconfigrc

## CONFIG UTILISATEUR
include configrc

## AUTRES CONFIGS

##--[[ adresses ]]--##
INTRO_ADDR = $(COMPONENTS)/$(INTRO)
MENU_ADDR = $(COMPONENTS)/$(MENU)

# programmes
PROG_ECHO = `which echo`
PROG_TEST = `which test`
PROG_RM = `which rm`
PROG_LUA = `which lua`
PROG_SH = `which sh`
PROG_MKDIR = `which mkdir`

# vérification des programmes
ifndef PROG_ECHO
error_echo = 1
endif
ifndef PROG_TEST
error_test = 1
endif
ifndef PROG_RM
error_rm = 1
endif
ifndef PROG_MKDIR
error_mkdir = 1
endif
ifndef PROG_SH
error_sh = 1
endif
ifndef PROG_LUA
error_lua = 1
endif

## DEBUT
# création de tous les fichiers
all: test homepage

## TEST
# divers tests sur l'existence des dossiers/fichiers
# création si besoin
test:
	$(if $(error_echo), exit 1)
	@$(PROG_ECHO) -e "Lancement des tests…"
	@$(PROG_ECHO) -e "\t…existence des différents programmes"
	$(if $(error_test), @$(PROG_ECHO) -e "\t\ttest : MANQUANT." ; exit 1)
	$(if $(error_mkdir), @$(PROG_ECHO) -e "\t\tmkdir : MANQUANT." ; exit 1)
	$(if $(error_sh), @$(PROG_ECHO) -e "\t\tsh : MANQUANT." ; exit 1)
	$(if $(error_rm), @$(PROG_ECHO) -e "\t\trm : MANQUANT." ; exit 1)
	$(if $(error_lua), @$(PROG_ECHO) -e "\t\tlua : MANQUANT." ; exit 1)
	@$(PROG_ECHO) -e "\t…existence des dossiers '$(IMAGES)', '$(CATEGORIES)' et '$(CSS)'"
	@for i in $(IMAGES) $(CATEGORIES) $(CSS) ; \
	do \
		$(PROG_TEST) -d $$i || exit 1 ; \
	done ; \
  $(PROG_ECHO) -e "\t…création des dossiers cibles '$(DESTINATION)' et '$(DESTINATION)/$(IMAGES_DESTINATION)'"
	@for j in $(DESTINATION) $(DESTINATION)/$(IMAGES_DESTINATION) ; \
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

## CATEGORIES
# création de la page d'accueil
homepage:
	@$(PROG_ECHO) -e "Création de la page d'accueil…"
	@VERSION=$(VERSION) $(PROG_LUA) create_homepage.lua || exit 1
	@$(PROG_ECHO) -e "  …terminée."

install:
	@SRCDIR=$(DESTINATION) DESTDIR=$(INSTALLDIR) $(PROG_SH) install.sh || exit 1

## NETTOYAGE
# nettoyage des fichiers générés
clean:
	@$(PROG_ECHO) -e "Nettoyage des fichiers en cours…"
	@$(PROG_RM) -rf $(DESTINATION)
	@$(PROG_ECHO) -e "  …terminé."
