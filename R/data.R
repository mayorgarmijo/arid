#' Human isotopic data from the Atacama Desert
#'
#' @description
#' Stable isotope measurements from human skeletal and soft tissue samples
#' recovered at archaeological sites in northern Chile (Arica y Parinacota,
#' Tarapacá, and Antofagasta regions).
#'
#' Mediciones de isótopos estables de muestras de tejido esquelético y blando
#' humano provenientes de sitios arqueológicos del norte de Chile (regiones de
#' Arica y Parinacota, Tarapacá y Antofagasta).
#'
#' @format A data frame with 1,821 rows and 48 columns:
#' \describe{
#'   \item{site_name}{Archaeological site identifier / Identificador del sitio arqueológico}
#'   \item{period_broad}{Broad period category (e.g. Archaic, Formative, Late) / Período general (p.ej. Arcaico, Formativo, Tardío)}
#'   \item{sample_id}{Unique sample identifier / Identificador único de muestra}
#'   \item{lat}{Latitude in decimal degrees / Latitud en grados decimales}
#'   \item{lon}{Longitude in decimal degrees / Longitud en grados decimales}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{period}{Sub-period or phase within the broad period (e.g. Early Formative, Late Formative) / Subperíodo o fase dentro del período general (p.ej. Formativo Temprano, Formativo Tardío)}
#'   \item{period_from}{Start of period in calibrated years BP / Inicio del período en años calibrados AP}
#'   \item{period_to}{End of period in calibrated years BP / Fin del período en años calibrados AP}
#'   \item{c14_method}{Radiocarbon dating method (AMS, conventional) / Método de datación radiocarbónica}
#'   \item{c14_lab_code}{Laboratory code for the radiocarbon date / Código de laboratorio de la datación}
#'   \item{c14_bp}{Radiocarbon age in years BP / Edad radiocarbónica en años AP}
#'   \item{c14_error}{Standard error of the radiocarbon date / Error estándar de la datación}
#'   \item{c14_cal_from}{Lower bound of calibrated date range (cal BP) / Límite inferior del rango calibrado}
#'   \item{c14_cal_to}{Upper bound of calibrated date range (cal BP) / Límite superior del rango calibrado}
#'   \item{material_dated}{Material used for radiocarbon dating / Material utilizado para la datación}
#'   \item{lab_id}{Laboratory sample identifier / Identificador de muestra en laboratorio}
#'   \item{sex}{Biological sex (Male, Female, Indeterminate) / Sexo biológico}
#'   \item{age_category}{Broad age category (Adult, Subadult, etc.) / Categoría etaria amplia}
#'   \item{age_min}{Minimum estimated age in years / Edad mínima estimada en años}
#'   \item{age_max}{Maximum estimated age in years / Edad máxima estimada en años}
#'   \item{sample_type}{Type of sample (bone, hair, etc.) / Tipo de muestra}
#'   \item{tissue}{Tissue type for organic isotope measurements / Tipo de tejido para mediciones orgánicas}
#'   \item{element}{Skeletal element sampled / Elemento esquelético muestreado}
#'   \item{tissue_age}{Age of the tissue in cal BP / Edad del tejido en años calibrados AP}
#'   \item{tissue_age_min}{Minimum tissue age in cal BP / Edad mínima del tejido en cal AP}
#'   \item{tissue_age_max}{Maximum tissue age in cal BP / Edad máxima del tejido en cal AP}
#'   \item{yield_pct}{Collagen yield percentage / Rendimiento de colágeno en porcentaje}
#'   \item{wt_C}{Weight percent carbon in collagen / Porcentaje en peso de carbono en el colágeno}
#'   \item{wt_N}{Weight percent nitrogen in collagen / Porcentaje en peso de nitrógeno en el colágeno}
#'   \item{CN_ratio}{Atomic C:N ratio (collagen quality indicator) / Relación C:N atómica (indicador de calidad)}
#'   \item{d13C}{δ¹³C from organic tissue (‰ VPDB) / δ¹³C de tejido orgánico (‰ VPDB)}
#'   \item{d15N}{δ¹⁵N from organic tissue (‰ AIR) / δ¹⁵N de tejido orgánico (‰ AIR)}
#'   \item{wt_S}{Weight percent sulfur / Porcentaje en peso de azufre}
#'   \item{d34S}{δ³⁴S (‰ VCDT)}
#'   \item{tissue_carbonate}{Tissue type for carbonate measurements / Tipo de tejido para mediciones de carbonato}
#'   \item{element_carbonate}{Skeletal element for carbonate sampling / Elemento esquelético para carbonato}
#'   \item{tissue_age_carbonate}{Age of carbonate tissue in cal BP / Edad del tejido de carbonato en cal AP}
#'   \item{tissue_age_carbonate_min}{Minimum carbonate tissue age in cal BP / Edad mínima del tejido de carbonato}
#'   \item{tissue_age_carbonate_max}{Maximum carbonate tissue age in cal BP / Edad máxima del tejido de carbonato}
#'   \item{d13C_carbonate}{δ¹³C from bone/enamel apatite (‰ VPDB) / δ¹³C de apatita ósea/dental (‰ VPDB)}
#'   \item{d18O_carbonate}{δ¹⁸O from bone/enamel apatite (‰ VPDB) / δ¹⁸O de apatita ósea/dental (‰ VPDB)}
#'   \item{Sr87_Sr86}{⁸⁷Sr/⁸⁶Sr strontium isotope ratio / Relación isotópica de estroncio ⁸⁷Sr/⁸⁶Sr}
#'   \item{reference_short}{Short citation for the data source / Referencia bibliográfica abreviada}
#'   \item{doi}{DOI linking to the original publication / DOI de la publicación original}
#'   \item{locality}{Site locality (e.g. Lower Azapa Valley) / Localidad del sitio}
#'   \item{admin_region}{Administrative region / Región administrativa}
#'   \item{ecozone}{Ecological zone: Coast, Lowlands, Precordillera, or Altiplano / Zona ecológica}
#' }
#'
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_humans"


