
# Creamos una muestra aleatoria para la clasificación manual
 
library(sf)
library(sp)

nzeros <- function(x, n=1){ # Fill zeros
  nc <- nchar(x)
  for(i in unique(nc)[unique(nc)<n]){
    k <- nc==i
    z <- paste0(rep(0,n-i), collapse='')
    x[k] <- paste0(z,x[k])
  }
  x
}

# Data
len <- read_sf('../2_polígonos AV/len/ugs-len.gpkg')
qro <- read_sf('../2_polígonos AV/qro/ugs-qro.gpkg')

# Es importante considerar los índices; al cargar los archivos vectoriales
  # estos no se muestran

# Identificadores
len$zm <- 'len'
qro$zm <- 'qro'
len$cfid <- 1:nrow(len)
qro$cfid <- 1:nrow(qro)

x <- nzeros(len$cfid,5)
len$nfid <- paste0('L-',substr(x,1,2),'-',substr(x,3,5))
x <- nzeros(qro$cfid,5)
qro$nfid <- paste0('Q-',substr(x,1,2),'-',substr(x,3,5))


# A muestrear 500 de cada ZM
# Muestra Aleatoria Simple (MAE)
 
set.seed(1514)
ls <- sample(lx$cfid, 500, replace=FALSE)
qs <- sample(qx$cfid, 500, replace=FALSE)

s1 <- lx[ls,]
s2 <- qx[qs,]


s1 <- st_transform(s1, st_crs(s2))
names(s1)[names(s1)=='gndvi'] <- "gndvi350" # Hay una diferencia de nombre entre los archivos
psam <- rbind(s1,s2)

k <- sample(1:nrow(psam), nrow(psam))
psam <- psam[k,]
psam$sfid <- 1:(nrow(psam))

write_sf(psam[,c("sfid","nfid", "zm",  "cfid", "area" )], 'sample3.shp', layer_options = "ENCODING=UTF-8" )
# El archivo vectorial de la muestra


# La tabla para captura de la clasificación manual
x <- as.data.frame(psam[,c("sfid","nfid", "zm")])
write.csv(x[,-4], file='sample ugs_v2.csv', row.names = FALSE)
