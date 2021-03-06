#Copyright (C) 1999  Eric Lecoutre & Mathieu Ros

"HTMLDemo"<-
function(path = "./")

{
	data(state)
	File <- HTMLInitFile(paste(path, "R.html", sep = ""))
	HTMLTitre("Demonstration of HTML exportation", Border = 1, BackColor = 
		"000000", Color = "FFFFFF", Size = "+3", Width = "100%", File= File)
	HTMLTitre("An HTMLExport method for lot of objects", Width = "80%", 
		BackColor = "000063", Color = "FFFFFF", File = File)
	HTMLColumns(3, list("text","matrix","data.frame"), File = File)
	HTMLInsertBreak(File = File)
	HTMLExport("Control color, sizes font and alignment", File = 
		File, BackColor = "lemonchiffon", Color = "darkred")
	tempo <- iris[1:5,]
	names <- dimnames(tempo)[[1]]
	HTMLExport(tempo, File = File, FirstRowBold = T, ColorCellInside = 
		"F4E8F5", ColorFirstColumn = "D3D3D3", FontName = "arial")
	HTMLExport("Number of columns: ", File = File)
	HTMLExport(dim(tempo)[2], File = File)
	HTMLInsertBreak(File = File, Size = "1")
	HTMLExport("Use fonts to write in greek : ", File = File)
	HTMLExport("a b g d e", File = File, TextSize = "+2", Color = "blue", 
		FontName = "SYMBOL")
	HTMLExport("<BR>Use HTML tags if you know to enhance: <FONT SIZE=4 FACE='SYMBOL'>L<SUB>3</SUB></FONT> indices, pictures with IMG tag and so on...",
		File = File)
	HTMLInsertBreak(File = File, Size = "1")
	plot(iris[,2:3])
	HTMLInsertGraph(File = File)
	
	cat("\n\n *** THE FILE ", paste(path, "R.html", sep = "")," HAS BEEN GENERATED.")
}
"HTMLExport.anova"<-
function(x, File = "", digits = .Options$digits, quote = F, drop = F, FontName
	 = "Arial", Align = "left", Bold = T, ...)
{
	cat("<BR><CENTER><TABLE WIDTH=100% BORDER=0><TD WIDTH=100% BGCOLOR=000063><FONT FACE=ARIAL SIZE=+2 COLOR=FFFFFF>&nbsp;ANOVA table</TD></TABLE></CENTER><BR>",
		append = T, sep = "", file = File)
	heading <- attr(x, "heading")
	if(!is.null(heading))
		cat(paste("<P ALIGN='", Align, "'><FONT FACE='", FontName, 
			" SIZE=+1>", if(Bold == T) "<B>", heading, if(Bold == T
			) "</B>",  , "</FONT></P>"), sep = "", append = T, file
			 = File)
	attr(x, "heading") <- NULL
	d <- dim(x)
	for(i in 1:d[2]) {
		xx <- x[[i]]
		if(!length(levels(xx)) && is.numeric(xx)) {
			xna <- is.na(xx)
			xx <- format(zapsmall(xx, digits))
			xx[xna] <- ""
			x[[i]] <- xx
		}
	}
	if(d[1] == 1 && drop) {
		x <- t(as.matrix(x))
		dn <- dimnames(x)
		dn <- paste(dn[[1]], ":", sep = "")
		dimnames(x) <- list(dn, "")
	}
	invisible(NextMethod("HTMLExport"))
}
"HTMLExport.data.frame"<-
function(x, File = "", Border = 0, TextSize = "-1", FontName = "times", 
	FirstRowBold = F, FirstColumnBold = F, ColorFirstRow = "E4E4E4", 
	ColorFirstColumn = "C0C0C0", ColorCellInside = "FFFFFF", Align = 
	"right", Alignx = "center", Bold = F)
{
	txt <- paste("<P ALIGN='", Alignx, "'><TABLE Border=", Border, ">", sep
		 = "")
	if(is.null(dimnames(x)[[2]]) == F) {
		VecDebut <- c(paste("<TR><TD BGCOLOR=E4E4E4 ALIGN='", Align, 
			"'><FONT FACE='", FontName, "' TextSize='", TextSize, 
			"'>", sep = ""), paste("<TD BGCOLOR=C0C0C0 ALIGN='", 
			Align, "'><FONT FACE='", FontName, "' TextSize='", 
			TextSize, "' COLOR=000040>&nbsp;", if(FirstColumnBold == 
			T) "<B>", sep = ""), rep(paste(
			"<TD BGCOLOR=C0C0C0 ALIGN='", Align, "'><FONT FACE='", 
			FontName, "' TextSize='", TextSize, 
			"' COLOR=000040>&nbsp;", sep = ""), dim(x)[2] - 1))
		VecMilieu <- c("", as.character(dimnames(x)[[2]]))
		VecFin <- c(rep("</TD>", dim(x)[2]), 
			"&nbsp;</CENTER></TD></TR>")
		txt <- paste(txt, paste(VecDebut, VecMilieu, VecFin, sep = "", 
			collapse = ""))
	}
	for(i in 1:dim(x)[1]) {
		if(i == 1) {
			VecDebut <- c(paste(
				"<TR><TD BGCOLOR=C0C0C0 ALIGN='RIGHT'>", if(
				FirstRowBold == T) "<B>", 
				"<CENTER><FONT FACE='", FontName, 
				"' TextSize='", TextSize, "'>", sep = ""), 
				paste("<TD ALIGN='", Align, "' BGCOLOR='", 
				ColorCellInside, "'>", if((FirstColumnBold == T
				) | (FirstRowBold == T)) "<B>", "<FONT FACE='", 
				FontName, "' TextSize='", TextSize, "'>&nbsp;", 
				sep = ""), rep(paste("<TD ALIGN='", Align, 
				"' BGCOLOR='", ColorCellInside, "'>", if(
				FirstRowBold == T) "<B>", "<FONT FACE='", 
				FontName, "' TextSize='", TextSize, "'>&nbsp;", 
				sep = ""), dim(x)[2] - 1))
			VecMilieu <- c(dimnames(x)[[1]][i], HTMLReplaceNA(
				as.matrix(x[i,  ]), Replace = "-"))
			VecFin <- c(rep("</TD>", dim(x)[2]), "&nbsp;</TD></TR>"
				)
		}
		else {
			VecDebut <- c(paste("<TR><TD BGCOLOR=C0C0C0 ALIGN='", 
				Align, "'><CENTER><FONT FACE='", FontName, "'>",
				sep = ""), paste("<TD ALIGN='", Align, 
				"' BGCOLOR='", ColorCellInside, 
				"'><FONT FACE='", FontName, "' TextSize='", 
				TextSize, "'>&nbsp;", if(FirstColumnBold == T) 
				  "<B>", sep = ""), rep(paste("<TD ALIGN='", 
				Align, "' BGCOLOR='", ColorCellInside, 
				"'><FONT FACE='", FontName, "' TextSize='", 
				TextSize, "'>&nbsp;", sep = ""), dim(x)[2] - 1)
				)
			VecMilieu <- c(dimnames(x)[[1]][i], HTMLReplaceNA(
				as.matrix(x[i,  ]), Replace = "-"))
			VecFin <- c(rep("</TD>", dim(x)[2]), "&nbsp;</TD></TR>"
				)
		}
		txt <- paste(txt, paste(VecDebut, VecMilieu, VecFin, sep = "", 
			collapse = ""))
	}
	txt <- paste(txt, "</TABLE></P><BR>")
	cat(txt, "\n", file = File, sep = "", append = T)
}
"HTMLExport.list"<-
function(x, prefix = "", File = "", Align = "left", ...)
{
	xlen <- length(x)
	if(xlen == 0) {
		cat("list()\n")
		return(invisible(x))
	}
	n <- names(x)
	if(is.null(n))
		this <- paste(prefix, "[[", 1:xlen, "]]", sep = "")
	else this <- paste(prefix, "$", .C("names_unlex",
			n,
			as.integer(xlen))[[1]], sep = "")
	for(i in 1:xlen) {
		this[i] <- substring(this[i], 2, nchar(this[i]))
		cat(paste("<P ALIGN=", Align, 
			"><TABLE BORDER=0><TD BGCOLOR=E4E4E4><FONT FACE=ARIAL><B>",
			this[i], "</TD></TABLE></P>", sep = ""), file = File, 
			append = T, sep = "")
		HTMLExport(x[[i]], File = File, prefix = this[i], ...)
	}
	invisible(x)
}
"HTMLExport.title"<-
function(x, File = "", ...)
{
	HTMLTitre(x, File = File, ...)
}
"HTMLlsfit"<-
function(x, y, File = "", ...)
{
# Initialisation du fichier HTML
	cat("<HTML><BODY BGCOLOR=FFFFFF BACKGROUND='back.gif'>\n<TABLE WIDTH=100% BORDER=0>\n<TD WIDTH=70% BGCOLOR=000000><FONT FACE=ARIAL SIZE=+3 COLOR=FFFFFF> &nbsp; Regression Analysis</FONT><BR>\n<FONT FACE=ARIAL SIZE=+2 COLOR=FFFFFF> &nbsp; Linear Least Square fit</FONT>\n</TD>\n\n\n<TD WIDTH=30% BGCOLOR=FFFFFF>\n\t<TABLE WIDTH=90%>\n\t<TD BGCOLOR=000000>\n<CENTER>\n\t\t<TABLE BORDER=0 WIDTH=100%>\n\t\t<TD BGCOLOR=000000>\n<CENTER>\n<P>\n<FONT SIZE=+1 COLOR=FFFFFF FACE=ARIAL><B>MODEL</B></FONT>\n\n\t\t</TD>\n\t\t</TABLE>\n\t\t<TABLE WIDTH=100%>\n\t\t<TD BGCOLOR=FFFFFF>\n<CENTER><FONT FACE=ARIAL><BR><B>Y = a + b*X</B><BR>&nbsp;</FONT></CENTER>\n\n\t\t</TD>\n\t\t</TABLE>\n</CENTER>\n\t</TD>\n\t</TABLE>\n</TD></TABLE><BR>\n<BR>\n",
		file = File, append = F, sep = "")	#
	data <- data.frame(cbind(x, y))
	if(is.null(dimnames(data)[[2]]) == T) {
		dimnames(data)[[2]] <- c("Var X", "Var Y")
	}
	HTMLTitre("Summary statistics for each variable", File = File)
	x <- data[, 1]
	y <- data[, 2]
	matR <- matrix(ncol = 2, nrow = 7)
	dimnames(matR) <- list(c("Count", "Average", "Variance", 
		"Standard deviation", "Minimum", "Maximum", "Sum"), dimnames(
		data)[[2]])
##	matR[1,  ] <- c(sum(!is.na(x)), sum(!is.na(y)))
	matR[2,  ] <- c(mean(x, na.rm = TRUE), mean(y, na.rm = TRUE))
	matR[3,  ] <- c(var(x, na.method = "omit"), var(y, na.method = "omit"))
	matR[4,  ] <- sqrt(matR[3,  ])
	matR[5,  ] <- c(min(x), min(y))
	matR[6,  ] <- c(max(x), max(y))
##	matR[7,  ] <- c(sum(x,na.rm=TRUE), sum(y,na.rm=TRUE))
	oldpar <- par()
	graphsheet(width = 4, height = 3, Name = "box")
	par(cex = 0.20000000000000001, mai = c(0.40000000000000002, 
		0.59999999999999998, 0.40000000000000002, 0.59999999999999998), 
		fin = c(0.69999999999999996, 2.2000000000000002), mfrow = c(1, 
		2))
	boxplot(x, outchar = T, main = "BoxPlot X")
	boxplot(y, outchar = T, main = "BoxPlot Y")
	export.graph("c:\\TEMP\\box.jpg", "box", ExportType = "JPG")
	par(oldpar)
	cat("<TABLE BORDER=0 WIDTH=90%><TD ALIGN=CENTER VALIGN=MIDDLE>", append
		 = T, sep = "", file = File)
	HTMLExport(round(matR, 3), File = File, Border = 0)
	cat(paste("</TD><TD ALIGN=CENTER VALIGN=MIDDLE><CENTER><IMG SRC=c:\\TEMP\\box.jpg BORDER=1></TD></TABLE>",
		sep = ""), file = File, append = T, sep = "")
	HTMLTitre("Correlations", File = File)
	cat("<TABLE BORDER=0 WIDTH=90%><TD ALIGN=CENTER VALIGN=MIDDLE>", append
		 = T, sep = "", file = File)
	HTMLExport(round(cor(data), 3), File = File)
	cat("</TD><TD ALIGN=CENTER VALIGN=MIDDLE><CENTER>", sep = "", append = 
		T, file = File)
	graphsheet(width = 4, height = 3)
	HTMLExport.graphics(plot(x, y), File = File)
	cat("</TD></TABLE>", file = File, append = T, sep = "")
	HTMLTitre("Regression analyses", File = File)
	ls.out <- lsfit(x, y, ...)
	outp <- ls.print(ls.out)
	HTMLExport(round(t(t(outp$summary)), 4), File = File)
	HTMLExport(round(outp$coef.table, 4), File = File, Border = 0)	
	# GRAPH DE REGRESSION	
	#pas possible tant que l'équivalent de la fonction graph.export n'existe pas sous R...
}
"HTMLEndFile"<-
function(File = "")
{
	cat("<HR><CENTER><FONT FACE=ARIAL SIZE=-1>Generated on: <I>", date(), 
		"</I></FONT></CENTER></BODY></HTML>", sep = "", append = T, 
		file = File)
}
"HTMLExport.array"<-
function(x, File = "", ...)
{
	d <- dim(x)
	ndim <- length(d)
	dn <- dimnames(x)
	if(ndim == 1)
		HTMLExport.matrix(matrix(x, 1, dimnames = list("", if(is.null(
			dn)) paste("[", 1:d[1], "]", sep = "") else dn[[1]])), 
			File = File, ...)
	else if(ndim == 2)
		HTMLExport.matrix(x, File = File, ...)
	else {
		if(length(dn) < ndim)
			dn <- vector("list", ndim)
		for(i in 3:ndim)
			if(length(dn[[i]]) < d[i]) dn[[i]] <- paste(1:d[i])
		xm <- array(x[1], d[1:2])
		dimnames(xm) <- dn[1:2]
		d <- d[ - (1:2)]
		nm <- length(xm)
		which <- 1:nm
		dn <- dn[ - (1:2)]
		ndim <- ndim - 2
		counter <- rep(0, length(d))
		for(i in 1:(length(x)/nm)) {
			cat("<BR>, , ", file = File, append = T)
			for(j in 1:ndim)
				cat(dn[[j]][counter[j] + 1], if(j < ndim) ", "
				   else "<BR>", sep = "", file = File, append
				   = T)
			xm[1:nm] <- x[which]
			HTMLExport.matrix(xm, File = File, ...)
			counter <- odometer(counter, d)
			which <- which + nm
		}
	}
	invisible(x)
}
"HTMLExport.default"<-
function(x, File = "", ...)
{
	a <- attributes(x)
	if(cl <- length(class(x)) > 0)
		x <- unclass(x)	#avoid methods (class is in a, so is printed)
	if(length(a) - (is.recursive(x) && length(names(x))) > 0)
		HTMLExport.structure(x, a, File = File, ...)
	else switch(mode(x),
			numeric = ,
			logical = ,
			complex = ,
			character = HTMLExport.atomic(x, File = File, ...),
			list = HTMLExport.list(x, File = File, ...),
			graphics = HTMLExport.graphics(x, File = File, ...),
			dput(x))
	if(cl)
		class(x) <- a$class
	invisible(x)
}
"HTMLExport.matrix"<-
function(x, File = "", Border = 1, TextSize = "-1", FontName = "times", 
	FirstRowBold = F, FirstColumnBold = F, ColorFirstRow = "E4E4E4", 
	ColorFirstColumn = "C0C0C0", ColorCellInside = "FFFFFF", Align = 
	"right", Alignx = "center", Bold = F, ...)
{
	txt <- paste("<P ALIGN='", Alignx, "'><TABLE Border=", Border, ">", sep
		 = "")
	if(is.null(dimnames(x)[[2]]) == F) {
		VecDebut <- c(if(is.null(dimnames(x)[[1]]) == F) paste(
				"<TR><TD BGCOLOR=E4E4E4 ALIGN='", Align, "'>", 
				"<FONT FACE='", FontName, "' TextSize='", 
				TextSize, "'>", sep = ""), paste(
			"<TD BGCOLOR=C0C0C0 ALIGN='", Align, "'><FONT FACE='", 
			FontName, "' TextSize='", TextSize, 
			"' COLOR=000040>&nbsp;", if(FirstColumnBold == T) "<B>",
			sep = ""), rep(paste("<TD BGCOLOR=C0C0C0 ALIGN='", 
			Align, "'><FONT FACE='", FontName, "' TextSize='", 
			TextSize, "' COLOR=000040>&nbsp;", sep = ""), dim(x)[2] -
			1))
		VecMilieu <- c(if(is.null(dimnames(x)[[1]]) == F) "", 
			as.character(dimnames(x)[[2]]))
		VecFin <- c(if(is.null(dimnames(x)[[1]]) == F) "</TD>", rep(
			"</TD>", dim(x)[2] - 1), "&nbsp;</CENTER></TD></TR>")
		txt <- paste(txt, paste(VecDebut, VecMilieu, VecFin, sep = "", 
			collapse = ""))
	}
	for(i in 1:dim(x)[1]) {
		if(i == 1) {
			VecDebut <- c(if(is.null(dimnames(x)[[1]]) == F) paste(
				  "<TR><TD BGCOLOR=C0C0C0 ALIGN='RIGHT'>", if(
				  FirstRowBold == T) "<B>", 
				  "<CENTER><FONT FACE='", FontName, 
				  "' TextSize='", TextSize, "'>", sep = ""), 
				paste("<TD ALIGN='", Align, "' BGCOLOR='", 
				ColorCellInside, "'>", if((FirstColumnBold == T
				) | (FirstRowBold == T)) "<B>", "<FONT FACE='", 
				FontName, "' TextSize='", TextSize, "'>&nbsp;", 
				sep = ""), rep(paste("<TD ALIGN='", Align, 
				"' BGCOLOR='", ColorCellInside, "'>", if(
				FirstRowBold == T) "<B>", "<FONT FACE='", 
				FontName, "' TextSize='", TextSize, "'>&nbsp;", 
				sep = ""), dim(x)[2] - 1))
			VecMilieu <- c(if(is.null(dimnames(x)[[1]]) == F) 
				  dimnames(x)[[1]][i], HTMLReplaceNA(as.matrix(
				x[i,  ]), Replace = "-"))
			VecFin <- c(if(is.null(dimnames(x)[[1]]) == F) "</TD>", 
				rep("</TD>", dim(x)[2] - 1), "&nbsp;</TD></TR>"
				)
		}
		else {
			VecDebut <- c(if(is.null(dimnames(x)[[1]]) == F) paste(
				  "<TR><TD BGCOLOR=C0C0C0 ALIGN='", Align, 
				  "'><CENTER><FONT FACE='", FontName, "'>", sep
				   = ""), paste("<TD ALIGN='", Align, 
				"' BGCOLOR='", ColorCellInside, 
				"'><FONT FACE='", FontName, "' TextSize='", 
				TextSize, "'>&nbsp;", if(FirstColumnBold == T) 
				  "<B>", sep = ""), rep(paste("<TD ALIGN='", 
				Align, "' BGCOLOR='", ColorCellInside, 
				"'><FONT FACE='", FontName, "' TextSize='", 
				TextSize, "'>&nbsp;", sep = ""), dim(x)[2] - 1)
				)
			VecMilieu <- c(if(is.null(dimnames(x)[[1]]) == F) 
				  dimnames(x)[[1]][i], HTMLReplaceNA(as.matrix(
				x[i,  ]), Replace = "-"))
			VecFin <- c(if(is.null(dimnames(x)[[1]]) == F) "</TD>", 
				rep("</TD>", dim(x)[2] - 1), "&nbsp;</TD></TR>"
				)
		}
		txt <- paste(txt, paste(VecDebut, VecMilieu, VecFin, sep = "", 
			collapse = ""))
	}
	txt <- paste(txt, "</TABLE></P><BR>")
	cat(txt, "\n", file = File, sep = "", append = T)
}
"HTMLInitFile"<-
function(File = "C:\\TEMP\\1.HTML", BackGroundColor = "FFFFFF", BackGroundImg
	 = "", Title = "S-Plus output")
{
	cat(paste("<HTML><META NAME='Generated by a function created by Eric Lecoutre and ported to R by Mathieu Ros'>\n\n<HEAD><TITLE>S-Plus output, generated on :",
		date(), "</TITLE></HEAD><BODY BGCOLOR=", BackGroundColor, if(
		is.null(BackGroundImg) == F) paste(" BACKGROUND='", 
			BackGroundImg, "'", sep = ""), ">"), append = F, sep = 
		"", file = File)
	File
}
"HTMLReplaceNA"<-
function(Vec, Replace = "-")
{
	Vec <- as.character(Vec)
	for(i in 1:length(Vec)) {
		if((Vec[i] == "NA") | (Vec[i] == "NaN")) {
			Vec[i] <- Replace
		}
	}
	Vec
}
"HTMLColumns"<-
function(Ncol = 2, Arg = list(c(), c()), File = "", Align = "center", Border = 
	0, Width = "100%")
{
	if(length(Arg) != Ncol)
		stop("The list 'Arg' must contain the same number of elements as the number of columns."
			)
	cat(paste("</CENTER><P ALIGN=", Align, "><TABLE BORDER=", Border, 
		" WIDTH=", Width, ">", sep = ""), file = File, sep = "", append
		 = T)
	for(i in 1:Ncol) {
		cat("<TD>", sep = "", append = T, file = File)
		x <- Arg[[i]]
		HTMLExport(x, File = File)
		cat("</TD>", sep = "", append = T, file = File)
	}
	cat("</TABLE></P>", sep = "", append = T, file = File)
}
"HTMLExport"<-
function(x, ...)
{
	UseMethod("HTMLExport")
}
"HTMLExport.atomic"<-
function(x, File = "", TextSize = -1, FontName = "times", Bold = F, prefix = "",
	Color = "000000", ...)
{
	cat(paste("<FONT FACE='", FontName, "' SIZE='", TextSize, "' COLOR='", 
		Color, "'> &nbsp;", if(Bold == T) "<B>", x, if(Bold == T) 
			"</B>", "&nbsp;</FONT>", sep = "", collapse = ""), file
		 = File, append = T, sep = "")
}
"HTMLExport.graphics"<-
function(x, File = "", GraphDirectory = "c:\\TEMP\\", GraphFileName = "", 
	GraphSaveAs = "JPG", GraphBorder = 1, Align = "center", ...)
{
	if(GraphFileName == "") {
		nowd <- date()
		GraphFileName <- paste("GRAPH_", substring(nowd, 5, 7), 
			substring(nowd, 9, 10), "_", substring(nowd, 12, 13), 
			substring(nowd, 15, 16), substring(nowd, 18, 19), sep
			 = "")
	}
	GraphFileName <- paste(GraphDirectory, GraphFileName, ".", GraphSaveAs, 
		sep = "")
	export.graph(GraphFileName, Name = x, ExportType = GraphSaveAs)
	cat(paste("<P ALIGN=", Align, "><IMG SRC='", GraphFileName, "' BORDER=",
		GraphBorder, "></P>", sep = "", collapse = ""), file = File, 
		append = T, sep = "")
}
"HTMLExport.structure"<-
function(x, a = attributes(x), prefix = "", File = "", ...)
{
	n <- length(dim(x))
	nn <- names(a)
	ate <- character(0)
	if(n > 0) {
		if(n == 2)
			HTMLExport.matrix(x, File = File, ...)
		else HTMLExport.array(x, File = File, ...)
		ate <- c("dim", "dimnames")
		if(n == 1)
			ate <- c(ate, "names")
	}
	else if(!is.atomic(x)) {
		HTMLExport(as.vector(x), File = File, ...)
		ate <- "names"
	}
	else if(length(tsp(x))) {
		print.ts(x, File = File, ...)
		ate <- "tsp"
	}
	else if(length(names(x))) {
		HTMLExport.matrix(matrix(x, 1, dimnames = list("", names(x))), 
			File = File, ...)
		ate <- "names"
	}
	else HTMLExport(as.vector(x), File = File, ...)
	ii <- !match(nn, ate, nomatch = F)
	nn <- nn[ii]
	a <- a[ii]
	for(i in seq(nn)) {
		this <- paste("attr(", prefix, ", \"", nn[i], "\")", sep = "")
		cat(this, ":\n", sep = "")
		HTMLExport(a[[i]], File = File, prefix = this, ...)
	}
	invisible(x)
}
"HTMLInsertBreak"<-
function(File = "", Width = "100%", Align = "center", Size = "3")
{
	cat(paste("<HR WIDTH=", Width, " ALIGN=", Align, " SIZE=", Size, ">", 
		sep = "", collapse = ""), sep = "", file = File, append = T)
}
"HTMLTitre"<-
function(Titre, Border = 0, BackColor = "C0C0C0", Size = "+2", Color = "000063",
	Width = "100%", File = "", Align = "CENTER", FontName = "Arial", ...)
{
	cat(paste("</CENTER><P ALIGN=", Align, "><TABLE WIDTH=", Width, 
		" BORDER=", Border, "><TD BGCOLOR=", BackColor, 
		" WIDTH=100%><FONT FACE='", FontName, "' SIZE=", Size, 
		" COLOR=", Color, "><B>", Titre, "</B></FONT></TD></TABLE></P>",
		sep = ""), file = File, append = T, sep = "")
}
HTMLInsertGraph<-
function(File = "", GraphSaveAs = "jpeg", GraphDirectory = "./", GraphFileName = "", GraphBorder = 1, Align = "center", ...)
#############################################################################
#fonction d'exportation des graphiques, 
#testee uniquement avec le format jpg et tres dependante de la version de R
#(0.90 au moins) et de ghostscript (5.10 au moins)
#############################################################################
{
	if(GraphFileName == "") {
		GraphFileName <-"GRAPH_without_a_name"
	}
	GraphFileName <- paste(GraphDirectory, GraphFileName, ".", GraphSaveAs,sep = "")
	dev2bitmap(GraphFileName, type = GraphSaveAs)
	cat(paste("<BR></CENTER><P ALIGN='", Align, "'><IMG SRC=", 
		GraphFileName," BORDER=", GraphBorder, "></P>", sep = ""), 
		append = T, file = File)
}
HTMLExport.graphics<-
function(x, File = "", GraphDirectory = "c:\\TEMP\\", GraphFileName = "", 
	GraphSaveAs = "JPG", GraphBorder = 1, Align = "center", ...)
{
	if(GraphFileName == "") {
		GraphFileName <-"GRAPH_without_a_name"
	}
	GraphFileName <- paste(GraphDirectory, GraphFileName, ".", GraphSaveAs,sep = "")
	dev2bitmap(GraphFileName, type = GraphSaveAs)
	cat(paste("<P ALIGN=", Align, "><IMG SRC='", GraphFileName, "' BORDER=",
		GraphBorder, "></P>", sep = "", collapse = ""), file = File, 
		append = T, sep = "")
}