#' Faunal isotopic data from the Atacama Desert
#'
#' @description
#' Stable isotope measurements from animal remains (bone, tooth, hair, feather,
#' and other tissues) recovered at archaeological sites in northern Chile.
#'
#' Mediciones de isótopos estables de restos faunísticos (hueso, diente, pelo,
#' pluma y otros tejidos) provenientes de sitios arqueológicos del norte de Chile.
#'
#' @format A data frame with 362 rows and 40 columns:
#' \describe{
#'   \item{site_name}{Archaeological site identifier / Identificador del sitio arqueológico}
#'   \item{sample_id}{Unique sample identifier / Identificador único de muestra}
#'   \item{lat}{Latitude in decimal degrees / Latitud en grados decimales}
#'   \item{lon}{Longitude in decimal degrees / Longitud en grados decimales}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{period}{Broad cultural or chronological period / Período cultural o cronológico amplio}
#'   \item{period_from}{Start of period in calibrated years BP / Inicio del período en años calibrados AP}
#'   \item{period_to}{End of period in calibrated years BP / Fin del período en años calibrados AP}
#'   \item{c14_method}{Radiocarbon dating method / Método de datación radiocarbónica}
#'   \item{c14_lab_code}{Laboratory code for the radiocarbon date / Código de laboratorio}
#'   \item{c14_bp}{Radiocarbon age in years BP / Edad radiocarbónica en años AP}
#'   \item{c14_error}{Standard error of the radiocarbon date / Error estándar de la datación}
#'   \item{c14_cal_from}{Lower bound of calibrated date range (cal BP) / Límite inferior del rango calibrado}
#'   \item{c14_cal_to}{Upper bound of calibrated date range (cal BP) / Límite superior del rango calibrado}
#'   \item{material_dated}{Material used for radiocarbon dating / Material utilizado para la datación}
#'   \item{lab_id}{Laboratory sample identifier / Identificador de muestra en laboratorio}
#'   \item{type_source}{Whether the animal is wild or domestic / Si el animal es silvestre o doméstico}
#'   \item{taxon_local}{Local common name of the taxon / Nombre local del taxón}
#'   \item{genus_species}{Scientific name (genus and species) / Nombre científico (género y especie)}
#'   \item{sample_type}{Type of sample / Tipo de muestra}
#'   \item{tissue}{Tissue type for organic isotope measurements / Tipo de tejido para mediciones orgánicas}
#'   \item{element}{Skeletal element sampled / Elemento esquelético muestreado}
#'   \item{yield_pct}{Collagen yield percentage / Rendimiento de colágeno en porcentaje}
#'   \item{wt_C}{Weight percent carbon / Porcentaje en peso de carbono}
#'   \item{wt_N}{Weight percent nitrogen / Porcentaje en peso de nitrógeno}
#'   \item{CN_ratio}{Atomic C:N ratio / Relación C:N atómica}
#'   \item{d13C}{δ¹³C from organic tissue (‰ VPDB) / δ¹³C de tejido orgánico (‰ VPDB)}
#'   \item{d15N}{δ¹⁵N from organic tissue (‰ AIR) / δ¹⁵N de tejido orgánico (‰ AIR)}
#'   \item{wt_S}{Weight percent sulfur / Porcentaje en peso de azufre}
#'   \item{d34S}{δ³⁴S (‰ VCDT)}
#'   \item{tissue_carbonate}{Tissue type for carbonate measurements / Tipo de tejido para carbonato}
#'   \item{element_carbonate}{Skeletal element for carbonate sampling / Elemento para carbonato}
#'   \item{d13C_carbonate}{δ¹³C from bone/enamel apatite (‰ VPDB) / δ¹³C de apatita ósea/dental}
#'   \item{d18O_carbonate}{δ¹⁸O from bone/enamel apatite (‰ VPDB) / δ¹⁸O de apatita ósea/dental}
#'   \item{Sr87_Sr86}{⁸⁷Sr/⁸⁶Sr strontium isotope ratio / Relación isotópica de estroncio}
#'   \item{reference_short}{Short citation for the data source / Referencia bibliográfica abreviada}
#'   \item{doi}{DOI linking to the original publication / DOI de la publicación original}
#'   \item{locality}{Site locality / Localidad del sitio}
#'   \item{admin_region}{Administrative region / Región administrativa}
#'   \item{ecozone}{Ecological zone: Coast, Lowlands, Precordillera, or Altiplano / Zona ecológica}
#' }
#'
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_animals"


