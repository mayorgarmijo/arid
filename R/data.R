#' Human isotopic data from the Atacama Desert
#'
#' @description
#' Stable isotope measurements from human skeletal and soft tissue samples
#' recovered at archaeological sites in northern Chile (Arica y Parinacota,
#' Tarapaca, and Antofagasta regions). Stored in long format: one row per
#' tissue analysed. Individuals with both organic and carbonate measurements
#' appear in two rows distinguished by the `tissue_type` column.
#' Radiocarbon dates are stored separately in `arid_c14` (linked via `lab_id`).
#'
#' Mediciones de isotópos estables de muestras de tejido esquelético y blando
#' humano de sitios arqueológicos del norte de Chile. Formato largo: una fila
#' por tejido analizado. Los fechados radiocarbónicos se almacenan en `arid_c14`
#' (vinculados mediante `lab_id`).
#'
#' @format A data frame with 2,606 rows and 37 columns:
#' \describe{
#'   \item{site_name}{Archaeological site identifier / Identificador del sitio arqueológico}
#'   \item{period_broad}{Broad period category (e.g. Archaic, Formative, Late Intermediate, Late) / Período general}
#'   \item{period}{Sub-period or phase (e.g. Early Archaic, Late Formative) / Subperíodo o fase}
#'   \item{lab_id}{Laboratory identifier linking to `arid_c14` for radiocarbon dates / Identificador de laboratorio (vínculo con `arid_c14`)}
#'   \item{period_from}{Start of cultural period (BCE/CE; negative = BCE) / Inicio del período cultural (a.C./d.C.; negativo = a.C.)}
#'   \item{period_to}{End of cultural period (BCE/CE) / Fin del período cultural (a.C./d.C.)}
#'   \item{sample_id}{Unique sample identifier / Identificador único de muestra}
#'   \item{lat}{Latitude in decimal degrees / Latitud en grados decimales}
#'   \item{lon}{Longitude in decimal degrees / Longitud en grados decimales}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{sex}{Biological sex (Male, Female, Indeterminate) / Sexo biológico}
#'   \item{age_category}{Broad age category (Adult, Subadult, etc.) / Categoría etaria}
#'   \item{age_min}{Minimum estimated age in years / Edad mínima estimada en años}
#'   \item{age_max}{Maximum estimated age in years / Edad máxima estimada en años}
#'   \item{sample_type}{Physical sample type (Bone, Hair, Tooth, etc.) / Tipo de muestra física}
#'   \item{reference_short}{Short bibliographic citation / Referencia bibliográfica abreviada}
#'   \item{doi}{DOI of the original publication / DOI de la publicación original}
#'   \item{locality}{Site locality (e.g. Lower Azapa Valley) / Localidad del sitio}
#'   \item{admin_region}{Administrative region (Arica y Parinacota, Tarapaca, or Antofagasta) / Región administrativa}
#'   \item{ecozone}{Ecological zone based on altitude: Coast (<130 masl), Lowlands (130-1700 masl), Precordillera (1700-3700 masl), or Altiplano (>3700 masl) / Zona ecológica}
#'   \item{has_c14}{Whether a direct radiocarbon date exists in `arid_c14` for this sample / Si existe un fechado radiocarbónico en `arid_c14` para esta muestra}
#'   \item{tissue}{Tissue type analysed (e.g. Bone collagen, Hair keratin, Bone apatite) / Tejido analizado}
#'   \item{element}{Skeletal or anatomical element sampled / Elemento esquelético o anatómico muestreado}
#'   \item{tissue_age}{Estimated age of the tissue in cal BP / Edad estimada del tejido en cal AP}
#'   \item{tissue_age_min}{Minimum tissue age in cal BP / Edad mínima del tejido en cal AP}
#'   \item{tissue_age_max}{Maximum tissue age in cal BP / Edad máxima del tejido en cal AP}
#'   \item{yield_pct}{Collagen yield percentage (organic rows only) / Rendimiento de colágeno en porcentaje (solo filas orgánicas)}
#'   \item{wt_C}{Weight percent carbon (organic rows only) / Porcentaje en peso de carbono}
#'   \item{wt_N}{Weight percent nitrogen (organic rows only) / Porcentaje en peso de nitrógeno}
#'   \item{CN_ratio}{Atomic C:N ratio — collagen quality indicator (organic rows only) / Relación C:N atómica}
#'   \item{d13C}{delta-13C (‰ VPDB) / delta-13C (por mil VPDB)}
#'   \item{d15N}{delta-15N from organic tissue (‰ AIR; organic rows only) / delta-15N de tejido organico (por mil AIR)}
#'   \item{wt_S}{Weight percent sulfur (organic rows only) / Porcentaje en peso de azufre}
#'   \item{d34S}{delta-34S (‰ VCDT; organic rows only) / delta-34S (por mil VCDT)}
#'   \item{Sr87_Sr86}{87Sr/86Sr strontium isotope ratio (organic rows only) / Relacion isotopica de estroncio 87Sr/86Sr}
#'   \item{tissue_type}{"organic" or "carbonate" — identifies which tissue block each row represents / "organic" o "carbonate"}
#'   \item{d18O}{delta-18O from carbonate tissue (‰ VPDB; carbonate rows only) / delta-18O de tejido carbonato (por mil VPDB)}
#' }
#'
#' @seealso [arid_c14] for radiocarbon dates; [arid_chronology()] to assign dates.
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_humans"


