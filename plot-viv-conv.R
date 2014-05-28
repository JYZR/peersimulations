library(splines)
library(lattice)
library(Matrix)
library(ggplot2)
library(gridExtra)
# repo <<- "http://cran.us.r-project.org"

data_path <<- "vivaldi-tmp/meta.csv"
pdf_path <<- "plot-viv-conv.pdf"

data <- read.csv(data_path, header=FALSE, sep=",", 
	col.names=c('iteration', 'cycle', 'error', 'avg_err', 'avg_norm_error', 'avg_uncertainty', 'avg_uncertainty_balance', 'avg_move_distance'))

# Data are read as "Formats" (perhaps like strings?), convert them to numeric instead
data$error = as.numeric(as.character(data$error))
data$avg_err = as.numeric(as.character(data$avg_err))
data$avg_norm_error = as.numeric(as.character(data$avg_norm_error))
data$avg_uncertainty = as.numeric(as.character(data$avg_uncertainty))
data$avg_uncertainty_balance = as.numeric(as.character(data$avg_uncertainty_balance))
data$avg_move_distance = as.numeric(as.character(data$avg_move_distance))

pdf(pdf_path) # Save to coming content to this PDF

plot <- ggplot(data, aes(x=cycle, y=avg_norm_error)) + 
	ggtitle("Convergence in Vivaldi") +
	xlab("Cycles") +
	ylab("Average error") +
	geom_point(size=0.3) +
	stat_summary(fun.data="mean_cl_normal", colour="red", geom="smooth", alpha=0.9, size=0.5)

dev.off() # Tutorials says it should be there when saving PDFs

plot

ggsave(pdf_path)

cat("Enjoy your graph!\n")

## Curve Smoothing ##
## --------------- ##
# plot <- ggplot(data, aes(x=cycle, y=error)) + stat_smooth(method="glm", formula=y~poly(x, 24)) 
# + geom_point()
# + geom_line()
# colour='iteration'

## Marcus and Stefan ##
## ------------------##
# pdf(pdf_path, paper="a4r", height=21, width=35.56)
# plot <- ggplot(data, aes(y=axes$y_values, x=axes$x_values, colour=)) +  # aes()
# 	# opts(title=paste(axes$y_axis_label," (",format(Sys.time(), "%F %T"),")",sep=""), title.theme = theme_text(size = 14, face = "bold"), legend.position="right") + 
# 	stat_smooth() + 
# 	scale_colour_discrete(name = "Test(s)") + 
# 	xlab(paste(axes$x_axis_label)) + 
# 	ylab(paste(axes$y_axis_label,y_axis_units))	
# plot
# ecode = 0
# q(runLast = FALSE, save = "no", status = ecode)