#' Plant isotopic data from the Atacama Desert
#'
#' @description
#' Stable isotope measurements from botanical remains (seeds, stems, leaves,
#' charcoal, and other plant materials) recovered at archaeological sites in
#' northern Chile.
#'
#' Mediciones de isótopos estables de restos botánicos (semillas, tallos, hojas,
#' carbón y otros materiales vegetales) provenientes de sitios arqueológicos del
#' norte de Chile.
#'
#' @format A data frame with 576 rows and 33 columns:
#' \describe{
#'   \item{site_name}{Archaeological site identifier / Identificador del sitio arqueológico}
#'   \item{sample_id}{Unique sample identifier / Identificador único de muestra}
#'   \item{lat}{Latitude in decimal degrees / Latitud en grados decimales}
#'   \item{lon}{Longitude in decimal degrees / Longitud en grados decimales}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{period}{Broad cultural or chronological period / Período cultural o cronológico amplio}
#'   \item{period_from}{Start of period in calibrated years BP / Inicio del período en años calibrados AP}
#'   \item{period_to}{End of period in calibrated years BP / Fin del período en años calibrados AP}
#'   \item{c14_method}{Radiocarbon dating method / Método de datación radiocarbónica}
#'   \item{c14_lab_code}{Laboratory code for the radiocarbon date / Código de laboratorio}
#'   \item{c14_bp}{Radiocarbon age in years BP / Edad radiocarbónica en años AP}
#'   \item{c14_error}{Standard error of the radiocarbon date / Error estándar de la datación}
#'   \item{c14_cal_from}{Lower bound of calibrated date range (cal BP) / Límite inferior del rango calibrado}
#'   \item{c14_cal_to}{Upper bound of calibrated date range (cal BP) / Límite superior del rango calibrado}
#'   \item{lab_id}{Laboratory sample identifier / Identificador de muestra en laboratorio}
#'   \item{type_source}{Whether the plant is wild or cultivated / Si la planta es silvestre o cultivada}
#'   \item{taxon_local}{Local common name of the taxon / Nombre local del taxón}
#'   \item{genus_species}{Scientific name (genus and species) / Nombre científico}
#'   \item{photosynthetic_pathway}{Photosynthetic pathway (C3, C4, or CAM) / Vía fotosintética}
#'   \item{plant_domesticate}{Whether the plant is a domesticate / Si la planta es un domesticado}
#'   \item{sample_type}{Type of sample / Tipo de muestra}
#'   \item{wt_C}{Weight percent carbon / Porcentaje en peso de carbono}
#'   \item{wt_N}{Weight percent nitrogen / Porcentaje en peso de nitrógeno}
#'   \item{CN_ratio}{Atomic C:N ratio / Relación C:N atómica}
#'   \item{d13C}{δ¹³C (‰ VPDB)}
#'   \item{d15N}{δ¹⁵N (‰ AIR)}
#'   \item{d34S}{δ³⁴S (‰ VCDT)}
#'   \item{Sr87_Sr86}{⁸⁷Sr/⁸⁶Sr strontium isotope ratio / Relación isotópica de estroncio}
#'   \item{reference_short}{Short citation for the data source / Referencia bibliográfica abreviada}
#'   \item{doi}{DOI linking to the original publication / DOI de la publicación original}
#'   \item{locality}{Site locality / Localidad del sitio}
#'   \item{admin_region}{Administrative region / Región administrativa}
#'   \item{ecozone}{Ecological zone: Coast, Lowlands, Precordillera, or Altiplano / Zona ecológica}
#' }
#'
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_plants"