#' Faunal isotopic data from the Atacama Desert
#'
#' @description
#' Stable isotope measurements from animal remains recovered at archaeological
#' sites in northern Chile. Stored in long format: one row per tissue analysed.
#' Individuals with both organic (collagen/keratin) and carbonate (apatite)
#' measurements appear in two rows. Radiocarbon dates are in `arid_c14`.
#'
#' Mediciones de isótopos estables de restos faunísticos de sitios arqueológicos
#' del norte de Chile. Formato largo: una fila por tejido analizado. Los fechados
#' radiocarbónicos se almacenan en `arid_c14`.
#'
#' @format A data frame with 424 rows and 33 columns:
#' \describe{
#'   \item{site_name}{Archaeological site identifier / Identificador del sitio arqueológico}
#'   \item{sample_id}{Unique sample identifier / Identificador único de muestra}
#'   \item{lat}{Latitude in decimal degrees / Latitud en grados decimales}
#'   \item{lon}{Longitude in decimal degrees / Longitud en grados decimales}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{period}{Sub-period or phase / Subperíodo o fase}
#'   \item{period_from}{Start of cultural period (BCE/CE; negative = BCE) / Inicio del período (a.C./d.C.)}
#'   \item{period_to}{End of cultural period (BCE/CE) / Fin del período (a.C./d.C.)}
#'   \item{lab_id}{Laboratory identifier linking to `arid_c14` / Identificador de laboratorio}
#'   \item{type_source}{Wild or domestic / Silvestre o doméstico}
#'   \item{taxon_local}{Local common name of the taxon / Nombre local del taxón}
#'   \item{genus_species}{Scientific name (genus and species) / Nombre científico}
#'   \item{sample_type}{Physical sample type (Bone, Fur, Feather, etc.) / Tipo de muestra física}
#'   \item{reference_short}{Short bibliographic citation / Referencia bibliográfica abreviada}
#'   \item{doi}{DOI of the original publication / DOI de la publicación original}
#'   \item{locality}{Site locality / Localidad del sitio}
#'   \item{admin_region}{Administrative region / Región administrativa}
#'   \item{ecozone}{Ecological zone / Zona ecológica}
#'   \item{period_broad}{Broad period category / Período general}
#'   \item{has_c14}{Whether a direct radiocarbon date exists in `arid_c14` / Si existe fechado radiocarbónico en `arid_c14`}
#'   \item{tissue}{Tissue type analysed / Tejido analizado}
#'   \item{element}{Skeletal or anatomical element sampled / Elemento muestreado}
#'   \item{yield_pct}{Collagen yield percentage (organic rows only) / Rendimiento de colágeno}
#'   \item{wt_C}{Weight percent carbon / Porcentaje en peso de carbono}
#'   \item{wt_N}{Weight percent nitrogen / Porcentaje en peso de nitrógeno}
#'   \item{CN_ratio}{Atomic C:N ratio / Relación C:N atómica}
#'   \item{d13C}{delta-13C (‰ VPDB) / delta-13C (por mil VPDB)}
#'   \item{d15N}{delta-15N from organic tissue (‰ AIR) / delta-15N de tejido orgánico}
#'   \item{wt_S}{Weight percent sulfur / Porcentaje en peso de azufre}
#'   \item{d34S}{delta-34S (‰ VCDT) / delta-34S (por mil VCDT)}
#'   \item{Sr87_Sr86}{87Sr/86Sr strontium isotope ratio / Relacion isotopica de estroncio}
#'   \item{tissue_type}{"organic" or "carbonate" / "organic" o "carbonate"}
#'   \item{d18O}{delta-18O from carbonate tissue (‰ VPDB; carbonate rows only) / delta-18O de tejido carbonato}
#' }
#'
#' @seealso [arid_c14] for radiocarbon dates; [arid_chronology()] to assign dates.
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_animals"


