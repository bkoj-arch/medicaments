#!/bin/bash

function request(){
    # $1 : colonne à chercher
    # $2 : valeur à chercher
    case $1 in 
        nom)
            where="c.Denomination_du_medicament LIKE '$(options $2)'";;
        sub)
            where="compo.Denomination_de_la_substance LIKE '$(options $2)'";;
        patho)
            extra_join="""
                INNER JOIN CIS_HAS_SMR AS smr ON c.Code_CIS=smr.Code_CIS
                INNER JOIN CIS_HAS_ASMR AS asmr ON c.Code_CIS=asmr.Code_CIS
                """
            where="smr.Libelle_du_SMR LIKE '%$2%' OR asmr.Libelle_du_ASMR LIKE '%$2%'"
    esac
    
    echo """
        SELECT c.Denomination_du_medicament, c.Forme_pharmaceutique, c.Voies_administration, compo.Denomination_de_la_substance, cip.Prix_du_medicament_en_euro 
        FROM CIS_bdpm AS c 
        INNER JOIN CIS_COMPO_bdpm AS compo ON c.Code_CIS=compo.Code_CIS 
        INNER JOIN CIS_CIP_bdpm AS cip ON c.Code_CIS=cip.Code_CIS
        $extra_join
        WHERE $where
        ORDER BY c.Denomination_du_medicament
        ;"""
}




echo "MEDICAMENTS"

read -p "rechercher un medicament comment? nom/patho/sub: " choix


if [ $choix = "nom" ]
then
	read -p "Quel nom?:" name
	mariadb -u bkoj --password=bkoj medicament  -e "SELECT denomination FROM CIS_bdpm WHERE denomination LIKE '%$nom%';"
elif [ $choix = "sub" ]
then
	read -p "Quelle sub?: " sub
elif [ $choix = "patho" ]
then
	read -p "Quel patho" patho
fi
