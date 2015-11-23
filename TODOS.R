Modyfikacja:

	windows(title="normalny")
levelplot(     replace(n,n<=1,NA)~x*z|type, X, scales=list(alternating=3)
							 ,col.regions=colorRampPalette(brewer.pal(9,"YlOrRd")[-1]), aspect="iso", shrink=c(0.1,1))
windows(title="pierwiastek")
levelplot(sqrt(replace(n,n<=1,NA))~x*z|type, X, scales=list(alternating=3)
					,col.regions=colorRampPalette(brewer.pal(9,"YlOrRd")[-1]), aspect="iso", shrink=c(0.1,1))


Z <- expand(data.frame(A=1:4,B=11:14))
Z$n <- seq_len(nrow(Z))
levelplot(n~A*B, Z		, aspect="iso", shrink=c(0,1), region.col="red")


todo:
· Może tytuł?
· Te shrinki można zamienić na jakieś kółka, żeby
	proporcja do pola nie do szerokości (chyba że jest?)
·
* wyglad stripow
* przerobić na rmd? i wykresy na githubu

Na tym pytaniu:
	http://stackoverflow.com/questions/19597643/how-to-set-default-par-settings-theme-in-lattice

dać w komentach, że related do http://stackoverflow.com/questions/3712402/r-how-to-change-lattice-levelplot-color-theme
oraz odpowiedz ze ustawia sie do deafult.theme, ale trzeba najpierw graphics off
a ustaweinia trzeba zrobić w setHook
Dodać też ze wystarczy lista ze zmianami, czyli

my.teme = list(
	x = list
list(z=11)
)

i show settings (albo jakiś przykład)

Kolejne:
	o co kaman:
	http://stackoverflow.com/questions/24356261/unable-to-change-the-global-pointsize-for-lattice-displays


require(corrplot)
corrplot(X)
X %>% filter(type=="T>G or A>C") %>% select(-type) %>% spread(x,n) %>% select(-z) %>% as.matrix %>% corrplot(cl.lim=c(0,40),is.corr=FALSE)