#' Archaeological site information for the Atacama Desert
#'
#' @description
#' Geographic, ecological, and chronological context for 203 archaeological
#' sites included in ARID. This table links site names to administrative regions,
#' ecozones, coordinates, and cultural periods.
#'
#' Contexto geográfico, ecológico y cronológico de 203 sitios arqueológicos
#' incluidos en ARID. Esta tabla vincula los nombres de sitio con regiones
#' administrativas, ecozonas, coordenadas y períodos culturales.
#'
#' @format A data frame with 203 rows and 10 columns:
#' \describe{
#'   \item{site_name}{Archaeological site identifier (primary key) / Identificador del sitio (clave primaria)}
#'   \item{lat}{Latitude in decimal degrees / Latitud en grados decimales}
#'   \item{lon}{Longitude in decimal degrees / Longitud en grados decimales}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{locality}{Broader locality or valley (e.g. Lower Azapa Valley) / Localidad o valle (e.g. Valle Azapa Bajo)}
#'   \item{admin_region}{Administrative region: Arica y Parinacota, Tarapacá, or Antofagasta / Región administrativa}
#'   \item{ecozone}{Ecological zone based on altitude: Coast (< 130 masl), Lowlands (130–1700 masl), Precordillera (1700–3700 masl), or Altiplano (> 3700 masl) / Zona ecológica basada en altitud}
#'   \item{period}{Broad cultural or chronological period / Período cultural o cronológico amplio}
#'   \item{period_from}{Start of period in calibrated years BP / Inicio del período en años calibrados AP}
#'   \item{period_to}{End of period in calibrated years BP / Fin del período en años calibrados AP}
#' }
#'
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_sites"

