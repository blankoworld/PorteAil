#!/usr/bin/env bash
#
# creation_categ.sh
#
# Permet de naviguer dans les éléments de chaque catégorie d'un dossier suivant
#+ la syntaxe : 
#+
#+ # Commentaire dans le fichier
#+ [[Titre de la catégorie]]Description de la catégorie
#+ titre de l'élément##http://domaine.tld/##description de l'élément##nom_image##Titre de l'image##description de l'image

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

## VARIABLES
DEBUG=0
dossier="categ"
destination="categories.html"
IFS="
"
dossier_composants="./composants"
deb_categ="${dossier_composants}/categ_deb.html"
fin_categ="${dossier_composants}/categ_fin.html"
elem="${dossier_composants}/element.html"
extension="txt" # Extension des fichiers à prendre en compte

## FONCTIONS
debug() {
  if [[ $DEBUG -eq 1 ]]
  then
    echo -e $1
  fi
}

## TESTS
if ! test -d $dossier
then
  echo -e "Dossier '$dossier' manquant."
  exit 0
fi
# On supprime le fichier ${destination} s'il existe.
if test -f $destination
then
  echo -e "Le fichier '${destination}' existe : Suppression de ce dernier."
  rm -f $destination
fi

## DEBUT
#TODO: Prendre en compte plusieurs paramètres pour :
#  - connaître le dossier contenant les fichiers de catégorie
#  - l'extension des fichiers contenant les catégories
#  - le fichier contenant le début de la catégorie
#  - le fichier contenant la fin de la catégorie
#  - le fichier contenant une trame pour un élément
#TODO: Faire des tests sur les paramètres avant lancement du programme

