******* Este do file toma el consolidado de los datos extraidos del ICFES-SPADIES y ********
**********   UNIFICA VARIABLES CON EL FIN DE OPTIMIZAR EL TAMAÑO DE LA BASE    *************

********************************************************************************************
**********                Características iniciales de la base                          ****
***       Num vars:       243 vars                                                      ****
***       Num obs:       8.124.880                                                      ****
***       Tamaño:       11,336,04 MB                                                    ****
********************************************************************************************

set more off, perm

///// do depuracion.do //////

use "C:\TESIS\DOCUMENTO-ACCESO ES\AccesoES\datashort.dta", clear


**********************************************************************************************

gen str GENERO = estu_genero 
replace GENERO = pers_genero if mi(GENERO)
drop *_genero

**********************************************************************************************

/// para unificar las variables que contienen la fecha de nacimiento separada usamos h egen funcion concat  ///

egen str_estu_fechanacim = concat(estu_nacimiento_dia estu_nacimiento_mes estu_nacimiento_anno), punct(/) decode maxlength(10)
drop estu_nacimiento_dia estu_nacimiento_mes estu_nacimiento_anno

/// se procede a unificar las variables con la fecha completa ///

gen str FECHA_NACIMIENTO = str_estu_fechanacim
replace FECHA_NACIMIENTO = pers_fechanacimiento if mi(FECHA_NACIMIENTO)
replace FECHA_NACIMIENTO = estu_fecha_nacimiento if mi(FECHA_NACIMIENTO)
drop pers_fechanacimiento estu_fecha_nacimiento str_nacim_estu          

*********************************************************************************************

gen str TIPO_DOCUMENTO = estu_tipo_doc 
replace TIPO_DOCUMENTO = estu_tipodocumento if mi(TIPO_DOCUMENTO)
replace TIPO_DOCUMENTO =  estu_tipo_documento if mi(TIPO_DOCUMENTO)
drop estu_tipo_doc estu_tipodocumento estu_tipo_documento

********************************************************************************************

gen str MPIO_PRESENTACION = estu_exam_mpio_presentacion
foreach var in estu_reside_mpio_presentacion muni_apli estu_mcpio_presentacion {
replace MPIO_PRESENTACION = `var' if mi(MPIO_PRESENTACION)
drop estu_exam_mpio_presentacion estu_reside_mpio_presentacion muni_apli estu_mcpio_presentacion


gen MPIO_COD_PRESENTACION = estu_exam_cod_mpiopresentacion
replace MPIO_COD_PRESENTACION = cod_muni_apli if mi(MPIO_COD_PRESENTACION)
drop estu_exam_cod_mpiopresentacion cod_muni_apli 


gen str DPTO_PRESENTACION = estu_exam_dpto_presentacion
foreach var in estu_reside_dept_presentacion estu_exam_dept_presentacion estu_exam_depto_presentacion depa_apli estu_depto_presentacion {
replace DPTO_PRESENTACION = `var' if mi(DPTO_PRESENTACION)
}
drop estu_reside_dept_presentacion estu_exam_dept_presentacion estu_exam_depto_presentacion depa_apli estu_depto_presentacion

**********************************************************************************************

gen str DOCUMENTO_TIPO = estu_tipo_doc
foreach var in estu_tipodocumento  estu_tipo_documento {
replace DOCUMENTO_TIPO= `var' if mi(DOCUMENTO_TIPO)
}
drop estu_tipo_doc  estu_tipodocumento  estu_tipo_documento

*********************************************************************************************

destring estu_disc_invidente estu_disc_sordo_con_interprete estu_disc_sordo_sin_interprete estu_disc_motriz estu_disc_bajavision estu_disc_sordoceguera estu_disc_cognitiva estu_disc_sordointerprete estu_disc_sordonointerprete disc_cognitiva disc_condicion_especial dis_motriz disc_invidente disc_sordo disc_sdown disc_autismo estu_limita_cognitiva estu_limita_motriz estu_limita_invidente estu_limita_condicionespecial estu_limita_sordo estu_limita_sdown estu_limita_autismo, replace
	//// crea una variable que muestre si el estudiante cuenta con una o mas tipos de discapacidad ///
egen byte DISCAPACIDADES == rowtotal(estu_disc_invidente estu_disc_sordo_con_interprete estu_disc_sordo_sin_interprete estu_disc_motriz estu_disc_bajavision estu_disc_sordoceguera estu_disc_cognitiva estu_disc_sordointerprete estu_disc_sordonointerprete disc_cognitiva disc_condicion_especial dis_motriz disc_invidente disc_sordo disc_sdown disc_autismo estu_limita_cognitiva estu_limita_motriz estu_limita_invidente estu_limita_condicionespecial estu_limita_sordo estu_limita_sdown estu_limita_autismo)

drop estu_disc_invidente estu_disc_sordo_con_interprete estu_disc_sordo_sin_interprete estu_disc_motriz estu_disc_bajavision estu_disc_sordoceguera estu_disc_cognitiva estu_disc_sordointerprete estu_disc_sordonointerprete disc_cognitiva disc_condicion_especial dis_motriz disc_invidente disc_sordo disc_sdown disc_autismo estu_limita_cognitiva estu_limita_motriz estu_limita_invidente estu_limita_condicionespecial estu_limita_sordo estu_limita_sdown estu_limita_autismo

**********************************************************************************************

gen byte ETNIA = real(estu_etnia)
replace ETNIA = pers_etnia

drop *_etnia

**********************************************************************************************

gen byte ING_FAM_MENSUAL = real(fami_ing_fmliar_mensual)
///*** hacemos esto por que las demas variables que contienen informacion de ingreso mensual son byte %8.0g ***///
foreach var in fami_ing_fmiliar_mensual fins_ingresomensualhogar fami_ingreso_fmiliar_mensual {
replace ING_FAM_MENSUAL = `var' if mi(ING_FAM_MENSUAL)
}
drop fami_ing_fmliar_mensual fami_ing_fmiliar_mensual fins_ingresomensualhogar fami_ingreso_fmiliar_mensual

