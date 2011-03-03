#!/usr/bin/env bash
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
DEBUG=0
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
                            # Incrémentation
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
            # TODO: Ajouter début catégorie dans un fichier temporaire
            #+ Puis ajouter les éléments dans un fichier temporaire à part 
            #+ pour chaque element à chaque fois
            #+ Faire les sed qui vont bien pour chaque élément
            # tests catégorie et état du curseur
            debug "Catégorie : $titre_categ : $desc_categ"
            debug "État curseur : $curseur_element"
            # Préparation du numéro d'index
            i=0
            # Parcours des tableaux afin de récupérer toutes les informations
            #+ d'un élément
            while [ $i -lt $curseur_element ]
            do
              e_titre=${elements_titre[$i]:-""}           # titre element
              e_desc=${elements_desc[$i]:-""}             # description element
              e_url=${elements_url[$i]:-""}               # url element
              e_img_addr=${elements_image_addr[$i]:-""}   # adresse image
              e_img_titre=${elements_image_titre[$i]:-""} # titre image
              e_img_desc=${elements_image_desc[$i]:-""}   # description image
              debug "$i : ${e_titre} || ${e_desc} || ${e_url} || ${e_img_addr} || ${e_img_titre} || ${e_img_desc}"
              let i++
            done
#            echo ${elements_titre[0]:-""}
        fi
done
