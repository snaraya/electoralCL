## Prepararemos el DF para leer los resultados por comuna:

library(tidyverse)
library(readxl)
library(janitor)
library(labelled)
library(stringi)
library(stringr)

prepare_data <- read_excel("data-raw/resultados_elecciones_presidenciales_ce_1989_2017_Chile.xlsx")

names(prepare_data)

prepare_data <- prepare_data %>%
  clean_names() %>%
  select(tipo_de_eleccion, cargo, fecha_de_eleccion, ano_de_eleccion, periodo, votacion_presidencial,
         id_region, region, provincia, nombre_provincia, comuna, sexo_mesa, candidato_a, nombres, apellido_paterno,
         apellido_materno, sexo, electo_a, partido, sigla_partido, votos_totales)

names(prepare_data)

prepare_data <- prepare_data %>%
  select(-cargo, -periodo) %>%
  rename(election = tipo_de_eleccion,
         election_date = fecha_de_eleccion,
         year = ano_de_eleccion,
         ballotage = votacion_presidencial,
         id_province = provincia,
         province = nombre_provincia,
         county = comuna,
         gender_location = sexo_mesa,
         candidate = candidato_a,
         names = nombres,
         surname_p = apellido_paterno,
         surname_m = apellido_materno,
         gender_candidate = sexo,
         elected = electo_a,
         party_candidate = partido,
         party_ab = sigla_partido,
         total_votes = votos_totales)

table(prepare_data$gender_candidate)
table(prepare_data$gender_location)
table(prepare_data$party_candidate)
table(prepare_data$party_ab)

prepare_data <- prepare_data %>%
  mutate(gender_candidate = if_else(gender_candidate == 'HOMBRE', 0, 1))

prepare_data <- prepare_data %>%
  mutate(gender_location = case_when(
    gender_location == 'HOMBRE' ~ 0L,
    gender_location == 'MUJER'  ~ 1L,
    gender_location == 'MIXTA'  ~ 2L)) %>%
  set_value_labels(gender_location = c('Hombres' = 0,
                                'Mujeres' = 1,
                                'Mixta' = 2))

prepare_data %>%
  count(gender_location)

prepare_data <- prepare_data %>% select(!party_candidate) %>%
  mutate(party_ab = case_when(
    party_ab %in% c('DC','PDC') ~ 1L,
    party_ab == 'AHV' ~ 2L,
    party_ab == 'IGUALDAD' ~ 3L,
    party_ab %in% c('IND','INDEP') ~ 4L,
    party_ab == 'PAIS' ~ 5L,
    party_ab %in% c('PC','PCCH') ~ 6L,
    party_ab == 'PEV' ~ 7L,
    party_ab == 'PH' ~ 8L,
    party_ab == 'PPD' ~ 9L,
    party_ab == 'PRI' ~ 10L,
    party_ab == 'PRO' ~ 11L,
    party_ab == 'PS' ~ 12L,
    party_ab == 'RN' ~ 13L,
    party_ab == 'UCC' ~ 14L,
    party_ab == 'UDI' ~ 15L,
    party_ab == 'UPA' ~ 16L,
  )) %>%
  set_value_labels(party_ab = c(
    'Partido Demócrata Cristiano' = 1,
    'Alianza Humanista Verde' = 2,
    'Igualdad' = 3,
    'Independiente' = 4,
    'País' = 5,
    'Partido Comunista' = 6,
    'Partido Ecologista Verde' = 7,
    'Partido Humanista' = 8,
    'Partido por la Democracia' = 9,
    'Partido Regionalista de los Independientes' = 10,
    'Partido Progresista' = 11,
    'Partido Socialista' = 12,
    'Renovación Nacional' = 13,
    'Unión de Centro Centro' = 14,
    'Unión Demócrata Independiente' = 15,
    'Unión Patriótica' = 16))

prepare_data %>%
  count(party_ab)

table(prepare_data$elected)

prepare_data <- prepare_data %>%
  mutate(elected = case_when(
    elected == '2ª Votación' ~ 0L,
    elected == 'SI'  ~ 1L)) %>%
  set_value_labels(elected = c('Pasa a segunda vuelta' = 0,
                               'Electo' = 1))

prepare_data %>%
  count(elected)

names(prepare_data)

prepare_data <- prepare_data %>%
  mutate_at(vars(election, ballotage, region, province, county, candidate, names, surname_p, surname_m), ~stri_trans_general(., "latin-ascii")) %>%
  mutate_at(vars(election, ballotage, region, province, county, candidate, names, surname_p, surname_m), ~str_to_lower(.))

names(prepare_data)

electoralCL <- prepare_data %>%
  rename(gender_election_table = gender_location)

electoralCL <- electoralCL %>%
  rename(lastname_p = surname_p,
         lastname_m = surname_m)


# prepare_data_sexo_mesa <- prepare_data %>%
#   mutate(ano_de_eleccion = case_when(
#     ano_de_eleccion == 1999 ~ 2000,
#     ano_de_eleccion == 2005 ~ 2006,
#     ano_de_eleccion == 2009 ~ 2010,
#     T ~ ano_de_eleccion
#   )) %>%
#   group_by(ano_de_eleccion, votacion_presidencial, comuna, sexo_mesa, candidato_a) %>%
#   summarise(votos_por_sexo_mesa = sum(votos_totales, na.rm = T)) %>%
#   pivot_wider(names_from = c(sexo_mesa, votacion_presidencial), values_from = votos_por_sexo_mesa,
#               names_sep = "_") %>% clean_names()
#
# prepare_data_votacion_presidencial <- prepare_data %>%
#   mutate(ano_de_eleccion = case_when(
#     ano_de_eleccion == 1999 ~ 2000,
#     ano_de_eleccion == 2005 ~ 2006,
#     ano_de_eleccion == 2009 ~ 2010,
#     T ~ ano_de_eleccion
#   )) %>%
#   group_by(ano_de_eleccion, votacion_presidencial, comuna, candidato_a) %>%
#   summarise(votos_por_votacion_presidencial = sum(votos_totales, na.rm = T)) %>%
#   pivot_wider(names_from = votacion_presidencial, values_from = votos_por_votacion_presidencial) %>%
#   clean_names() %>%
#   mutate(votos_totales = case_when(
#     ano_de_eleccion %in% c(1989, 1993) ~ unica_votacion,
#     T ~ segunda_votacion
#   )) %>% rename(primera_vuelta = primera_votacion, segunda_vuelta = segunda_votacion)
#
#
# prepare_data <- prepare_data %>%
#   select(tipo_de_eleccion, cargo, ano_de_eleccion, periodo,
#          id_region, region, provincia, nombre_provincia, comuna, candidato_a, nombres, apellido_paterno,
#          apellido_materno, sexo, electo_a, partido, sigla_partido) %>%
#   mutate(ano_de_eleccion = case_when(
#     ano_de_eleccion == 1999 ~ 2000,
#     ano_de_eleccion == 2005 ~ 2006,
#     ano_de_eleccion == 2009 ~ 2010,
#     T ~ ano_de_eleccion
#   )) %>%
#   distinct()
#
# prepare_data_wider <- prepare_data %>%
#   left_join(prepare_data_sexo_mesa) %>%
#   left_join(prepare_data_votacion_presidencial)

usethis::use_data(electoralCL, overwrite = TRUE)