# Parcours du dossier
for fichier in `find categ/ -iname "*.${extension}" -print -type f`
do
  # On met/remet la valeur de CATEG à 0 significative de l'absence 
  #+ d'une Catégorie
  CATEG=0
  # On met/remet le tableau des elements à 0
  elements_titre=()
  elements_url=()
  elements_desc=()
  elements_image_addr=()
  elements_image_titre=()
  elements_image_desc=()
  curseur_element=0
  # Calcul du nombre de ligne du fichier
  nbre_lignes=`cat ${fichier} |wc -l`
  # debug
  debug "$fichier: $nbre_lignes"
  # Vérification du nombre de lignes retourné
  if [[ $nbre_lignes -gt 0 ]]
  then
    # Récupération du nom de la catégorie
    nbre_categories=`grep -E "^\[\[.*\]\].*$" ${fichier} |wc -l`
    # Si le nombre de catégorie est égal à 1, on a tout bon
    if [[ $nbre_categories -eq 0 ]]
    then
      echo "Fichier '${fichier}' mal renseigné : Pas de nom de catégorie"
      continue
    elif [[ $nbre_categories -gt 1 ]]
    then
      echo "Fichier '${fichier}' mal renseigné : Trop de catégorie présentes."
      continue
    else
      echo "Fichier '${fichier}' correct : Catégorie présente."
    fi
    # le fichier contient plusieurs lignes, on lit le contenu
    for ligne in $(cat ${fichier})
    do
      debug "Contenu ligne : $ligne"
      # Vérifie les différents cas possibles :
      #+ SI la chaîne débute par '#'
      #+   exemple : # quelque chose
      diese_comp=`echo $ligne |sed -e 's@^\(#\).*$@\1@g'`
      debug "Comparaison dièse : $diese_comp"
      if [[ $diese_comp == "#" ]]
      then
        debug "La ligne est un commentaire : Aucune action."
        continue
      fi
      #+ SI la chaîne commence par '[[' et fini par ']]'
      #+   exemple : [[Titre]]Description de ma catégorie
      categ_comp=`echo $ligne |sed -e 's#^\(\[\[\).*\(\]\]\).*$#\1\2#g'`
      debug "Comparaison '[[]]' : $categ_comp"
      if [[ $categ_comp == "[[]]" ]]
      then
        debug "La ligne est une catégorie : Enregistrement."
        titre_categ=`echo $ligne |sed -e 's#^\[\[\(.*\)\]\].*$#\1#g'`
        desc_categ=`echo $ligne |sed -e 's#^\[\[.*\]\]\(.*\)$#\1#g'`
        debug "$titre_categ : $desc_categ"
        CATEG=1
      fi
      #+ SI la chaîne contient 6 fois '##'
      #+   exemple : Vous êtes perdus ?##http://perdu.com##Se rendre sur le site perdu.com####Mon image##Description de mon image
      element_comp=`echo $ligne |sed -e 's@^.*\(##\).*\(##\).*\(##\).*\(##\).*\(##\).*$@\1\2\3\4\5@g'`
      debug "Comparaison element : $element_comp"
      if [[ $element_comp == "##########" ]]
      then
        debug "La ligne est un élément : Enregistrement."
        # Recherche des informations pour l'élément
        element_titre=`echo $ligne |sed -e 's@^\(.*\)##.*##.*##.*##.*##.*$@\1@g'`
        element_url=`echo $ligne |sed -e 's@^.*##\(.*\)##.*##.*##.*##.*$@\1@g'`
        element_desc=`echo $ligne |sed -e 's@^.*##.*##\(.*\)##.*##.*##.*$@\1@g'`
        element_img_addr=`echo $ligne |sed -e 's@^.*##.*##.*##\(.*\)##.*##.*$@\1@g'`
        element_img_titre=`echo $ligne |sed -e 's@^.*##.*##.*##.*##\(.*\)##.*$@\1@g'`
        element_img_desc=`echo $ligne |sed -e 's@^.*##.*##.*##.*##.*##\(.*\)$@\1@g'`
        debug "Élément : titre=$element_titre, url=$element_url, desc=$element_desc, adresse_image=$element_img_addr, titre_image=$element_img_titre, desc_image=$element_img_desc"
        # Ajout des éléments dans les tableaux appropriés
        elements_titre[$curseur_element]=${element_titre:-""}
        elements_url[$curseur_element]=${element_url:-""}
        elements_desc[$curseur_element]=${element_desc:-""}
        elements_image_addr[$curseur_element]=${element_img_addr:-""}
        elements_image_titre[$curseur_element]=${element_img_titre:-""}
        elements_image_desc[$curseur_element]=${element_img_desc:-""}
        # Incrémentation du curseur du tableau contenant les éléments
        curseur_element=$(( $curseur_element + 1 ))
      fi
    done
  else
    # le fichier ne contient pas de ligne. message d'erreur
    echo -e "Fichier '$fichier' non pris en charge : Le fichier semble vide."
  fi
  # On débute la création du fichier contenant la catégorie si CATEG=1
  if [[ $CATEG == 1 ]]
  then
    echo -e "Création d'un bloc Catégorie…"
    # Tests sur la valeur de la catégorie et de l'état du curseur
    debug "Catégorie : $titre_categ : $desc_categ"
    debug "État curseur : $curseur_element"
    # Tests sur la valeur 
    debug "Fichier de début de catégorie : $deb_categ"
    debug "Destination : $destination"
    # Création du fichier pour les catégories (DÉBUT)
    cat $deb_categ |sed -e "s|@@TITRE_CATEG@@|${titre_categ}|g" -e "s|@@DESC_CATEG@@|${desc_categ}|g" >> ${destination}
    sed -i "s#^\(.*\)@@.*@@\(.*\)#\1\2#g" ${destination}
    # Préparation du numéro d'index
    i=0
    # Parcours des tableaux afin de récupérer toutes les informations
    #+ d'un élément
    while [ $i -lt $curseur_element ]
    do
      # Assignation des valeurs à des variables afin de l'afficher
      e_titre=${elements_titre[$i]:-""}           # titre element
      e_desc=${elements_desc[$i]:-""}             # description element
      e_url=${elements_url[$i]:-""}               # url element
      e_img_addr=${elements_image_addr[$i]:-""}   # adresse image
      e_img_titre=${elements_image_titre[$i]:-""} # titre image
      e_img_desc=${elements_image_desc[$i]:-""}   # description image
      # Affichage du résultat
      debug "$i : ${e_titre} || ${e_desc} || ${e_url} || ${e_img_addr} || ${e_img_titre} || ${e_img_desc}"
      # Ajout des informations dans le fichier de destination
      echo -e "\t…ajout de l'élément '${e_titre}'"
      cat $elem |sed -e "s|@@TITRE_ELEMENT@@|$e_titre|g" -e "s|@@DESC_ELEMENT@@|${e_desc}|g" -e "s|@@URL_ELEMENT@@|${e_url}|g" -e "s|@@URL_IMAGE@@|${e_img_addr}|g" -e "s|@@TITRE_IMAGE@@|${e_img_titre}|g" -e "s|@@DESC_IMAGE@@|${e_img_desc}|g" -e "s|^\(.*\)@@.*@@\(.*\)$|\1\2|g" >> ${destination}
      # Incrémentation de l'index
      let i++
    done
    # Ajout de la fin du fichier pour les catégories (FIN)
    cat $fin_categ >> ${destination}
  fi
done