***********************************************************************************************

gen byte FAM_PERSONAS = real(fami_num_pers_grup_fam)

foreach var in econ_personas_hogar  fins_personashogaractual fami_personas_hogar {
replace FAM_PERSONAS = `var' if mi(FAM_PERSONAS)
}
drop fami_num_pers_grup_fam econ_personas_hogar fins_personashogaractual fami_personas_hogar

***********************************************************************************************

gen byte NIVEL_ED_PADRE = real(fami_cod_educa_padre)
foreach var in fins_niveleducativopadre fami_educa_padre {
replace NIVEL_ED_PADRE = `var' if mi(NIVEL_ED_PADRE)
}

gen byte NIVEL_ED_MADRE = real(fami_cod_educa_madre)
foreach var in fins_niveleducativomadre fami_educa_madre {
replace NIVEL_ED_MADRE = `var' if mi(NIVEL_ED_MADRE)
}

drop fami_cod_educa_padre fami_cod_educa_madre fins_niveleducativopadre fins_niveleducativomadre fami_educa_padre fami_educa_madre

************************************************************************************************

gen byte OCUPA_PADRE = real( fami_cod_ocup_padre)
foreach var in fins_ocupacionpadre fami_ocupa_padre {
replace OCUPA_PADRE = `var' if mi(OCUPA_PADRE)
}

gen byte OCUPA_MADRE = real(fami_cod_ocup_madre)
foreach var in fins_ocupacionmadre fami_ocupa_madre {
replace OCUPA_MADRE = `var' if mi(OCUPA_MADRE)
}

drop fami_cod_ocup_padre fami_cod_ocup_madre fins_ocupacionpadre fins_ocupacionmadre fami_ocupa_padre fami_ocupa_madre

***********************************************************************************************

gen str POSIC_HERMANOS = fami_num_her_est_sup
replace POSIC_HERMANOS = fami_posicion_entre_hnos if mi(POSIC_HERMANOS)
drop fami_num_her_est_sup fami_posicion_entre_hnos

**********************************************************************************************

gen str MUNIC_RESID = estu_reside_mpio
foreach var in  estu_reside_mcpio muni_reside estu_reside_mcipio {
replace MUNIC_RESIDE = `var' if mi(MUNIC_RESIDE)
}

gen COD_MUNIC_RESIDE = cod_muni_reside
replace COD_MUNIC_RESIDE = estu_codigo_reside_mcpio if mi(COD_MUNI_RESIDE)

drop estu_reside_mpio estu_codigo_reside_mcpio estu_reside_mcpio cod_muni_reside muni_reside estu_reside_mcipio 

**********************************************************************************************

gen str DPTO_RESIDE = estu_reside_depto
replace DPTO_RESIDE = estu_reside_dept if mi(DPTO_RESIDE)
replace DPTO_RESIDE = depa_reside if mi(DPTO_RESIDE)
drop estu_reside_depto estu_reside_dept depa_reside

**********************************************************************************************

gen byte ZONA_RESIDE = real(econ_area_vive)
replace ZONA_RESIDE = estu_zona_reside if mi(ZONA_RESIDE)
replace ZONA_RESIDE = zona_reside  if mi(ZONA_RESIDE)
drop econ_area_vive estu_zona_reside zona_reside

**********************************************************************************************
encode estu_trabaja, gen(estudiant_trabaja)
recast byte estudiant_trabaja, force
list estudiant_trabaja estu_trabaja if _n<=30, nolabel