#' Plant isotopic data from the Atacama Desert
#'
#' @description
#' Stable isotope measurements from botanical remains (seeds, stems, leaves,
#' charcoal, and other plant materials) recovered at archaeological sites in
#' northern Chile. Radiocarbon dates are stored separately in `arid_c14`.
#'
#' Mediciones de isótopos estables de restos botánicos de sitios arqueológicos
#' del norte de Chile. Los fechados radiocarbónicos se almacenan en `arid_c14`.
#'
#' @format A data frame with 576 rows and 29 columns:
#' \describe{
#'   \item{site_name}{Archaeological site identifier / Identificador del sitio arqueológico}
#'   \item{sample_id}{Unique sample identifier / Identificador único de muestra}
#'   \item{lat}{Latitude in decimal degrees / Latitud en grados decimales}
#'   \item{lon}{Longitude in decimal degrees / Longitud en grados decimales}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{period}{Sub-period or phase / Subperíodo o fase}
#'   \item{period_from}{Start of cultural period (BCE/CE; negative = BCE) / Inicio del período (a.C./d.C.)}
#'   \item{period_to}{End of cultural period (BCE/CE) / Fin del período (a.C./d.C.)}
#'   \item{lab_id}{Laboratory identifier linking to `arid_c14` / Identificador de laboratorio}
#'   \item{type_source}{Data type (primary or secondary source) / Tipo de fuente}
#'   \item{taxon_local}{Local common name of the taxon / Nombre local del taxón}
#'   \item{genus_species}{Scientific name / Nombre científico}
#'   \item{photosynthetic_pathway}{Photosynthetic pathway: C3, C4, or CAM / Vía fotosintética}
#'   \item{plant_domesticate}{Domestication status: Wild, Crop, or Managed / Estado de domesticación: Wild, Crop o Managed}
#'   \item{sample_type}{Physical sample type / Tipo de muestra física}
#'   \item{wt_C}{Weight percent carbon / Porcentaje en peso de carbono}
#'   \item{wt_N}{Weight percent nitrogen / Porcentaje en peso de nitrógeno}
#'   \item{CN_ratio}{Atomic C:N ratio / Relación C:N atómica}
#'   \item{d13C}{delta-13C (‰ VPDB) / delta-13C (por mil VPDB)}
#'   \item{d15N}{delta-15N (‰ AIR) / delta-15N (por mil AIR)}
#'   \item{d34S}{delta-34S (‰ VCDT) / delta-34S (por mil VCDT)}
#'   \item{Sr87_Sr86}{87Sr/86Sr strontium isotope ratio / Relacion isotopica de estroncio}
#'   \item{reference_short}{Short bibliographic citation / Referencia bibliográfica abreviada}
#'   \item{doi}{DOI of the original publication / DOI de la publicación original}
#'   \item{locality}{Site locality / Localidad del sitio}
#'   \item{admin_region}{Administrative region / Región administrativa}
#'   \item{ecozone}{Ecological zone / Zona ecológica}
#'   \item{period_broad}{Broad period category / Período general}
#'   \item{has_c14}{Whether a direct radiocarbon date exists in `arid_c14` / Si existe fechado radiocarbónico en `arid_c14`}
#' }
#'
#' @seealso [arid_c14] for radiocarbon dates; [arid_chronology()] to assign dates.
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_plants"


