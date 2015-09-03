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
lattice.options(default.args=list(as.table=TRUE))
trellis.par.set(theme=col.whitebg())

#* Various barcharts ----
y_rot <- list(x = list(rot = 90))
barchart(n~type|x*z, X, origin=0, scales=y_rot) %>% useOuterStrips
barchart(n~type|z*x, X, origin=0, scales=y_rot) %>% useOuterStrips
barchart(n~x|type*z, X, origin=0) %>% useOuterStrips
barchart(n~x|z*type, X, origin=0) %>% useOuterStrips
barchart(n~z|type*x, X, origin=0) %>% useOuterStrips
barchart(n~z|x*type, X, origin=0) %>% useOuterStrips

#* Various dotplots ----
dotplot(n~type|z, groups=x, X, origin=0, scales=y_rot, auto.key=list(space="right"))
dotplot(n~type|x, groups=z, X, origin=0, scales=y_rot, auto.key=list(space="right"))
dotplot(n~x|z, groups=type, X, origin=0, auto.key=list(space="right"))
dotplot(n~x|type, groups=z, X, origin=0, auto.key=list(space="right"))
dotplot(n~z|x, groups=type, X, origin=0, auto.key=list(space="right"))
dotplot(n~z|type, groups=x, X, origin=0, auto.key=list(space="right"))

#* One levelplot to rule them all
levelplot(n~x*z|type, X, scales=list(alternating=3), col.regions=colorRampPalette(brewer.pal(9,"YlOrRd")[-1]))
# this needs some colour polishing