gen byte TRABAJA = estudiant_trabaja
replace TRABAJA =  fins_trabajaactualmente if mi(TRABAJA)
drop estu_trabaja estudiant_trabaja fins_trabajaactualmente

*********************************************************************************************

replace codigo_dane = cole_cod_dane_institucion if mi(codigo_dane)

replace codigo_icfes = cole_cod_icfes if mi(codigo_icfes)
replace codigo_icfes = cole_codigo_colegio if mi (codigo_icfes)

drop cole_cod_dane_institucion cole_cod_icfes
 
/// cole_codigo_inst es str6 para unificar, falta verificar si es dane o icfes ///

*********************************************************************************************

gen str COLE_NOMBRE = cole_inst_nombre 
replace COLE_NOMBRE = nombre_sede if mi(COLE_NOMBRE)
replace COLE_NOMBRE = cole_nombre_sede if mi(COLE_NOMBRE) 

drop cole_inst_nombre nombre_sede cole_nombre_sede

*********************************************************************************************
replace jornada = cole_inst_jornada if mi(jornada)
replace jornada = cole_jornada if mi(jornada)
rename jornada JORNADA_COL

drop cole_inst_jornada cole_jornada 

**********************************************************************************************

gen byte VLR_PENSION_MENS = real(cole_inst_vlr_pension)
///*** hacemos esto por que las demas variables que contienen informacion de VALOR mensual DE PENSION son byte %8.0g ***///
foreach var in fins_valormensualpension cole_valor_pension {
replace VLR_PENSION_MENS = `var' if mi(VLR_PENSION_MENS)
}

drop cole_inst_vlr_pension fins_valormensualpension cole_valor_pension	

*********************************************************************************************

gen byte sisben1=real(fami_nivel_sisben)
recast byte sisben1, force
list fami_nivel_sisben sisben1 if _n<=30, nolabel

gen SISBEN = sisben1
replace SISBEN = fins_sisben if mi(SISBEN)

drop sisben1 fami_nivel_sisben fins_sisben

**********************************************************************************************

gen byte ESTRATO = real(estu_estrato)
foreach var un fins_estratoviviendaenergia fami_estrato_vivienda {
replace ESTRATO = `var' if mi(ESTRATO)

drop estu_estrato fins_estratoviviendaenergia fami_estrato_vivienda

***********************************************************************************************
gen byte CUARTOS_HOGAR = econ_cuartos
foreach var in econ_dormitorios econ_dormintorios fins_cuartoshogaractual fami_cuartos_hogar {
replace CUARTOS_HOGAR = `var' if mi(CUARTOS_HOGAR) 
}

drop econ_cuartos econ_dormitorios econ_dormintorios fins_cuartoshogaractual fami_cuartos_hogar

***
destring econ_material_pisos, replace
list econ_material_pisos in 1/20, nolabel

gen byte MATERIAL_PISOS = econ_material_pisos
foreach var in fins_pisoshogar fami_pisoshogar {
replace MATERIAL_PISOS = `var' if mi(MATERIAL_PISOS)
}

drop econ_material_pisos fins_pisoshogar fami_pisoshogar

***********************************************************************************************

replace infa_tienesanitario = infa_conexionsanitario if mi(infa_tienesanitario)
rename infa_tienesanitario serv_sanitario

rename infa_tieneelectricidad serv_electricidad
rename infa_tieneacueducto serv_acueducto 
rename infa_tienealcantarillado serv_alcantarillado

gen sn_telefonia =strofreal(econ_sn_telefonia)
foreach var in fins_tienetelefonofijo fami_telefono_fijo {
replace sn_telefonia = `var' if mi(sn_telefonia)
}
///quedo str, la cambiamos a byte y numero///
gen byte serv_telefono = real(sn_telefonia)


gen byte serv_celular = real(fins_tienetelefonocelular ) ///quedo str, la cambiamos a byte y numero///
rename infa_tieneaseo serv_aseo

gen sn_internet = strofreal(econ_sn_internet)
foreach var in sn_internet fins_tieneinternet {
replace fami_internet = `var' if mi(fami_internet)
}
///quedo str, la cambiamos a byte y numero///
gen byte serv_internet = real (fami_internet)

rename econ_sn_servicio_tv serv_tv


*****  
egen byte CANT_SERV_HOGAR =rowtotal(serv_* )

drop serv_* sn_telefonia sn_internet infa_conexionsanitario infa_tieneelectricidad infa_tieneacueducto infa_tienealcantarillado econ_sn_telefonia infa_tieneaseo econ_sn_internet econ_sn_servicio_tv  fins_tienetelefonofijo fins_tienetelefonocelular fins_tieneinternet  fami_telefono_fijo fami_internet infa_tienesanitario 

************************************************************************************************

gen str COMPUTADOR = econ_sn_computador
replace COMPUTADOR = fins_tienecomputador if mi(COMPUTADOR)
replace COMPUTADOR = fami_computador if mi(COMPUTADOR)

tostring infa_tienetelevisor, replace
rename infa_tienetelevisor TELEVISOR
foreach var in fins_tienetelevision fami_televisor econ_sn_televisor{
replace TELEVISOR = `var' if mi(TELEVISOR)
}


tostring econ_sn_dvd, replace
rename econ_sn_dvd DVD
foreach var in fins_tienedvd fami_dvd {
replace DVD = `var' if mi(DVD)
}


tostring econ_sn_automovil, replace
rename econ_sn_automovil AUTOMOVIL
foreach var in  fins_tieneautomovilparticular fami_automovil {
replace AUTOMOVIL = `var' if mi(AUTOMOVIL)
}


tostring econ_sn_lavadora, replace
rename econ_sn_lavadora LAVADORA 
foreach var in fins_tienelavadoraropa fami_lavadora{
replace LAVADORA = `var' if mi(LAVADORA)
}


tostring econ_sn_horno, replace
rename econ_sn_horno HORNO 
foreach var in fins_tienehornoelectricogas fami_horno {
replace HORNO = `var' if mi(HORNO)
}


tostring econ_sn_microhondas, replace
rename econ_sn_microhondas MICROONDAS
foreach var in econ_sn_microondas fins_tienehornomicroondas fami_microondas {
replace MICROONDAS = `var' if mi(MICROONDAS)
}

tostring econ_sn_nevera, replace 
rename econ_sn_nevera NEVERA
replace NEVERA = fins_tienenevera if mi(NEVERA)

tostring infa_tieneestufa, replace 
rename infa_tieneestufa ESTUFA

rename econ_sn_celular CELULAR 
rename econ_sn_motocicleta MOTOCICLETA

***
destring MOTOCICLETA CELULAR ESTUFA NEVERA MICROONDAS HORNO LAVADORA AUTOMOVIL DVD TELEVISOR COMPUTADOR, replace

recast byte MOTOCICLETA CELULAR ESTUFA NEVERA MICROONDAS HORNO LAVADORA AUTOMOVIL DVD TELEVISOR COMPUTADOR, force

egen CANT_ELECTR_HOGAR = rowtotal(MOTOCICLETA CELULAR ESTUFA NEVERA MICROONDAS HORNO LAVADORA AUTOMOVIL DVD TELEVISOR COMPUTADOR)
recast byte CANT_ELECTR_HOGAR

drop econ_sn_computador infa_tienetelevisor econ_sn_dvd econ_sn_automovil econ_sn_lavadora econ_sn_horno  econ_sn_microhondas econ_sn_nevera infa_tieneestufa econ_sn_celular econ_sn_microondas fins_tienetelevision fins_tienecomputador fins_tienedvd fins_tienelavadoraropa fins_tienehornomicroondas fins_tienenevera fins_tieneautomovilparticular fins_tienehornoelectricogas  fami_televisor fami_computador fami_dvd  fami_lavadora fami_microondas fami_automovil  fami_horno econ_sn_motocicleta econ_sn_televisor 

*********************************************************************************************
destring estu_por_oportunidades estu_por_amigosestudiando estu_por_buscandocarrera estu_por_colombiaaprende estu_por_costomatricula estu_por_influenciaalguien estu_por_interespersonal estu_por_mejorarposicionsocial estu_por_orientacionvocacional estu_por_otrarazon estu_por_tradicionfamiliar estu_por_ubicacion estu_por_unicaqueofrece, replace

recast byte estu_por_oportunidades estu_por_amigosestudiando estu_por_buscandocarrera estu_por_colombiaaprende estu_por_costomatricula estu_por_influenciaalguien estu_por_interespersonal estu_por_mejorarposicionsocial estu_por_orientacionvocacional estu_por_otrarazon estu_por_tradicionfamiliar estu_por_ubicacion estu_por_unicaqueofrece, force

//pendiente darle un valor unico a cada variable y etiquetarla despues de unificarla en MOTIVO_IES segun el motivo de eleccion de ies//
egen MOTIVO_IES = rowtotal(estu_por_oportunidades estu_por_amigosestudiando estu_por_buscandocarrera estu_por_colombiaaprende estu_por_costomatricula estu_por_influenciaalguien estu_por_interespersonal estu_por_mejorarposicionsocial estu_por_orientacionvocacional estu_por_otrarazon estu_por_tradicionfamiliar estu_por_ubicacion estu_por_unicaqueofrece )

***********************************************************************************************


























****************                                            LABELS                 ************

 




*******************************************************************************************************

rename EST_CONSECUTIVO = estu_consecutivo
rename EDAD = estu_edad 
rename AÑO_EGRESO = estu_anno_egreso
rename MES_EGRESO = estu_egreso_mes
rename PERIODO = periodo
rename 
