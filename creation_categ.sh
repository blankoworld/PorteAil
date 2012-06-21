#!/usr/bin/env sh
#
# creation_categ.sh
#
# Permet de naviguer dans les éléments de chaque catégorie d'un dossier suivant
#+ la syntaxe : 
#+
#+ # Commentaire dans le fichier
#+ [[Titre de la catégorie]]Description de la catégorie
#+ titre de l'élément##http://domaine.tld/##description de l'élément##nom_image

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
IFS="
"
PROGRAMME=`basename $0`

## FONCTIONS
debug( )
{
  if [ "$DEBUG" -eq 1 ]
  then
    printf "$1\n" 1>&2
  fi
}

utilisation( )
{
        echo "Utilisation : $PROGRAMME dossier_cat destination.html extension composants entete_cat.html enqueue_cat.html element.html dossier_img destination_img image.png dossier_porteail"
        echo ""
        echo "Cf. Fichier LISMOI pour plus d'informations."
}

## TESTS
# Test sur les paramètres
if [ $# -ne 11 ]
then
  utilisation
  exit 1
else
  # $PROGRAMME dossier_cat destination.html extension composants entete_cat.html enqueue_cat.html element.html
  dossier=$1
  destination=$2 #"categories.html"
  extension=$3 # Extension des fichiers à prendre en compte
  dossier_composants=$4
  categ_deb="$5"
  categ_fin="$6"
  elem="$7"
  dossier_image=$8
  dest_image=$9
  image_defaut=${10}
  destination_finale=${11}
fi
# Existence dossier
if ! test -d "$dossier"
then
  echo "Dossier '$dossier' manquant."
  exit 1
fi
# Existence dossier image
if ! test -d "$dossier_image"
then
  echo "Dossier '$dossier_image' manquant."
  exit 1
fi
# Existence de l'image par défaut
if ! test -f "$image_defaut"
then
  echo "Fichier '$image_defaut' manquant."
  exit 1
fi
# On supprime le fichier ${destination} s'il existe.
if test -f "$destination"
then
  echo "Le fichier '${destination}' existe : Suppression de ce dernier."
  rm -f "$destination"
fi

# Parcours du dossier
for fichier in `find $dossier/ -iname "*.${extension}" -print -type f|sort`
do
  # On met/remet la valeur de CATEG à 0 significative de l'absence 
  #+ d'une Catégorie
  CATEG=0
  # On met/remet le tableau des elements à 0
  elements_titre=""
  elements_url=""
  elements_desc=""
  elements_image_addr=""
  curseur_element=0
  # Calcul du nombre de ligne du fichier
  nbre_lignes=`cat "${fichier}" |wc -l`
  # debug
  debug "$fichier: $nbre_lignes"
  # Vérification du nombre de lignes retourné
  if [ "$nbre_lignes" -gt 0 ]
  then
    # Récupération du nom de la catégorie
    nbre_categories=`grep -E "^\[\[.*\]\].*$" ${fichier} |wc -l`
    # Si le nombre de catégorie est égal à 1, on a tout bon
    if [ "$nbre_categories" -eq 0 ]
    then
      echo "Fichier '${fichier}' mal renseigné : Pas de nom de catégorie"
      continue
    elif [ "$nbre_categories" -gt 1 ]
    then
      echo "Fichier '${fichier}' mal renseigné : Trop de catégorie présentes."
      continue
    else
      echo "Fichier '${fichier}' correct : Catégorie présente."
    fi
    # le fichier contient plusieurs lignes, on lit le contenu
    for ligne in $(cat "${fichier}")
    do
      debug "Contenu ligne : $ligne"
      # Vérifie les différents cas possibles :
      #+ SI la chaîne débute par '#'
      #+   exemple : # quelque chose
      diese_comp=`echo "$ligne" |sed -e 's@^\(#\).*$@\1@g'`
      debug "Comparaison dièse : $diese_comp"
      if [ "$diese_comp" = '#' ]
      then
        debug "La ligne est un commentaire : Aucune action."
        continue
      fi
      #+ SI la chaîne commence par '[[' et fini par ']]'
      #+   exemple : [[Titre]]Description de ma catégorie
      categ_comp=`echo "$ligne" |sed -e 's#^\(\[\[\).*\(\]\]\).*$#\1\2#g'`
      debug "Comparaison '[[]]' : $categ_comp"
      if [ "$categ_comp" = "[[]]" ]
      then
        debug "La ligne est une catégorie : Enregistrement."
        categ_titre=`echo "$ligne" |sed -e 's#^\[\[\(.*\)\]\].*$#\1#g'`
        categ_desc=`echo "$ligne" |sed -e 's#^\[\[.*\]\]\(.*\)$#\1#g'`
        debug "$categ_titre : $categ_desc"
        CATEG=1
      fi
      #+ SI la chaîne contient 3 fois '##'
      #+   exemple : Vous êtes perdus ?##http://perdu.com##Se rendre sur le site perdu.com##apps/image.png
      element_comp=`echo $ligne |sed -e 's@^.*\(##\).*\(##\).*\(##\).*$@\1\2\3@g'`
      debug "Comparaison element : $element_comp"
      if [ "$element_comp" = "######" ]
      then
        debug "La ligne est un élément : Enregistrement."
        # Recherche des informations pour l'élément
        element_titre=`echo $ligne |sed -e 's@^\(.*\)##.*##.*##.*$@\1@g'`
        element_url=`echo $ligne |sed -e 's@^.*##\(.*\)##.*##.*$@\1@g'`
        element_desc=`echo $ligne |sed -e 's@^.*##.*##\(.*\)##.*$@\1@g'`
        element_img_addr=`echo $ligne |sed -e 's@^.*##.*##.*##\(.*\)$@\1@g'`
        element_img_titre="${element_desc}"
        element_img_desc=" "
        debug "Élément : titre=$element_titre, url=$element_url, desc=$element_desc, adresse_image=$element_img_addr, titre_image=$element_img_titre, desc_image=$element_img_desc"
        # Ajout des éléments dans les tableaux appropriés
        eval "elements_titre_${curseur_element}=\"${element_titre:-""}\""
        eval "elements_url_${curseur_element}=\"${element_url:-""}\""
        eval "elements_desc_${curseur_element}=\"${element_desc:-""}\""
        eval "elements_image_addr_${curseur_element}=\"${element_img_addr:-""}\""
        eval "elements_image_titre_${curseur_element}=\"${element_img_titre:-""}\""
        eval "elements_image_desc_${curseur_element}=\"${element_img_desc:-""}\""
        # Incrémentation du curseur du tableau contenant les éléments
        curseur_element=$(( $curseur_element + 1 ))
      fi
    done
  else
    # le fichier ne contient pas de ligne. message d'erreur
    echo "Fichier '$fichier' non pris en charge : Le fichier semble vide."
  fi
  # On débute la création du fichier contenant la catégorie si CATEG=1
  if [ "$CATEG" -eq 1 ]
  then
    echo "Création d'un bloc Catégorie…"
    # Tests sur la valeur de la catégorie et de l'état du curseur
    debug "Catégorie : $categ_titre : $categ_desc"
    debug "État curseur : $curseur_element"
    # Tests sur la valeur 
    debug "Fichier de début de catégorie : $categ_deb"
    debug "Destination : $destination"
    # Création du fichier pour les catégories (DÉBUT)
    cat $categ_deb |sed -e "s|@@TITRE_CATEG@@|${categ_titre}|g" -e "s|@@DESC_CATEG@@|${categ_desc}|g" >> ${destination}
    sed -i "s#^\(.*\)@@.*@@\(.*\)#\1\2#g" ${destination}
    # Préparation du numéro d'index
    i=0
    # Parcours des tableaux afin de récupérer toutes les informations
    #+ d'un élément
    debimg=`echo $categ_titre|md5sum |cut -d " " -f 1`
    while [ "$i" -lt "$curseur_element" ]
    do
      # Assignation des valeurs à des variables afin de l'afficher
      e_titre_tmp=$(eval echo \$elements_titre_${i})
      e_titre=${e_titre_tmp:-""}                            # titre element
      e_desc_tmp=$(eval echo \$elements_desc_${i})
      e_desc=${e_desc_tmp:-""}                              # description element
      e_url_tmp=$(eval echo \$elements_url_${i})
      # modification de l'URL suite au bug sur les & dans SED
      e_url_tmp=$(echo $e_url_tmp |sed -e 's|\&|\\&amp;|g' |sed -e 's|\=|\\=|g')
      e_url=${e_url_tmp:-""}                                # url element
      e_img_addr_tmp=$(eval echo \$elements_image_addr_${i})
      # Test de l'existence de l'image
      if ! test -f "${dossier_image}/${e_img_addr_tmp}"
      then
        # si elle n'existe pas, on prend l'image générique
        nom_img=`basename ${image_defaut}`
        source_img="$image_defaut"
      else
        nom_img=`basename ${e_img_addr_tmp}`
        source_img="${dossier_image}/${e_img_addr_tmp}"
      fi
      # On ne copie que si la destination n'existe pas déjà
      if ! test -f "${destination_finale}/${dest_image}/${nom_img}"
      then
        cp "${source_img}" "${destination_finale}/${dest_image}/${nom_img}"
      fi
      e_img_addr="${dest_image}/${nom_img}"                       # adresse image
      e_img_titre_tmp=$(eval echo \$elements_image_titre_${i})
      e_img_titre=${e_img_titre_tmp:-""}                    # titre image
      e_img_desc_tmp=$(eval echo \$elements_image_desc_${i})
      e_img_desc=${e_img_desc_tmp:-""}                      # description image
      # Affichage du résultat
      debug "$i : ${e_titre} || ${e_desc} || ${e_url} || ${e_img_addr} || ${e_img_titre} || ${e_img_desc}"
      # Ajout des informations dans le fichier de destination
      printf "\t…ajout de l'élément '${e_titre}'\n"
      cat $elem |sed -e "s|@@TITRE_ELEMENT@@|$e_titre|g" -e "s|@@DESC_ELEMENT@@|${e_desc}|g" -e "s|@@URL_ELEMENT@@|${e_url}|g" -e "s|@@URL_IMAGE@@|${e_img_addr}|g" -e "s|@@TITRE_IMAGE@@|${e_img_titre}|g" -e "s|@@DESC_IMAGE@@|${e_img_desc}|g" -e "s|^\(.*\)@@.*@@\(.*\)$|\1\2|g" >> ${destination}
      # Incrémentation de l'index
      i=`expr $i + 1` #let i++
    done
    # Ajout de la fin du fichier pour les catégories (FIN)
    cat $categ_fin >> ${destination}
  fi
done
