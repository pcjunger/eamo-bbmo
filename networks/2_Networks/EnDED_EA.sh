INPUT_NW=EA_FlashWeave_network.tsv
INPUT_ASV=EA_ASV_table_for_EnDED.tsv
INPUT_ENV=EA_ENV.tsv
OUTPUT_NW=EA_NW_CoOcc.tsv
METHODS=CO
./EnDED/build/EnDED --input_network_file $INPUT_NW --methods ${METHODS} --II_DPI_abundance_file $INPUT_ASV --output_network_file $OUTPUT_NW
rm triplet.txt
echo log_* > LOG_EA_NW_CoOcc.tsv
less log_* >> LOG_EA_NW_CoOcc.tsv
rm log_*

for ENVID in daylength Temperature Salinity NH4 NO2 NO3 PO4 Si
do
   # Parameters
   ##############################################
   less EA_FlashWeave_network.tsv > NW_temp.txt
   tail -n+2 EA_ASV_$ENVID.txt >> NW_temp.txt
   INPUT_NW=NW_temp.txt
   INPUT_ASV=EA_ASV_table_for_EnDED.tsv
   INPUT_ENV=EA_ENV.tsv
   OUTPUT_TRIPLET=EA_Triplet_ENV_$ENVID.tsv
   OUTPUT_NW=EA_NW_ENV_$ENVID.tsv

   # Run with methods: SP,II,DPI,CO
   ##############################################
   METHODS=II,DPI
 
   ## EnDED
   ##############################################
   ./EnDED/build/EnDED --input_network_file $INPUT_NW --methods ${METHODS} --II_permutation_iteration 1000 --do_pre_jointP_comp --II_DPI_abundance_file $INPUT_ASV --II_DPI_ENVparameter_file $INPUT_ENV --output_network_file $OUTPUT_NW --output_triplet_info $OUTPUT_TRIPLET

   echo log_* > LOG_EA_NW_ENV_$ENVID.tsv
   less log_* >> LOG_EA_NW_ENV_$ENVID.tsv
   rm log_*
done
