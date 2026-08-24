#' Human isotopic data from the Atacama Desert
#'
#' @description
#' Stable isotope measurements from human skeletal and soft tissue samples
#' recovered at archaeological sites in northern Chile (Arica y Parinacota,
#' Tarapaca, and Antofagasta regions) and the south coast of Peru (Tacna and
#' Moquegua regions). Stored in long format: one row per tissue analysed.
#' Individuals with both organic and carbonate measurements appear in two rows
#' distinguished by the `tissue_type` column. Radiocarbon dates are stored
#' separately in `arid_c14` (linked via `lab_id`; Chile only for now).
#'
#' Mediciones de isotópos estables de muestras de tejido esquelético y blando
#' humano de sitios arqueológicos del norte de Chile y de la costa sur de Perú
#' (Tacna y Moquegua). Formato largo: una fila por tejido analizado. Los
#' fechados radiocarbónicos se almacenan en `arid_c14` (vinculados mediante
#' `lab_id`; por ahora solo para Chile).
#'
#' Some individuals (same `sample_id`) were independently reported by more
#' than one publication — either a genuine re-measurement by a different lab,
#' or a later paper adding contextual metadata without new isotope values.
#' Both rows are kept as-is (no row is dropped or merged) so no original
#' measurement is lost; deduplicate by `sample_id` (choosing which
#' `reference_short` to keep per case) before computing sample-size or
#' population-level statistics, or double-counting of individuals may result.
#'
#' Algunos individuos (mismo `sample_id`) fueron reportados de forma
#' independiente por más de una publicación — ya sea una remedición genuina
#' por otro laboratorio, o un estudio posterior que agrega metadata contextual
#' sin nuevos valores isotópicos. Ambas filas se conservan tal cual (no se
#' elimina ni fusiona ninguna) para no perder ninguna medición original;
#' deduplicar por `sample_id` (eligiendo qué `reference_short` conservar caso
#' a caso) antes de calcular tamaño muestral o estadísticas poblacionales, o
#' se puede producir doble conteo de individuos.
#'
#' `CN_ratio` is a per-sample lab measurement for most rows, but for two
#' sources it is a proxy value rather than an exact per-sample figure: for
#' Ballester and Clarot (2014) (and its citation variants) the source gives
#' only a reported range (2.9–3.6, cited as personal communication in
#' Santana-Sagredo et al. 2021) and the midpoint (3.25) is used; for Tomczak
#' (2001) the source reports C:N only as a per-site average (not per
#' individual), and that site average is used for every organic sample from
#' that site lacking its own value.
#'
#' `CN_ratio` es una medición de laboratorio por muestra en la mayoría de las
#' filas, pero para dos fuentes es un valor aproximado: para Ballester and
#' Clarot (2014) (y sus variantes de cita) la fuente solo da un rango
#' reportado (2.9–3.6, citado como comunicación personal en Santana-Sagredo
#' et al. 2021) y se usa el punto medio (3.25); para Tomczak (2001) la fuente
#' reporta C:N solo como promedio por sitio (no por individuo), y se usa ese
#' promedio para cada muestra orgánica de ese sitio que no tenga su propio
#' valor.
#'
#' @format A data frame with 4,364 rows and 38 columns:
#' \describe{
#'   \item{country}{Country of the sample: "Chile" or "Peru" / País de la muestra}
#'   \item{site_name}{Archaeological site identifier / Identificador del sitio arqueológico}
#'   \item{period_broad}{Broad period category (e.g. Archaic, Formative, Late Intermediate, Late) / Período general}
#'   \item{period}{Sub-period or phase (e.g. Early Archaic, Late Formative) / Subperíodo o fase}
#'   \item{lab_id}{Isotopic sample laboratory code. Only expected to match `arid_c14` when `has_c14` is `TRUE`; otherwise it is a general lab code unrelated to radiocarbon dating / Código de laboratorio de la muestra isotópica. Solo se espera coincidencia con `arid_c14` cuando `has_c14` es `TRUE`; en los demás casos es un código de laboratorio general, sin relación con fechado radiocarbónico}
#'   \item{period_from}{Start of cultural period (BCE/CE; negative = BCE) / Inicio del período cultural (a.C./d.C.; negativo = a.C.)}
#'   \item{period_to}{End of cultural period (BCE/CE) / Fin del período cultural (a.C./d.C.)}
#'   \item{sample_id}{Individual identifier — not a unique row/sample identifier. The same individual can span multiple rows (sequential tissue segments such as hair increments, plus different tissues/elements such as bone collagen, bone apatite, or tooth enamel); count distinct `sample_id` values, not rows, when reporting sample size / Identificador del individuo — no es un identificador único por fila/muestra. Un mismo individuo puede abarcar varias filas (segmentos secuenciales de tejido como incrementos de pelo, más distintos tejidos/elementos como colágeno óseo, apatito óseo o esmalte dental); al reportar el tamaño muestral, contar valores distintos de `sample_id`, no filas}
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
#'   \item{admin_region}{Administrative region: Moquegua or Tacna (Peru); Arica y Parinacota, Tarapaca, or Antofagasta (Chile). Ordered factor, north to south / Región administrativa; factor ordenado de norte a sur}
#'   \item{ecozone}{Ecological zone based on altitude: Coast (<130 masl), Lowlands (130-1700 masl), Precordillera (1700-3700 masl), or Altiplano (>3700 masl). Ordered factor, west to east / Zona ecológica; factor ordenado de oeste a este}
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
#' @format A data frame with 602 rows and 33 columns:
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
#'   \item{type_source}{Habitat/origin category of the taxon: "Marine fauna" or "Terrestrial fauna". Not a wild/domestic distinction (not recorded); can be approximated only for camelids via `taxon_local`, on sparse data / Categoría de hábitat/origen del taxón: "Marine fauna" o "Terrestrial fauna". No es una distinción silvestre/doméstico (no está registrada); solo aproximable para camélidos vía `taxon_local`, con datos dispersos}
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
#' @format A data frame with 1,028 rows and 29 columns:
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
#' @format A data frame with 469 rows and 11 columns:
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
#' @format A data frame with 1,210 rows and 17 columns:
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
