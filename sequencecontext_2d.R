# Data prepare ----
library(dplyr); library(tidyr)

read.table("snvspermegabase.txt", header=TRUE) %>%
	gather(desc, n) %>%
	separate(desc, c("type","z","x"), sep=c("[_x]")) %>%
	mutate(
		z = factor(z, levels=c("T","C","A","G"))
		,x = factor(x, levels=c("T","C","A","G"))
		,type = gsub(".", ">", type, fixed=TRUE)
		,type = sub("^(.{3})>(.{3})$", "\\1 or \\2", type)
	) ->
	X

# Plots (2d) ----
#* Setup ----
require(latticeExtra)
lattice.options(
	default.args = list(as.table=TRUE)
	,default.theme = col.whitebg()
)
grid_h <- function(p) p + layer_(panel.grid(h=-1, v=0))

#* Various barcharts ----
x_rot <- list(x = list(rot = 90))
barchart(n~type|x*z, X, origin=0, scales=x_rot) %>% grid_h %>% useOuterStrips
barchart(n~type|z*x, X, origin=0, scales=x_rot) %>% grid_h %>% useOuterStrips
barchart(n~x|type*z, X, origin=0) %>% grid_h %>% useOuterStrips
barchart(n~x|z*type, X, origin=0) %>% grid_h %>% useOuterStrips
barchart(n~z|type*x, X, origin=0) %>% grid_h %>% useOuterStrips
barchart(n~z|x*type, X, origin=0) %>% grid_h %>% useOuterStrips

#* Various dotplots ----
dotplot(n~type|z, groups=x, X, origin=0, scales=x_rot, auto.key=list(space="right")) %>% grid_h
dotplot(n~type|x, groups=z, X, origin=0, scales=x_rot, auto.key=list(space="right")) %>% grid_h
dotplot(n~x|z, groups=type, X, origin=0, auto.key=list(space="right")) %>% grid_h
dotplot(n~x|type, groups=z, X, origin=0, auto.key=list(space="right")) %>% grid_h
dotplot(n~z|x, groups=type, X, origin=0, auto.key=list(space="right")) %>% grid_h
dotplot(n~z|type, groups=x, X, origin=0, auto.key=list(space="right")) %>% grid_h

#* One levelplot to rule them all ----
clrs <- colorRampPalette(brewer.pal(9,"YlOrRd")[-1])
levelplot(n~x*z|type, X, scales=list(alternating=3), col.regions=clrs, aspect="iso")
# this needs some colour polishing
# Alternative: rule out cells with 0 or 1 mutation; size of cell == number of mutation == hight in 3d barchart
levelplot(replace(n,n<=1,NA)~x*z|type, X, scales=list(alternating=3), col.regions=clrs, aspect="iso", shrink=c(0.1,1))

#* much better:
levelplot(
	n~x*z|type, X, scales=list(alternating=3), col.regions=clrs, aspect="iso"
	,panel = function(subscripts, x, y, z, at, region, col.regions) {
		zs <- sqrt(z/max(z, na.rm=TRUE))
		panel.points(x[subscripts], y[subscripts], pch=21, cex=6*zs[subscripts], col="lightgrey",fill=level.colors(z[subscripts], at, col.regions, colors = TRUE))
	})

