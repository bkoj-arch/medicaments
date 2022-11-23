#!/bin/bash

[[ ! $USER = root ]] && echo -e "Permission non accordée - Nécessite sudo" && exit 1

ddl_directory="/tmp/convertor/"
[[ -d $ddl_directory ]] && rm -r $ddl_directory
mkdir $ddl_directory
cd $ddl_directory

curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=CIS_bdpm.txt" -o "CIS_bdpm.txt"
curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=CIS_CIP_bdpm.txt" -o "CIS_CIP_bdpm.txt"
curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=CIS_COMPO_bdpm.txt" -o "CIS_COMPO_bdpm.txt"
curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=CIS_HAS_SMR_bdpm.txt" -o "CIS_HAS_SMR_bdpm.txt"
curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=CIS_HAS_ASMR_bdpm.txt" -o "CIS_HAS_ASMR_bdpm.txt"
curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=HAS_LiensPageCT_bdpm.txt" -o "HAS_LiensPageCT_bdpm.txt"
curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=CIS_GENER_bdpm.txt" -o "CIS_GENER_bdpm.txt"
curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=CIS_CPD_bdpm.txt" -o "CIS_CPD_bdpm.txt"
curl "https://base-donnees-publique.medicaments.gouv.fr/telechargement.php?fichier=CIS_InfoImportantes.txt" -o "CIS_InfoImportantes.txt"

directory="/var/lib/mysql/medicaments/source/"
[[ ! -d $directory ]] && mkdir -p $directory

from_encoding="ISO-8859-1"
to_encoding="UTF-8"
cmd_convert="iconv -f $from_encoding -t $to_encoding"
for file in *.txt
do
    new_file=${directory}${file}
    echo $new_file
    [[ -e $new_file ]] && rm $new_file
    $cmd_convert $file -o $new_file
done