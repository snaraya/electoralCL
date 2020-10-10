#' Información de las elecciones presidenciales por comunas en Chile.
#'
#' Base de datos contiene la información de las elecciones presidenciales desde 1989 a la fecha.
#' @docType data
#'
#' @usage data(electoralCL)
#'
#' @format Base de datos con 64366 filas y 18 variables.
#' \describe{
#'   \item{election}{Tipo de elecciones.}
#'   \item{election_date}{Fecha en el que se llevaron a cabo las elecciones presidenciales.}
#'   \item{year}{Año en el que se llevaron a cabo las elecciones. Puede diferir entre la primera y segunda vuelta electoral.}
#'   \item{ballotage}{Separa las elecciones entre primera vuelta, segunda vuelta y elección única (solo para las elecciones de 1989y 1993).}
#'   \item{id_region}{Número identificador de las regiones de Chile.}
#'   \item{region}{Nombre de la región.}
#'   \item{id_province}{Número identificador de las provincias de Chile.}
#'   \item{province}{Nombre de la provincia.}
#'   \item{county}{Nombre de la comuna de Chile.}
#'   \item{gender_election_table}{Género de la mesa electoral. Entre 1989 y 2010 las mesas electorales estaban divididas para hombres y mujeres. Después de la reforma electoral del 2011, se vuelven mixtas.}
#'   \item{candidate}{Nombre completo del candidato.}
#'   \item{names}{Nombre del candidato.}
#'   \item{lastname_p}{Apellido paterno del candidato.}
#'   \item{lastname_m}{Apellido materno del candidato.}
#'   \item{gender_candidate}{Género del candidato.}
#'   \item{elected}{Si el candidato en competencia ganó o no las elecciones. Al ser elecciones presidenciales, 0 corresponde a pasar a segunda vuelta, y 1 a ganar la elección.}
#'   \item{party_ab}{Partido político al que pertenece el candidato.}
#'   \item{total_votes}{Total de votos obtenidos.}
#' }
#' @source \url{http://www.servel.cl/}
"electoralCL"

