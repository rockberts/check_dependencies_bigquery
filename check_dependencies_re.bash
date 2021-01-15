#!/bin/bash
#requiere instalar  pip3 install bigquery-view-analyzer
#graba en un txt dependencias de las vistas, pasando el proyecto y el dataset
#en caso de que el bqva no se agregue en el path agregarlo asi
#nano ~/.bashrc
#export PATH="${PATH}:/home/robert_escalante/.local/bin"
#export PYTHONPATH="${PYTHONPATH}:/home/robert_escalante/.local/bin"

if [ -z "$1" ] || [ -z "$2" ] 
then
   echo "use is parameter 1 project parameter 2 dataset"
echo "project_"$1
echo "dataset_"$2
else

export PROJECT=$1
export DATASET=$2

export VIEWS=$(bq query --format=json --nouse_legacy_sql "SELECT table_name FROM "$PROJECT"."$DATASET".INFORMATION_SCHEMA.TABLES WHERE table_type='VIEW';")

for row in $(echo "${VIEWS}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
   echo "processing:..............."$PROJECT":"$DATASET"."$(_jq '.table_name')
   bqva tree --view $PROJECT":"$DATASET"."$(_jq '.table_name') >> "dependencies_for_"$PROJECT"_"$DATASET".txt"
done
fi