#' Radiocarbon dates from the Atacama Desert
#'
#' @description
#' A compilation of 1,003 radiocarbon dates from archaeological contexts in the
#' Tarapacá and Arica y Parinacota regions of northern Chile, derived from the
#' supplementary material of Méndez-Quiros et al. (2023). Includes contextual
#' information (site, unit, material, context type) and calibrated age ranges.
#' The \code{d13C_ams} column contains δ¹³C values used for AMS correction, not
#' for dietary isotopic analysis.
#'
#' Compilación de 1,003 fechados radiocarbónicos de contextos arqueológicos de
#' las regiones de Tarapacá y Arica y Parinacota (norte de Chile), obtenidos del
#' material suplementario de Méndez-Quiros et al. (2023). Incluye información
#' contextual (sitio, unidad, material, tipo de contexto) y rangos de edad
#' calibrada. La columna \code{d13C_ams} contiene valores de δ¹³C utilizados para
#' la corrección AMS, no para análisis isotópico dietético.
#'
#' @format A data frame with 1,003 rows and 23 columns:
#' \describe{
#'   \item{record_id}{Sequential record identifier / Identificador secuencial de registro}
#'   \item{admin_region}{Administrative region: Arica y Parinacota or Tarapacá / Región administrativa}
#'   \item{basin}{Hydrological basin or coastal zone / Cuenca hidrológica o zona costera}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{altitudinal_belt}{Altitudinal belt label from original publication / Piso altitudinal según publicación original}
#'   \item{site_name}{Archaeological site name / Nombre del sitio arqueológico}
#'   \item{unit}{Excavation unit / Unidad de excavación}
#'   \item{sub_unit}{Sub-unit within the excavation unit / Sub-unidad dentro de la unidad de excavación}
#'   \item{c14_lab_code}{Radiocarbon laboratory code / Código de laboratorio de radiocarbono}
#'   \item{material}{Broad material category dated / Categoría general del material fechado}
#'   \item{material_detail}{Specific material description / Descripción específica del material}
#'   \item{c14_bp}{Conventional radiocarbon age (years BP) / Edad radiocarbónica convencional (años AP)}
#'   \item{c14_error}{Measurement error (±1σ) / Error de medición (±1σ)}
#'   \item{d13C_ams}{δ¹³C value used for AMS fractionation correction (‰ VPDB) — not for dietary analysis / Valor de δ¹³C para corrección de fraccionamiento AMS (‰ VPDB) — no para análisis dietético}
#'   \item{reference_short}{Short bibliographic reference / Referencia bibliográfica abreviada}
#'   \item{context_domestic}{Domestic context flag (X = yes) / Indicador de contexto doméstico (X = sí)}
#'   \item{context_funerary}{Funerary context flag (X = yes) / Indicador de contexto funerario (X = sí)}
#'   \item{context_agriculture}{Agricultural context flag (X = yes) / Indicador de contexto agrícola (X = sí)}
#'   \item{context_other}{Other context flag (X = yes) / Indicador de otro tipo de contexto (X = sí)}
#'   \item{c14_cal_from}{Calibrated age range start (cal BP, 2σ 95%) / Inicio del rango de edad calibrada (cal AP, 2σ 95%)}
#'   \item{c14_cal_to}{Calibrated age range end (cal BP, 2σ 95%) / Fin del rango de edad calibrada (cal AP, 2σ 95%)}
#'   \item{c14_cal_median}{Median calibrated age (cal BP) / Mediana de la edad calibrada (cal AP)}
#'   \item{ecozone}{Ecological zone based on altitude: Coast (< 130 masl), Lowlands (130–1700 masl), Precordillera (1700–3700 masl), or Altiplano (> 3700 masl) / Zona ecológica basada en altitud}
#' }
#'
#' @source Méndez-Quiros, P., et al. (2023). Supplementary material. Available via ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_c14"
