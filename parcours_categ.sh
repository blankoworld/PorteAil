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

## DEBUT
# Parcours du dossier
#TODO: n'afficher que les fichiers dont l'extension est .txt
#+ À l'aide de find par exemple
for fichier in `ls $dossier`
do
        # Calcul du nombre de ligne du fichier
        nbre_lignes=`cat ${dossier}/${fichier} |wc -l`
        # debug
        debug "$fichier: $nbre_lignes"
        # Vérification du nombre de lignes retourné
        if [[ $nbre_lignes -gt 0 ]]
        then
                # le fichier contient plusieurs lignes, on lit le contenu
                for ligne in $(cat ${dossier}/${fichier})
                do
                        debug $ligne
                        # Vérifier les différents cas possibles :
                        #+ SI la chaîne débute par '#'
                        #+ SI la chaîne commence par '[[' et fini par ']]'
                        #+ SI la chaîne contient 6 fois '##'

                        # CAS où la ligne contient des '##' :
                        #+ Solution temporaire, fonctionne moyennement
#                        nouv_ligne=`echo $ligne |tr "##" "\n"`
#                        while read element
#                        do
#                                echo $element
#                        done < $nouv_ligne
                done
        else
                # le fichier ne contient pas de ligne. message d'erreur
                echo -e "Fichier '$fichier' non pris en charge : Le fichier semble vide."
        fi
done
