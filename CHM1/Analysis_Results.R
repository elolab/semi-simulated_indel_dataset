Parse_results <- function(file_name)
{
  Results <- read.table(file_name)
  
  Results_tool <- Results[,c(1,2,3)]
  Results_tool <- Results_tool[!(duplicated(Results_tool)),]
  results_D_length <- as.numeric(as.character(Results_tool[,3]))-as.numeric(as.character(Results_tool[,2]))
  Results_tool <- cbind(Results_tool,results_D_length)
  Results_tool_500 <- Results_tool[as.numeric(as.character(Results_tool[,4]))>=50 
                                   & as.numeric(as.character(Results_tool[,4]))<500,]
  print(dim(Results_tool_500)[1])
  Results_tool_10000 <- Results_tool[as.numeric(as.character(Results_tool[,4]))>=500, ]
  print(dim(Results_tool_10000)[1])
  
  Truth_tool <- Results[,c(4,5,6,7)]
  Truth_tool <- Truth_tool[!(duplicated(Truth_tool)),]
  truth_D_length <- as.numeric(as.character(Truth_tool[,3]))-as.numeric(as.character(Truth_tool[,2]))
  Truth_tool <- cbind(Truth_tool,truth_D_length)
  Truth_tool_500 <- Truth_tool[as.numeric(as.character(Truth_tool[,4]))>=50 
                               & as.numeric(as.character(Truth_tool[,4]))<500,]
  print(dim(Truth_tool_500)[1])
  Truth_tool_10000 <- Truth_tool[as.numeric(as.character(Truth_tool[,4]))>=500 ,]
  print(dim(Truth_tool_10000)[1])
}

Tool_sets <- c("Delly","FermiKit","Pindel","Platypus")
for (i in Tool_sets)
{
  file_parse_D <- paste0("./",i,"/Results/",i,".deletion.results.txt")
  file_parse_I <- paste0("./",i,"/Results/",i,".insertion.results.txt")
  print(i)
  print("Deletion")
  Parse_results(file_parse_D)
  print("Insertion")
  Parse_results(file_parse_I)
}


























































