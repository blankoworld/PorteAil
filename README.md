# Programme PorteAil ##

## À propos

PorteAil est un portail web statique dont le but principal est, comme son nom 
l'indique, de partager un ensemble de liens divers ou partagé par un seul et
même projet.

Cf. [L'article sur les portails sur l'encyclopédie Wikipédia](http://fr.wikipedia.org/wiki/Portail_%28web%29) pour de plus amples 
informations.

PorteAil est un jeu de mot entre *Porte*, *portail* et *Ail*.

### Site Web / Exemple

La page officielle du projet, mais également page d'exemple est disponible à 
l'adresse suivante : 
[http://porteail.e-mergence.org/](http://porteail.e-mergence.org/ "Se rendre sur le site officiel du projet PorteAil")

### Contact

Cf. Chapitre Contact / Bugs" en bas de page.

### Licence

Le programme PorteAil est sous **licence GPLv3**.
Vous êtes libre de diffuser le programme, de le modifier et de le 
redistribuer sous la même licence en précisant le nom de l'auteur.

Pour plus de renseignements je vous invite à lire le fichier *COPYING*
joint avec les fichiers du programme.

## Description

Le script makefile permet de générer un dossier contenant les fichiers 
suivants : 

  - index.xhtml : page de garde du portail web *PorteAil*
  - defaut.css : feuille de style de PorteAil
  - img : dossier contenant l'ensemble des fichiers images (icônes) pour 
l'affichage des éléments dans la page de garde

## Pré - requis

Ce programme fonctionne à l'aide de **GNU Make** que vous pouvez installer 
sur votre machine, par exemple sous GNU/Linux Debian à l'aide de la 
commande suivante : 

    apt-get install make

Votre système devrais aussi détenir les commandes suivantes : 

- GNU make
- cp
- rm
- GNU sed
- sh
- echo
- test
- cat
- wc
- grep

Normalement ces éléments sont inclus de base ou disponibles dans
n’importe quel système d’exploitation POSIX.

## Installation

Le programme ne requièrt aucune installation particulière. Placez le où 
vous voudrez.

En revanche il est possible d'utiliser le script **install.sh** pour copier 
le contenu du dossier **porteail** dans celui du dossier **~/public_html**.

Pour de plus amples informations sur ce script, lisez le chapitre **install.sh**.

## Configuration

Copiez le fichier **configrc.exemple** (ou bien renommez le) en *configrc*.

Sans ce fichier *configrc* le programme ne peut pas fonctionner (depuis la 
 version 0.1.1).

Pour de plus amples informations sur ce fichier, lisez le chapitre **configrc**.

## Utilisation

Il vous suffit de lancer la commande suivante dans le dossier du projet : 

    make

Cela devrait générer le dossier **porteail** dans lequel se trouve un exemple
 de résultat possible.

Un nouveau dossier **porteail** apparaît dans lequel il y a : 

- un fichier *index.html*
- une feuille de style nommée *defaut.css*
- un dossier *img* contenant… des images !

Pour supprimer les fichiers générés, il faut utiliser cette commande : 

    make clean

et cela aura pour effet de supprimer le dossier **porteail** et le fichier
**categories.html** crée par différents scripts au moment de la génération
de la page.

## Fonctionnement basique

Dans sa version 0.1 le programme s'utilise via plusieurs fichiers : 

- le fichier configrc
- le dossier categ
- le fichier composants/introduction.html
- le fichier composants/menu.html
- le dossier img

Pour chaque élément, veuillez vous référer au chapitre adéquat.

Si vous désirez personnaliser encore plus la page PorteAil, vous pouvez
 lire la section « Pour aller plus loin » qui permet de comprendre un
 peu mieux le fonctionnement du programme.

### configrc

Ce fichier apparaît depuis la version 0.1.1. Il vous permettra de changer, 
par exemple, le titre de votre page PorteAil. Ceci se fait via la 
ligne suivante : 

    TITRE=

Par exemple pour afficher "Mon super site" sur la page PorteAil, modifiez ceci
 dans le fichier configrc : 

    TITRE = Mon super site

D'autres éléments peuvent être modifiés afin de personnaliser le résultat de 
PorteAil. Pour de plus amples renseignements à ce sujet, je vous invite à lire
 le chapitre **Pour aller plus loin** du présent document.

### Le dossier *categ*

Le dossier **categ** est le dossier qui va contenir nos catégories
d'éléments.
Il faut savoir que :

- un fichier texte portant l'extension *.txt* est considéré comme 
 UNE catégorie
- le programme n'accepte que les fichiers comportant une et une 
 seule description de catégorie
- le programme va lire les éléments renseignés dans le fichier

Le format de fichier accepte 3 cas possible de lignes : 

1. les commentaires
2. une description d'une catégorie
3. une description d'un élément

Voici un commentaire : 

    # un commentaire dans le fichier

Voici une description de catégorie :

    [[Titre de ma catégorie]]Description de ma catégorie

Voici la description d'un élément (un élément par ligne) :

    Titre##URL##DESC##ADDR_IMG

où :

- Titre : est le nom affiché sur le portail de l'élément.
- URL : est l'adresse COMPLÈTE du site sur lequel l'utilisateur ira
- DESC : est la description complète de notre élément pour le passage de la 
 souris sur le lien
- ADDR_IMG : est l'adresse relative vers l'image (Cf. ci-après pour plus de 
 renseignements)

Des exemples sont donnés dans le dossier **categ**. À vous de les modifier comme 
 bon vous semble.

Astuce : Pour ordonner les catégories dans la page résultante, ajouter des 
 chiffres devant chacun de vos fichiers catégories. Par exemple :

    00-ma_categorie.txt
    01-autre_categorie.txt

Vous obtiendrez donc *ma_categorie* en premier lieu, puis *autre_categorie* 
 en second lieu.

### Le dossier *img* et Adresse de l'image

Dans la version 0.1.1, il faut indiquer l'adresse dite absolue de l'image.
 C'est à dire l'adresse à partir du dossier image source (par défaut c'est
 le dossier **img** dans lequel nous irons chercher les images).

Le dossier image source est le dossier contenant l'ensemble des images. C'est 
 un dossier dans lequel le programme va *piocher* les éléments.

Sachant que le dossier **img** contient l'ensemble des images disponibles,
il faut tout d'abord trouver l'adresse d'une image qu'on voudrait, par
exemple **apps/clock.png**.

Dans un fichier catégorie, on donnera donc l'adresse suivante comme adresse de
 l'image :

    apps/clock.png

Pour un exemple plus criant, je vous propose de lire le fichier suivant :

    categ/education.txt

qui contient un exemple de catégorie avec plusieurs éléments.

### Le fichier introduction.html

Le fichier **composants/introduction.html** contient du texte en HTML à 
insérer en début de la page PorteAil, il faut donc connaître un peu le 
langage HTML pour permettre un affichage correct de ce que vous voulez.

Par défaut cet élément n'est pas activé. Pour l'activer il suffit de 
changer la ligne suivante dans le fichier **configrc** :

    #INTRO = introduction.html

par

    INTRO = introduction.html

Vous l'aurez compris, il suffit d'enlever le premier dièse **#** du début de
ligne.

### Le fichier menu.html

À l'instar du fichier **introduction.html**, le fichier **menu.html** permet 
d'insérer un menu dans la page du PorteAil. Ceci est très utile si vous 
voulez agrémenter le portail de tout un tas d'autres pages.

Par défaut cet élément n'est pas activé. Pour l'activer il suffit de 
changer la ligne suivante dans le fichier **configrc** : 

    #MENU = menu.html

par

    MENU = menu.html

Comme pour l'introduction, il suffit de supprimer le dièse **#** en début de 
ligne.

### Le fichier install.sh

**install.sh** est un script qui permet de déplacer le résultat du programme 
PorteAil dans un dossier de son choix.

Pour l'utiliser il suffit de lancer la commande suivante :

    sh install.sh

Par défaut le script essaie de copier le tout dans le dossier **public_html** 
du dossier personnel. Par exemple le dossier **/home/olivier/public_html** 
si votre dossier personnel se trouve dans **/home/olivier**.

Pour modifier les valeurs d'origine et de destination de la copie, éditez le 
script et modifiez les valeurs suivantes :

- SRCDIR : contient l'adresse relative du dossier où se situe les fichiers 
 à copier
- DESTDIR : contient l'adresse exacte où copier les fichiers (la destination).

## Pour aller plus loin

Tous les éléments expliqués ci-avant ne seront que partiellement ou pas du 
tout expliqué pour des raisons évidentes de redondance d'information.

Nous allons donc aborder plusieurs points qui concernent la personnalisation
de PorteAil afin d'adapter le programme pour qu'il en résulte une page d'une
structure différente de celle de base.

Cela est utile dans le cas où : 

- vous connaissez le langage HTML pour faire des pages internet
- vous connaissez le langage CSS pour manier visuellement la page sans modifier
le contenu
- vous n'avez pas peur de modifier quelques lignes dans des fichiers afin de 
voir le résultat

### Utilisation de la commande make

Pour plus d'informations sur l'utilisation de la commande **make**, je vous 
renvoie à la page de manuel disponible en tapant : 

    man make

Cependant sachez que dans le fichier **GNUmakefile** il existe plusieurs sections
susceptibles d'être utilisées. Les principales sont : 

- all : génère la page de PorteAil après avoir fait divers tests d'existence
des éléments.
- clean : permet de nettoyer le dossier nommé **porteail**
- test : fait quelques tests sur l'existence des ficheirs nécessaires pour 
la compilation de la page.

### configrc

Le fichier **configrc** contient tout les éléments utiles pour personnaliser
la page de résultat.

Les lignes contenant des dièses **#** sont des commentaires pour vous aider
 à mieux comprendre le contenu du fichier.

Le fichier est scindé en plusieurs parties afin de simplifier la découverte
 des éléments : 

- configuration basique : quelques éléments à modifier pour changer 
rapidement la page de résultat
- configuration avancée : des éléments plus complexes qui ont un impact
plus grand sur la page de résultat.

Configuration basique : 

- TITRE : Cf. chapitre **Fonctionnement basique**
- STYLE : nom de la feuille de style qui ajoutera des couleurs à PorteAil 
 (seconde feuille de style en somme). Redéfinir l'ensemble des classes 
 CSS de ce fichier vous permettra de reconfigurer toute l'apparence de 
 PorteAil.
- MENU : Cf. chapitre **Fonctionnement basique**
- INTRO : Cf. chapitre **Fonctionnement basique**
- CIBLE : nom du dossier dans lequel sera généré le portail web.

Configuration avancée : 

- ACCUEIL : Titre de la page tel qu'il s'affichera sur un navigateur
- GEN_CATEGORIES : script bash lancé au moment de la création des 
 catégories. C'est ce script qui génère les catégories pour la page
 finale.
- INDEX : nom du fichier final. Par exemple *index.xhtml*
- CATEGORIES_EXT : extension des fichiers qui seront lus pour générer
 les catégories
- DEFAUT_IMG : nom de l'image - contenue par défaut dans le dossier img -
 par défaut pour un élément qui n'a pas d'image ou n'en a pas trouvé.
- ELEMENT : nom du fichier contenant le code HTML d'un élément. Se trouve 
par défaut dans le dossier *COMPOSANTS*.
- CONTENU : nom du fichier contenu le résultat de la génération des 
catégories.
- ENTETE_CAT : nom du fichier contenant le code HTML du début d'une 
catégorie. Se trouve par défaut dans le dossier *COMPOSANT*.
- ENQUEUE_CAT : nom du fichier contenant le code HTML de la fin d'une 
catégorie. Se trouve par défaut dans le dossier *COMPOSANT*.
- POST_CONTENU : nom du fichier contenant le code HTML à utiliser après 
le contenu des catégories. Se trouve par défaut dans le dossier *COMPOSANT*.
- ENTETE : nom du fichier contenant le code HTML à utiliser en début de la
 page finale.
- ENQUEUE = nom du fichier contenant le code HTML à utiliser en fin de la 
page finale
- COMPOSANTS : dossier contenant les éléments qui constitueront la page
 finale
- CATEGORIES : dossier contenant les fichiers sources des catégories.
- IMAGES : dossier par défaut contenant les images pour les éléments.
- CSS : dossier par défaut des feuilles de style
- IMAGES_CIBLE : nom du dossier qui contiendra les images utilisées par la
 page finale
- CSS_SANS_MENU : nom du fichier CSS qui s'utilise lorsque la page n'a pas
 de menu
- CSS_AVEC_MENU : idem que *CSS_SANS_MENU*, mais pour une page ayant un menu
- CSS_NOM : nom du fichier CSS final

Pour plus de renseignements, veuillez vous référer au chapitre **Les 
composants**.

### Les composants

Les composants sont les éléments qui permettent de composer la page HTML 
finale.
À cet effet la page a été scindés en plusieurs éléments : 

- entete.html : contient le début de notre page finale
- categ_deb.html : contient le début d'une catégorie
- element.html : contient l'ensemble du HTML pour UN élément donné
- categ_fin.html : contient la fin d'une catégorie
- contenu_fin.html : contient la fin du corps de la page
- enqueue.html : contient le pied de la page finale
- introduction.html : contient du HTML pouvant être ajouté après le titre
principal de la page
- menu.html : un menu à ajouter à notre page

Pour personnaliser il suffit d'éditer chacun des fichiers afin d'en 
modifier le code source.

### La création des catégorie à l'aide de creation_categ.sh

Le fichier **creation_categ.sh** permet de générer le corps de la page.
À cet effet il va parcourir un dossier, générer les catégories une à une
et les éléments associés, puis il va tout déposer dans un fichier HTML
prévu à cet effet.

Le script fonctionne avec un certain nombre de paramètres parmi : 

- dossier_cat : contient la source (dossier d'entrée) dans laquelle se trouve
les fichiers décrivant les catégories et les éléments associés.
- destination.html : contient la destination. C'est à dire le fichier dans 
lequel se situera le corps, temporairement évidemment.
- extension : extension des fichiers décrivant les catégories et leurs 
éléments associés
- dossier_composants : ce dossier réunit l'ensemble des composants de notre 
page finale. Il est utile pour récupérer le fichier **element.html**, 
disponible d'ailleurs dans la variable *elem*
- entete_cat.html : contenu HTML du début d'une catégorie
- enqueue_cat.html : contenu HTML qui marque la fin d'une catégorie
- element.html : contenu HTML qui contient UN élément
- dossier_img : dossier contenant les images dites *sources*
- destination_img : nom du dossier dans lequel seront stockées les images 
finales
- image.png : nom du fichier par défaut utilisé lorsque les images ne sont pas
trouvées
- dossier_porteail : nom du dossier dans lequel sera mise la page PorteAil

Normalement, avec toutes ces données vous devriez pouvoir tester par vous
même le résultat du script et améliorer le rendu de vos pages.

### Le dossier style

Le dossier **style** est prévu pour contenir l'ensemble des feuilles de style
disponible pour l'apparence de notre page PorteAil.

Déposez donc ici vos feuille de style et changez la variable *CSS_AVEC_MENU*
, *CSS_SANS_MENU* et *STYLE* du fichier **configrc** (Cf. Chapitre 
**configrc**).

### Le dossier img

Le dossier **img** contient, dans la version 0.1, l'ensemble des images 
utilisées pour la page finale.

Déposez-y les images que vous allez utiliser.

## SOURCES

Les sources du programme peuvent être récupérées sur 
 [un dépôt Git de l'auteur](http://git.dossmann.net/) ou via la commande suivante (à l'aide de l'outil 
 git) :

    git clone http://git.dossmann.net/scripts/porteail.git

## Contact / Bugs

Pour toute suggestion, critique constructive, remarque, notification de bugs, 
je vous invite à me joindre à l'adresse courriel suivante : 

    olivier CHEZ dossmann POINT net

Pensez à ajouter, en début d'objet de votre courriel, l'élément suivant : 

    [PorteAil]

Ceci me permettra de savoir directement de quel sujet le courriel traite.

Merci d'avance, et amusez-vous bien avec PorteAil ;-)
