#!/bin/bash -
#
# parcours_categ.sh
#
# Permet de naviguer dans les éléments de chaque catégorie d'un dossier suivant
#+ la syntaxe : 
#+
#+ # Commentaire dans le fichier
#+ [[Titre de la catégorie]]Description de la catégorie
#+ titre de l'élément##http://domaine.tld/##description de l'élément##nom_image##Titre de l'image##description de l'image

## VARIABLES
DEBUG=1
dossier="categ"
IFS="
"

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

## DEBUT
# Parcours du dossier
#TODO: n'afficher que les fichiers dont l'extension est .txt (ou .ail?)
#+ À l'aide de find par exemple.
for fichier in `ls $dossier`
do
        # Calcul du nombre de ligne du fichier
        nbre_lignes=`cat ${dossier}/${fichier} |wc -l`
        # debug
        debug "$fichier: $nbre_lignes"
        # Vérification du nombre de lignes retourné
        if [[ $nbre_lignes -gt 0 ]]
        then
                # Récupération du nom de la catégorie
                nbre_categories=`grep -E "^\[\[.*\]\].*$" ${dossier}/${fichier} |wc -l`
                # Si le nombre de catégorie est égal à 1, on a tout bon
                if [[ $nbre_categories -eq 0 ]]
                then
                  echo "Fichier '${dossier}/${fichier}' mal renseigné : Pas de nom de catégorie"
                  exit 0
                elif [[ $nbre_categories -gt 1 ]]
                then
                  echo "Fichier '${dossier}/${fichier}' mal renseigné : Trop de catégorie présentes."
                  exit 0
                else
                  echo "Fichier '${dossier}/${fichier}' correct : Catégorie présente."
                fi
                # le fichier contient plusieurs lignes, on lit le contenu
                for ligne in $(cat ${dossier}/${fichier})
                do
                        debug "Contenu ligne : $ligne"
                        # Vérifier les différents cas possibles :
                        #+ SI la chaîne débute par '#'
                        #+   exemple : # quelque chose
                        diese_comp=`echo $ligne |sed -e 's@^\(#\).*$@\1@g'`
                        debug "Comparaison dièse : $diese_comp"
                        if [[ $diese_comp == "#" ]]
                        then
                            echo "La ligne est un commentaire : Aucune action."
                            continue
                        fi
                        #+ SI la chaîne commence par '[[' et fini par ']]'
                        #+   exemple : [[Titre]]Description de ma catégorie
                        categ_comp=`echo $ligne |sed -e 's#^\(\[\[\).*\(\]\]\).*$#\1\2#g'`
                        debug "Comparaison '[[]]' : $categ_comp"
                        if [[ $categ_comp == "[[]]" ]]
                        then
                            echo "La ligne est une catégorie : Enregistrement."
                            titre_categ=`echo $ligne |sed -e 's#^\[\[\(.*\)\]\].*$#\1#g'`
                            desc_categ=`echo $ligne |sed -e 's#^\[\[.*\]\]\(.*\)$#\1#g'`
                            debug "$titre_categ : $desc_categ"
                        fi
                        #+ SI la chaîne contient 6 fois '##'
                        #+   exemple : Vous êtes perdus ?##http://perdu.com##Se rendre sur le site perdu.com####Mon image##Description de mon image
                        element_comp=`echo $ligne |sed -e 's@^.*\(##\).*\(##\).*\(##\).*\(##\).*\(##\).*$@\1\2\3\4\5@g'`
                        debug "Comparaison element : $element_comp"
                        if [[ $element_comp == "##########" ]]
                        then
                            echo "La ligne est un élément : Enregistrement."
                            element_titre=`echo $ligne |sed -e 's@^\(.*\)##.*##.*##.*##.*##.*$@\1@g'`
                            element_url=`echo $ligne |sed -e 's@^.*##\(.*\)##.*##.*##.*##.*$@\1@g'`
                            element_desc=`echo $ligne |sed -e 's@^.*##.*##\(.*\)##.*##.*##.*$@\1@g'`
                            element_img_addr=`echo $ligne |sed -e 's@^.*##.*##.*##\(.*\)##.*##.*$@\1@g'`
                            element_img_titre=`echo $ligne |sed -e 's@^.*##.*##.*##.*##\(.*\)##.*$@\1@g'`
                            element_img_desc=`echo $ligne |sed -e 's@^.*##.*##.*##.*##.*##\(.*\)$@\1@g'`
                            debug "Élément : titre=$element_titre, url=$element_url, desc=$element_desc, adresse_image=$element_img_addr, titre_image=$element_img_titre, desc_image=$element_img_desc"
                        fi
                done
        else
                # le fichier ne contient pas de ligne. message d'erreur
                echo -e "Fichier '$fichier' non pris en charge : Le fichier semble vide."
        fi
done
