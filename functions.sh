#!/bin/bash

#les erreurs
SUCCESS=100
GROUP_NOT_FOUND=101 #groupe non existant
GROUPS_FOUND=102    #il existe plusieurs groupes
BAD_N_ARGUMENTS=103 #mauvais nombre d'arguments

#les couleurs
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' #No color

#la fonction usage

show_usage()
{
  echo "analyse.sh: [-h] [-v] [-t] [-m] [-g] [-v] [-n] [-p] user.."
  echo "please enter a valid user !"
}

#test de la fonction usage

export -f show_usage


#fonction qui prend en parametre le valeur de retour d'un fonction (qui la precede) et affiche un message
gestion_erreur(){
	case $1 in
		$SUCCESS )
	echo
	echo -e "${BLUE}[*] opertaion terminated ..${NC}"
	echo
		;;
		$E_BAD_ARGUMENTS)
	echo
	echo -e "${RED}[!] failed : bad number of arguments ..${NC}"
	echo	
		;;
		$E_ARCHIVES_FOUND)
	echo
	echo -e "${RED}[!] failed : multiple archives found ..${NC}"
	echo	
		;;
		$E_ARCHIVE_NOT_FOUND)
	echo
	echo -e "${RED}[!] failed : no archive found ..${NC}"
	echo	
		;;

	esac
}

#fonction show usage en menu graphique
yad_show_usage(){
	(
	yad --center --width=750 --image="gtk-dialog-info" --title="Usage" --text="Usage: analyse.sh: [-h] [-v] [-t] [-m] [-g] [-v] [-n] [-p] user.."
	)
}
export -f yad_show_usage


version(){
	if [[ $# -eq 1 ]]; then
		
		echo -e "\e[1;92m Authors: Sahar Ourak and saoud amine  \e[0m "
		echo -e "\e[1;92m version: 1.1 \e[0m "
	else
		yad --height=50 --width=500 --center --text="<span foreground='yellow'><b><big>author : Sahar Ourak and saoud amine --------------  <big>version : 1.1</big></big></b></span>"
	fi
}
export -f version

cmdmain=(
   yad
   --center --width=400
   --image="gtk-dialog-info"
   --title="YAD interface graphique"
   --text="Click a link to see a demo."
   --button="Exit":1

   --form
      --field="Show usage":btn "bash -c yad_show_usage "  
   
      
      --field="author and version":btn "bash -c version"
      --field="HELP":btn "bash -c HELP"

)


interface_graphique(){
	while true; do
	    "${cmdmain[@]}"
	    exval=$?
	    case $exval in
	        1|252) break;;
	    esac
	done
}

#interface_graphique;

menu(){
	
echo -e " ███████ "
echo -e " ██      "
echo -e " ███████ "
echo -e "      ██ "
echo -e " ███████ "
echo -e "                                                 "
echo -e ""

	echo "1-	Pour afficher le help détaillé à partir d’un fichier texte."
	echo "2-	Interface graphque (YAD)"
	echo "3-	Afficher le nom des auteurs et version du code."
	echo "4-	Affivher le nombre d'utilisateur."
	echo "5-	Lister les repertoires de chaque utilisateur."
	echo "6-	Afficher le type d'utilisateur."
	echo "7-	Afficher les utilisateurs appartenant au même groupe."
	echo "9-	QUIT"
}
#la fonction qui permet d'afficher la liste d'utilisateurs

ListeUtilisateurs()
{
  FICHIER=/etc/passwd

for utilisateur in $(cut -d: -f1 $FICHIER)
do
  echo  s$utilisateur 
  
done
}
#la fonction qui permet de retourner le nombre d'utilisateurs
returnUserNumber()
{
 echo "nombre d'utilisateurs ="
 
 echo `  getent passwd| grep -c "/bin/bash" `
}

#la fonction HELP

HELP()
{
cat HELP.txt
}
#la fonction qui retourne le type de l'utilsiateur 
typeutilisateur()
{
read -p " donner le nom de l'utilisateur : " user
grep  $user /etc/passwd | cut -d : -f 6 > verif.txt


var=$( cat verif.txt)
echo $var 

if [ "/root" =$var ]
then
echo "l'utilisateur est administratif "
fi

grep  $user /etc/passwd | cut -d : -f 7 > verif1.txt
var1=$(cat verif1.txt)

if [ "/bin/false" =$var ]
then
echo "l'utilisateur est administratif "
else
echo "l'utilsiateur est simple"
fi
}

#la fonction qui liste les repertoires 
rep()
{
ls /home > rep
while read ligne 
do
echo "utilisateur : $ligne || son repertoire:"   
ls /home/$ligne

done < rep
}

#la fonction de groupe
groupeutilisateur()
{
read -p" donner le nom de groupe :" group 
FICHIER=/etc/group
grep  $group $FICHIER | cut -d : -f 4,5,6
}

#test de la fonction HELP

export -f HELP

#tester la présence d'au moins un argument

if [[ $# -eq "0" ]];
then
   show_usage
exit
fi

while getopts "nars:mgvh" option
do
echo "getopts a trouvé l'option $option"
case $option in
	h)
		clear
		HELP 
		#menu
	;;

	g)
		clear
		interface_graphique
	;;

	v)	
		clear
		version 
		#menu
	;;

	n)	
		clear
               returnUserNumber

		
	;;

	p) 
		clear
                rep
		
	;;

	t)
		clear
		
                typeutilisateur
	;;

	G)
		clear
		groupeutilisateur
	;;



	m)
		clear
		menu

		while (true)
	do

		echo "Votre choix : "
	read choice
	case $choice in

			1)
	clear
	HELP 
	menu
			;;

			2)
	clear
	interface_graphique
	menu
			;;

			3)
	clear
	version 
	menu
			;;

            4)
	clear
	returnUserNumber
	gestion_erreur $?
	menu
			;;

			5)
	clear
        rep
	gestion_erreur $?
	menu
			;;

			6)
	clear
	typeutilisateur
	gestion_erreur $?	
	menu
			;;

			7)
	clear
	groupeutilisateur
	gestion_erreur $?	
	menu
			;;


			9)
	clear
	echo "Au revoir $USER"
			exit
			;;


			*)
	clear
	echo "mauvais choix"		 			
	menu
			;;
	
	esac

	done
	;;

esac
done
echo "Analyse des options terminée"
exit 0
