suppressMessages(library(randomForest))
args = commandArgs(trailingOnly=TRUE)
sting_cgas_pathway = c("CCL5", "CXCL11", "CXCL10", "CXCL9", "CGAS", "IFI16", "ATM", "TMEM173")

if (length(args)==0) {
  stop("At least one argument must be supplied (gene expression file)", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "predicted_csg.csv"
}
#args[1] = "example_input.csv"
# reading the input file (gene expression)
input_ge = read.csv(args[1],sep = ",")

# all genes should be part of dataset 
if(sum(!sting_cgas_pathway %in% colnames(input_ge) ) != 0){
  stop(paste0("Gene expression data should contain following columns ", sting_cgas_pathway))
}

# reading the model
model = readRDS("model.rds")

# predicting the scaled input data
input_ge$CSG = predict(model, scale(input_ge[,sting_cgas_pathway], center = T, scale = T))
# writting the original data + CSG out as file
write.csv(x = input_ge, args[2])
