* Chaper 13 missing.do
version 11
clear
use chapter13_missing 
misstable summarize ln_wagem  gradem agem ttl_expm tenurem not_smsa south blackm
misstable patterns ln_wagem  gradem agem ttl_expm tenurem not_smsa south blackm
misschk ln_wagem  gradem agem ttl_expm tenurem not_smsa south blackm, gen(d_) dummy
logit d_ln_wagem gradem agem ttl_expm tenurem not_smsa south blackm
logit d_gradem ln_wagem agem ttl_expm tenurem not_smsa south blackm
logit d_agem ln_wagem gradem ttl_expm tenurem not_smsa south blackm
logit d_ttl_expm ln_wagem gradem agem tenurem not_smsa south blackm
logit d_tenurem ln_wagem gradem agem ttl_expm not_smsa south blackm
logit d_blackm ln_wagem gradem agem ttl_expm tenurem not_smsa south

* Arbitrary missing-data pattern

* If we were concerned about distributions we could transform variables 
* prior to the imputation and then reverse this latter
* With a very big dataset, mlong only has complete case observations 
* in the 0 imputation. This can save space if that is a problem.
mi set flong
mi register imputed ln_wagem  gradem agem ttl_expm tenurem blackm
mi register regular not_smsa south 
set seed 2121
mi impute mvn ln_wagem gradem agem ttl_expm tenurem blackm, add(20)
mi estimate, noisily dftable: regress ln_wagem  gradem agem ttl_expm ///
     tenurem not_smsa south blackm, beta
* mi estimate, noisily dftable: combine_beta  regress ln_wagem  gradem agem ttl_expm ///
*     tenurem not_smsa south blackm

summarize ln_wagem  gradem agem ttl_expm tenurem not_smsa south blackm if _mi_m > 0
