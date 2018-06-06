#!/bin/bash

#__author__      = 'Leidinice Silva'
#__email__       = 'leidinicesilva@gmail.br'
#__date__        = '05/26/18'
#__description__ = 'Preprocessing the RegCM4.6.0 model data with CDO'
 

echo
echo "--------------- INIT PREPROCESSING MODEL ----------------"


cd /vol3/nice/output

echo 
echo "1. Select variable (PR and T2M)"

for YEAR in `seq 2001 2005`; do
    for MON in `seq -w 01 12`; do

        echo "Data: ${YEAR}${MON}"

        cdo selname,pr amz_neb_STS.${YEAR}${MON}0100.nc pr_amz_neb_regcm_exp1_${YEAR}${MON}0100.nc
        #cdo selname,s01tas amz_neb_SRF.${YEAR}${MON}0100.nc t2m_amz_neb_regcm_exp1_${YEAR}${MON}0100.nc

    done
done	


echo 
echo "2. Concatenate data (2001-2005)"
	
cdo cat pr_amz_neb_regcm_exp1_*.nc pr_flux_amz_neb_regcm_exp1_2001-2005.nc
#cdo cat t2m_amz_neb_regcm_exp1_*.nc t2m_K_amz_neb_regcm_exp1_2001-2005.nc


echo 
echo "3. Unit convention (mm and celsius)"
cdo mulc,86400 pr_flux_amz_neb_regcm_exp1_2001-2005.nc pr_amz_neb_regcm_exp1_2001-2005.nc
#cdo addc,-273.15 t2m_K_amz_neb_regcm_exp1_2001-2005.nc t2m_amz_neb_regcm_exp1_2001-2005.nc


echo 
echo "4. Creating new areas (A1, A2, A3, A4, A5, A6, A7, A8)"

for VAR in pr; do

    echo "Variable: ${VAR}"
	
    cdo sellonlatbox,-63,-55,-9,-1 ${VAR}_amz_neb_regcm_exp1_2001-2005.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_A1.nc
    cdo sellonlatbox,-52.5,-45.5,-3.55,3.5 ${VAR}_amz_neb_regcm_exp1_2001-2005.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_A2.nc
    cdo sellonlatbox,-75,-71,-15,-11 ${VAR}_amz_neb_regcm_exp1_2001-2005.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_A3.nc
    cdo sellonlatbox,-78,-72,0,8 ${VAR}_amz_neb_regcm_exp1_2001-2005.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_A4.nc
    cdo sellonlatbox,-73,-65,-10,-3 ${VAR}_amz_neb_regcm_exp1_2001-2005.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_A5.nc
    cdo sellonlatbox,-48,-38,-5,-1 ${VAR}_amz_neb_regcm_exp1_2001-2005.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_A6.nc
    cdo sellonlatbox,-48,-38,-11,-5 ${VAR}_amz_neb_regcm_exp1_2001-2005.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_A7.nc
    cdo sellonlatbox,-38,-34,-11,-5 ${VAR}_amz_neb_regcm_exp1_2001-2005.nc ${VAR}_amz_neb_regcm_exp1_2001-2005_A8.nc

done


echo 
echo "5. Statistics index (mean and sum)"

cdo monmean pr_amz_neb_regcm_exp1_2001-2005.nc pr_amz_neb_regcm_exp1_2001-2005_monmean.nc
cdo ymonmean pr_amz_neb_regcm_exp1_2001-2005_monmean.nc pr_amz_neb_regcm_exp1_2001-2005_clim.nc
cdo -b 32 -ymonsub pr_amz_neb_regcm_exp1_2001-2005_monmean.nc -ymonmean pr_amz_neb_regcm_exp1_2001-2005_monmean.nc pr_amz_neb_regcm_exp1_2001-2005_monanom.nc

# cdo monsum t2m_amz_neb_regcm_exp1_2001-2005.nc t2m_amz_neb_regcm_exp1_2001-2005_monsum.nc
# cdo monmean t2m_amz_neb_regcm_exp1_2001-2005.nc t2m_amz_neb_regcm_exp1_2001-2005_monmean.nc
# cdo ymonmean t2m_amz_neb_regcm_exp1_2001-2005_monmean.nc t2m_amz_neb_regcm_exp1_2001-2005_clim.nc
# cdo -b 32 -ymonsub pr_amz_neb_regcm_exp1_2001-2005_monmean.nc -ymonmean pr_amz_neb_regcm_exp1_2001-2005_monmean.nc pr_amz_neb_regcm_exp1_2001-2005_monanom.nc


echo 
echo "6. Grads NC prepare (./GrADSNcPrepare)"

./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_A1.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_A2.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_A3.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_A4.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_A5.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_A6.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_A7.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_A8.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_monmean.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_clim.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_yseasmean.nc
./GrADSNcPrepare *_amz_neb_regcm_exp1_2001-2005_monanom.nc


echo 
echo "7. Deleted files"

rm *_amz_neb_regcm_exp1_*0100.nc
rm *_flux_amz_neb_regcm_exp1_2001-2005.nc


echo
echo "--------------- THE END PREPROCESSING MODEL ----------------"