#' Archaeological site information for the Atacama Desert
#'
#' @description
#' Geographic, ecological, and chronological context for archaeological sites
#' included in ARID, including sites from isotopic sample tables and radiocarbon
#' databases. Links site names to administrative regions, ecozones, coordinates,
#' and cultural periods.
#'
#' Contexto geográfico, ecológico y cronológico de los sitios arqueológicos
#' incluidos en ARID, incluyendo sitios de las tablas de muestras isotópicas y
#' de bases de datos radiocarbónicas.
#'
#' @format A data frame with 422 rows and 11 columns:
#' \describe{
#'   \item{site_name}{Archaeological site identifier (primary key) / Identificador del sitio (clave primaria)}
#'   \item{lat}{Latitude in decimal degrees / Latitud en grados decimales}
#'   \item{lon}{Longitude in decimal degrees / Longitud en grados decimales}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{locality}{Broader locality or valley / Localidad o valle}
#'   \item{admin_region}{Administrative region / Región administrativa}
#'   \item{ecozone}{Ecological zone: Coast, Lowlands, Precordillera, or Altiplano / Zona ecológica}
#'   \item{period}{Sub-period or phase / Subperíodo o fase}
#'   \item{period_broad}{Broad period category (e.g. Archaic, Formative, Late Intermediate, Late) / Período general}
#'   \item{period_from}{Start of cultural period (BCE/CE) / Inicio del período (a.C./d.C.)}
#'   \item{period_to}{End of cultural period (BCE/CE) / Fin del período (a.C./d.C.)}
#' }
#'
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_sites"


#' Radiocarbon dates from the Atacama Desert
#'
#' @description
#' A compilation of radiocarbon dates from archaeological contexts in northern
#' Chile, integrating dates from published radiocarbon databases and from
#' isotopic samples in ARID. Records linked to isotopic samples (humans, animals,
#' plants) can be joined via `lab_id`. The `d13C_ams` column contains delta-13C
#' values used for AMS fractionation correction, not for dietary analysis.
#'
#' Compilación de fechados radiocarbónicos de contextos arqueológicos del norte
#' de Chile, integrando fechados de bases de datos publicadas y de muestras
#' isotópicas de ARID. Los registros vinculados a muestras isotópicas se pueden
#' unir mediante `lab_id`. La columna `d13C_ams` contiene valores de delta-13C
#' para corrección de fraccionamiento AMS, no para análisis dietético.
#'
#' @format A data frame with 1,127 rows and 17 columns:
#' \describe{
#'   \item{lab_id}{Laboratory identifier of the isotopic sample (NA for context-level dates) / Identificador del laboratorio isotópico (NA para fechados de contexto)}
#'   \item{sample_id}{Sample identifier of the isotopic sample (NA for context-level dates) / Identificador de la muestra isotópica}
#'   \item{site_name}{Archaeological site name / Nombre del sitio arqueológico}
#'   \item{locality}{Locality or hydrological basin / Localidad o cuenca hidrológica}
#'   \item{admin_region}{Administrative region / Región administrativa}
#'   \item{ecozone}{Ecological zone / Zona ecológica}
#'   \item{altitude_masl}{Altitude in metres above sea level / Altitud en metros sobre el nivel del mar}
#'   \item{reference_short}{Short bibliographic citation / Referencia bibliográfica abreviada}
#'   \item{c14_method}{Radiocarbon dating method (AMS, conventional) / Método de datación radiocarbónica}
#'   \item{c14_lab_code}{Radiocarbon laboratory code / Código de laboratorio de radiocarbono}
#'   \item{c14_bp}{Conventional radiocarbon age (years BP) / Edad radiocarbónica convencional (años AP)}
#'   \item{c14_error}{Measurement error (±1σ) / Error de medición (±1σ)}
#'   \item{c14_cal_from}{Calibrated age range start, 2σ 95% (BCE/CE; negative = BCE) / Inicio del rango calibrado 2σ 95% (a.C./d.C.; negativo = a.C.)}
#'   \item{c14_cal_to}{Calibrated age range end, 2σ 95% (BCE/CE) / Fin del rango calibrado 2σ 95% (a.C./d.C.)}
#'   \item{material}{Material category dated / Categoría del material fechado}
#'   \item{source_table}{Origin of the record: "humans", "animals", "plants", or "context" / Origen del registro}
#'   \item{d13C_ams}{δ¹³C for AMS fractionation correction (‰ VPDB) — not for dietary analysis / δ¹³C para corrección AMS — no para análisis dietético}
#' }
#'
#' @seealso [arid_chronology()] to assign dates to isotopic samples.
#' @source ARID — Atacama Repository of Isotopic Data. \url{https://github.com/mayorgarmijo/arid}
"arid_c14"
