  # Permite uploads grandes (≈ 4 GB)
  options(shiny.maxRequestSize = 4096 * 1024^2)

  # Packages needed to load the app
  # If some package is not installed, please use the code in the example for for the packages you don't have:
  
  #install.packages("shinycssloaders")
  
  library(shiny)
  library(DESeq2)
  library(ggplot2)
  library(DT)
  library(pheatmap)
  library(VennDiagram)
  library(grid)
  library(readxl)  
  library(plotly)
  library(shiny)
  library(shinythemes)
  library(shinycssloaders) 

  
  ui <- fluidPage(
    theme = shinytheme("flatly"),  # 🔥 Tema moderno e limpo
    
    titlePanel("TransDegAnalyser"),
    
    tabsetPanel(
      id = "tabs",
      type = "tabs",
      
      # ---------- Welcome / Home ----------
      # ---------- Welcome / Home ----------
      tabPanel("Welcome",
               tags$div(
                 style = "text-align:center; padding:50px; background: linear-gradient(to bottom, #f7f9fa, #e8f0f5); font-family: 'Inter', sans-serif;",
                 
                 # Hero Section
                 tags$h1("TransDegAnalyser", style = "color:#2C3E50; font-weight:800; font-size:52px; margin-bottom:5px;"),
                 tags$p("Welcome to TransDegAnalyser – your platform to explore differential gene expression across generations and uncover potential transgenerational effects.",
                        style = "color:#555555; font-size:15pt; max-width:900px; margin-left:auto; margin-right:auto; line-height:1.9;"),
                 br(),
                 
                 # Info Cards: Understanding, App, Generations
                 tags$div(
                   style = "display:flex; justify-content:center; flex-wrap:wrap; gap:20px; margin-top:40px;",
                   
                   # Card 1: Understanding Transgenerational Effects
                   tags$div(
                     style = "background-color:white; padding:25px; border-radius:15px; width:350px; box-shadow:0 6px 20px rgba(0,0,0,0.1); transition:0.3s;",
                     tags$h3("🧬 Understanding Transgenerational Effects", style="font-size:24px; margin-bottom:15px; color:#2C3E50;"),
                     tags$p("Some gene expression changes persist in generations that were never directly exposed to a stimulus or contaminant. Understanding these effects helps uncover true epigenetic inheritance.",
                            style="font-size:12.5pt; line-height:1.6; color:#555555;")
                   ),
                   
                   # Card 2: What TransDegAnalyser Does
                   tags$div(
                     style = "background-color:white; padding:25px; border-radius:15px; width:350px; box-shadow:0 6px 20px rgba(0,0,0,0.1); transition:0.3s;",
                     tags$h3("⚡ What TransDegAnalyser Does", style="font-size:24px; margin-bottom:15px; color:#2C3E50;"),
                     tags$p("Explore global variance (PCA), identify differentially expressed genes, visualize heatmaps, compare generations, and perform functional enrichment analysis.",
                            style="font-size:12.5pt; line-height:1.6; color:#555555;")
                   ),
                   
                   # Card 3: Explore Generations & Comparisons
                   tags$div(
                     style = "background-color:white; padding:25px; border-radius:15px; width:350px; box-shadow:0 6px 20px rgba(0,0,0,0.1); transition:0.3s;",
                     tags$h3("🌱 Explore Generations & Comparisons", style="font-size:24px; margin-bottom:15px; color:#2C3E50;"),
                     tags$p("Compare generations to detect shared or unique expression changes. For maternal exposures, F3 is the first true transgenerational generation; for paternal exposures, F2.",
                            style="font-size:12.5pt; line-height:1.6; color:#555555;")
                   )
                 ),
                 
                 # Diagram Section
                 tags$div(
                   style = "margin-top:50px; display:flex; justify-content:center; align-items:center; gap:15px; font-size:24px; color:#34495E; font-weight:600;",
                   tags$span("F0 🧪"),
                   tags$span("→"),
                   tags$span("F1"),
                   tags$span("→"),
                   tags$span("F2"),
                   tags$span("→"),
                   tags$span("F3 🌱")
                 ),
                 
                 # Key Features Section
                 tags$div(
                   style = "margin-top:50px; margin-bottom:50px; text-align:center;",
                   tags$h4("🔧 Key Features", style = "color:#2C3E50; margin-bottom:30px;"),
                   tags$div(
                     style = "display:flex; justify-content:center; flex-wrap: wrap; gap:20px;",
                     
                     # PCA Card
                     tags$div(
                       style = "background-color:#E0F7F1; padding:25px; border-radius:15px; width:260px; box-shadow:0 6px 20px rgba(0,0,0,0.1);",
                       tags$h1("📊", style="font-size:48px; margin-bottom:15px;"),
                       tags$h5("Principal Component Analysis (PCA)", style="margin-bottom:10px; font-weight:600; color:#1ABC9C;"),
                       tags$p("Explore global variance and see how samples cluster by group.", style="font-size:12.5pt; color:#555555;")
                     ),
                     
                     # DEGs Card
                     tags$div(
                       style = "background-color:#E8F4FD; padding:25px; border-radius:15px; width:260px; box-shadow:0 6px 20px rgba(0,0,0,0.1);",
                       tags$h1("🧪", style="font-size:48px; margin-bottom:15px;"),
                       tags$h5("Differentially Expressed Genes", style="margin-bottom:10px; font-weight:600; color:#3498DB;"),
                       tags$p("Identify DEGs for each generation to detect meaningful expression changes.", style="font-size:12.5pt; color:#555555;")
                     ),
                     
                     # Heatmaps Card
                     tags$div(
                       style = "background-color:#FEF3E6; padding:25px; border-radius:15px; width:260px; box-shadow:0 6px 20px rgba(0,0,0,0.1);",
                       tags$h1("🔥", style="font-size:48px; margin-bottom:15px;"),
                       tags$h5("Heatmaps", style="margin-bottom:10px; font-weight:600; color:#E67E22;"),
                       tags$p("Visualize expression patterns across samples for significant genes.", style="font-size:12.5pt; color:#555555;")
                     ),
                     
                     # Transgenerational Comparison Card
                     tags$div(
                       style = "background-color:#F4E8FD; padding:25px; border-radius:15px; width:260px; box-shadow:0 6px 20px rgba(0,0,0,0.1);",
                       tags$h1("🔄", style="font-size:48px; margin-bottom:15px;"),
                       tags$h5("Transgenerational Comparison", style="margin-bottom:10px; font-weight:600; color:#9B59B6;"),
                       tags$p("Detect shared or unique expression changes across generations.", style="font-size:12.5pt; color:#555555;")
                     ),
                     
                     # Functional Enrichment Card
                     tags$div(
                       style = "background-color:#FEF9E7; padding:25px; border-radius:15px; width:260px; box-shadow:0 6px 20px rgba(0,0,0,0.1);",
                       tags$h1("🧩", style="font-size:48px; margin-bottom:15px;"),
                       tags$h5("Functional Enrichment", style="margin-bottom:10px; font-weight:600; color:#F1C40F;"),
                       tags$p("Analyze GO terms, KEGG pathways, and EggNOG annotations for DEGs.", style="font-size:12.5pt; color:#555555;")
                     )
                   )
                 ),
                 
                 # Getting Started Timeline
                 tags$div(
                   style = "margin-top:50px; text-align:center;",
                   tags$h3("📌 Getting Started", style="color:#2C3E50; font-weight:700; margin-bottom:30px;"),
                   
                   tags$div(
                     style = "display:flex; justify-content:center; flex-wrap:wrap; gap:20px; position:relative; padding-bottom:30px;",
                     
                     # Connecting line
                     tags$div(style="position:absolute; top:50%; left:10%; right:10%; height:4px; background:#BDC3C7; z-index:0;"),
                     
                     # Step Cards
                     lapply(list(
                       list(title="1️⃣ Upload Data", desc="Go to the 'PCA / Data Upload' tab and upload your metadata and counts files.", color="#1ABC9C"),
                       list(title="2️⃣ Explore & Analyze", desc="Explore PCA plots, identify differentially expressed genes, and visualize heatmaps.", color="#F39C12"),
                       list(title="3️⃣ Functional Enrichment", desc="When ready, go to the 'Functional Enrichment' tab and upload your functional annotation file.", color="#E74C3C")
                     ), function(s){
                       tags$div(
                         style = paste0("background-color:white; padding:20px; border-radius:15px; width:280px; box-shadow:0 6px 15px rgba(0,0,0,0.1); position:relative; z-index:1;"),
                         tags$h4(s$title, style=paste0("color:", s$color, "; font-weight:600; margin-bottom:10px;")),
                         tags$p(s$desc, style="color:#555555; font-size:12.5pt; line-height:1.5;")
                       )
                     })
                   )
                 )
               )
      ),
      
      
      # ---------- PCA ----------
      tabPanel("PCA",
               sidebarLayout(
                 sidebarPanel(
                   helpText("📊 PCA (Principle Component Analysis) shows the overall variation in your data and and how samples cluster by group.
                            Upload the metadata and counts files to run PCA. Make sure they follow the expected format."),
                   tags$h5(tags$b("Step 1: Metadata File")),
                   tags$p("Contains information about each sample. This file is essential to link your count data to experimental conditions."),
                   tags$p("File should be in CSV or TSV format with at least the following columns:"),
                   tags$ul(
                     tags$li(tags$b("sample_id"), " – must match column names in the counts table below."),
                     tags$li(tags$b("group"), " – e.g. treatment or condition name."),
                     tags$li(tags$b("generation"), " – e.g. F0, F3."),
                     tags$li(tags$b("group_generation"), " – combined label (used for PCA grouping).")
                   ),
                   #br(),
                   fileInput("metadata_pca", "📂 Upload Metadata (CSV/TSV)", accept = c(".csv", ".tsv")),
                   # ↓ Botão de download de ficheiro de exemplo
                   tags$h6("📂 Example Metadata File"),
                   downloadButton("download_example_metadata", "Download Example Metadata", class = "btn-sm"),
                   
                   tags$h5(tags$b("Step 2: Counts Table")),
                   tags$p("The counts table is the output from Corset (or similar software) and contains raw read counts for each gene or cluster across samples. 
                    An extra column for Protein IDs is included for downstream annotation, although it is not required for PCA."),
                   tags$p("File should be in TXT format with at least the following columns:"),
                   tags$ul(
                     tags$li(tags$b("First column:"), " Cluster ID."),
                     tags$li(tags$b("Second column:"), " Protein identifier."),
                     tags$li(tags$b("Remaining columns:"), " counts for each sample (must match sample_id in metadata).")
                   ),
                   #fileInput("metadata_pca", "📂 Upload Metadata (CSV/TSV)", accept = c(".csv", ".tsv")),
                   #br(),
                   
                   fileInput("counts_pca", "📂 Upload Counts Table (.txt)", accept = ".txt"),
                   # ↓ Botão de download de ficheiro de exemplo
                   tags$h6("📂 Example Counts Table"),
                   downloadButton("download_example_counts", "Download Example Counts", class = "btn-sm"),
                   actionButton("run_pca", "🚀 Run PCA", class = "btn btn-primary")
                 ),
                 
                 mainPanel(
                   withSpinner(plotOutput("pca_plot")),  # 🔥 Spinner enquanto carrega
                   br(),
                   textOutput("pca_interpretation"),
                   br(),
                   downloadButton("download_pca_explanation", "📥 Download PCA Interpretation"),
                   downloadButton("download_pca_plot", "📥 Download PCA Plot"),
                   br(), br(),
                   verbatimTextOutput("pca_info")
                 )
               )
      ),
      
      # ---------- Differential Analysis ----------
      tabPanel("Differential Analysis",
               sidebarLayout(
                 sidebarPanel(
                   helpText("🧬 Differential Expression Analysis identifies genes that are significantly up- or down-regulated between selected groups and generations. 
                            Use the same metadata and counts files uploaded for PCA."),
                   
                   
                   tags$h5(tags$b("Step 1: Upload files")),
                   tags$p("Upload the same metadata and counts table used for PCA:"),
                   tags$ul(
                     tags$li(tags$b("Metadata (CSV/TSV)"), " – must contain sample_id, group and generation."),
                     tags$li(tags$b("Counts table (.txt)"), " – raw counts of each gene/cluster per sample; Protein ID column.")
                   ),
                   fileInput("metadata_diff", "📂 Upload Metadata (CSV/TSV)", accept = c(".csv", ".tsv")),
                   fileInput("counts_diff", "📂 Upload Counts Table (.txt)", accept = ".txt"),
                   
                   tags$h5(tags$b("Step 2: Select generation")),
                   uiOutput("choose_generation"),
                   
                   tags$h5(tags$b("Step 3: Choose treatment levels")),
                   uiOutput("choose_treatment_levels"),
                   
                   tags$h5(tags$b("Step 4: Set Thresholds")),
                   tags$p("Genes are considered significant if they meet BOTH criteria:"),
                   tags$ul(
                     tags$li(tags$b("Absolute log2 fold change above the threshold"), " – indicates that the expression of the gene is meaningfully different between the selected groups, suggesting it is up- or down-regulated (biologically relevant change). Up-regulation (positive log2FC); Down-regulation (negative log2FC)."),
                     tags$li(tags$b("Adjusted p-value (Benjamini-Hochberg) below the cutoff"), " – indicates that the observed difference is unlikely to have occurred by chance (statistically significant).")
                   ),
                   numericInput("lfc_threshold", "Log2 Fold Change Threshold", value = 1, step = 0.1),
                   numericInput("pval_threshold", "Adjusted p-value Threshold", value = 0.05, step = 0.01),
                   
                   actionButton("run_diff", "🚀 Run Differential Analysis", class = "btn btn-primary")
                   
                 ),
                 
                 mainPanel(
                   withSpinner(plotOutput("volcano_plot")),  # 🔥 Spinner
                   br(),
                   textOutput("diff_interpretation"),
                   br(),
                   downloadButton("download_volcano", "📥 Download Volcano Plot"),
                   downloadButton("download_diff_table", "📥 Download DEG Table"),
                   br(),
                   uiOutput("diff_table_title"),
                   withSpinner(DTOutput("diff_table"))
                   
                 )
               )
      ),
      
      # ---------- Heatmap ----------
      tabPanel("Heatmap",
               sidebarLayout(
                 sidebarPanel(
                   helpText(
                     "📈 Generate a heatmap showing the expression patterns of genes that are significantly differentially expressed 
                      between selected generations and treatments."),
                   
                   #tags$p(tags$b("⚠️ Note:"), " You don't need to run the Differential Expression Analysis first to generate significant genes for the heatmap."),
                   
                   tags$h5(tags$b("Step 1: Select Generations")),
                   
                   uiOutput("choose_generations_heatmap"),
                   
                   tags$h5(tags$b("Step 2: Select Treatments")),
                   uiOutput("choose_treatments_heatmap"),
                   
                   tags$h5(tags$b("Step 3: Set Thresholds")),
                   numericInput("lfc_threshold_hm", "Threshold log2FoldChange", value = 1, step = 0.1),
                   numericInput("pval_threshold_hm", "Threshold p-adj", value = 0.05, step = 0.01),
                   
                   br(),
                   actionButton("run_heatmap", "🔥 Run Heatmap", class = "btn btn-primary")
                   
                 ),
                 
                 mainPanel(
                   withSpinner(plotOutput("heatmap_plot")),
                   br(),
                   textOutput("heatmap_interpretation"),
                   br(),
                   downloadButton("download_heatmap", "📥 Download Heatmap")
                 )
               )
      ),
      
      # ---------- Transgenerational Comparison ----------
      tabPanel("Transgenerational Comparison",
               sidebarLayout(
                 sidebarPanel(
                   helpText(
                     "🔍 Compare differentially expressed genes (DEGs) between generations. 
                    This allows you to identify genes that are consistently regulated across generations, 
                    as well as those unique to a specific generation."
                   ),
                   
                   tags$h5(tags$b("Step 1: Choose Genes to Show")),
                   selectInput("venn_choice", "Show genes:", 
                               choices = c("F0", "F3", "Intersection"), 
                               selected = "Intersection"),
                   
                   tags$h5(tags$b("Step 2: Set Thresholds")),
                   numericInput("lfc_threshold_tc", "Threshold log2FoldChange", value = 1, step = 0.1),
                   numericInput("pval_threshold_tc", "Threshold p-adj", value = 0.05, step = 0.01),
                   
                   br(),
                   actionButton("run_venn", "🔄 Run Comparison", class = "btn btn-primary")
                   
                 ),
                 
                 mainPanel(
                   withSpinner(plotOutput("venn_plot")),
                   br(),
                   textOutput("venn_interpretation"),
                   br(),
                   downloadButton("download_venn", "📥 Download Venn Diagram"),
                   downloadButton("download_venn_table", "📥 Download Table"),
                   br(),
                   withSpinner(DTOutput("venn_table"))
                   
                 )
               )
      ),
      
      # ---------- Functional Enrichment ----------
      tabPanel("Functional Enrichment",
               sidebarLayout(
                 sidebarPanel(
                   helpText(
                     "🧩 Perform functional enrichment analysis to identify biological processes (GO) and pathways (KEGG) 
                    that are over-represented among your differentially expressed genes (DEGs). 
                    This analysis highlights potential functional roles and molecular mechanisms of your DEGs."
                   ),
                   
                   tags$h5(tags$b("Step 1: Upload file")),
                   tags$p("The annotation file is generated by merging transcriptome annotations from external databases 
                          (e.g., NCBI NR, InterProScan, EggNOG). It contains functional information for each gene or cluster."),
                   tags$p(
                     "File should be in XLSX format with the following columns:"),
                   
                   tags$ul(
                     tags$li(tags$b("gene"), " – gene or cluster IDs (must match the DEGs)."),
                     tags$li(tags$b("EggNOG"), " – EggNOG annotation."),
                     tags$li(tags$b("Categoria"), " – functional category or group."),
                     tags$li(tags$b("GO"), " – Gene Ontology terms, separated by semicolons (;)."),
                     tags$li(tags$b("KEGG_pathway"), " – KEGG pathway IDs or names, separated by semicolons (;)."),
                     tags$li(tags$b("EC_number"), " – Enzyme Commission numbers.")
                   ),
                   #br(),
                   
                   fileInput("functional_file", "📂 Upload Annotation XLSX", accept = ".xlsx"),
                   # ↓ Botão de download de ficheiro de exemplo
                   tags$h6("📂 Example Annotation File"),
                   downloadButton("download_example_annotation", "Download Example Annotation", class = "btn-sm"),
                   
                   tags$h5(tags$b("Step 2: Select Generation")),
                   selectInput("generation_fe", "Select Generation",
                               choices = c("F0", "F3", "Intersection"),
                               selected = "Intersection"),
                   
                   tags$h5(tags$b("Step 3: Set Thresholds")),
                   tags$ul(
                     tags$li(tags$b("Absolute log2 fold change above the threshold"), " – indicates that the expression of the gene is meaningfully different between the selected groups, suggesting it is up- or down-regulated (biologically relevant change). Up-regulation (positive log2FC); Down-regulation (negative log2FC)."),
                     tags$li(tags$b("Adjusted p-value (Benjamini-Hochberg) below the cutoff"), " – indicates that the observed difference is unlikely to have occurred by chance (statistically significant).")
                   ),
                   numericInput("lfc_threshold_fe", "Threshold log2FoldChange", value = 1, step = 0.1),
                   numericInput("pval_threshold_fe", "Threshold p-adj", value = 0.05, step = 0.01),
                   
                   tags$h5(tags$b("Step 4: Set Top N terms to plot")),
                   numericInput("top_n_terms", "Top N terms to plot", value = 10, step = 1),
                   
                   br(),
                   actionButton("run_fe", "📊 Run Enrichment", class = "btn btn-primary")
                   
                   
                 ),
                 
                 
                 
                 mainPanel(
                   tabsetPanel(

                     tabPanel("Barplot", 
                              tags$h4("Top Enriched Terms (Barplot)"),
                              withSpinner(plotOutput("fe_barplot")),
                              br(),
                              textOutput("fe_barplot_interpretation"),
                              br(),
                              downloadButton("download_fe_barplot", "📥 Download Barplot")
                     ),
     
                     tabPanel("Interactive Table",
                              br(),
                              textOutput("fe_table_interpretation"),
                              br(),
                              downloadButton("download_fe_table", "📥 Download Enrichment Table"),
                              br(),
                              DTOutput("fe_table")
                              
                      
                   )
                 )
               )
        )
      )
    )
  ) 
  
  server <- function(input, output, session) {
    
    # ========================================================
    format_num <- function(x, digits = 3, sci_thresh = 0.001) {
      sapply(x, function(val) {
        if (is.na(val)) return(NA)
        
        # Se o valor é muito pequeno, usa científica
        if (abs(val) > 0 && abs(val) < sci_thresh) {
          format(val, scientific = TRUE, digits = digits)
        } else {
          # Caso contrário, mostra normal com 'digits' casas decimais
          format(round(val, digits), nsmall = digits)
        }
      })
    }
    
    # ======================== Example Files Download ========================

    

    
    # Example Metadata for PCA / Differential Analysis
    output$download_example_metadata <- downloadHandler(
      filename = function() { "example_metadata.csv" },
      content = function(file) {
        file.copy("example_data/metadata2.csv", file)
      }
    )
    
    # Example Counts Table for PCA / Differential Analysis
    output$download_example_counts <- downloadHandler(
      filename = function() { "example_counts.txt" },
      content = function(file) {
        file.copy("example_data/counts_filtered.txt", file)
      }
    )
    
    # Example Annotation File for Functional Enrichment
    output$download_example_annotation <- downloadHandler(
      filename = function() { "example_annotation.xlsx" },
      content = function(file) {
        file.copy("example_data/merged_annotations_counts.xlsx", file)
      }
    )
    
    
    
    # ======================================================================== PCA ==================================================
    metadata_pca <- reactive({
      req(input$metadata_pca)
      
      # Detecta separador automaticamente (CSV ou TSV)
      df <- read.table(
        input$metadata_pca$datapath,
        header = TRUE,
        sep = ifelse(grepl("\\.csv$", input$metadata_pca$name, ignore.case = TRUE), ",", "\t"),
        check.names = FALSE,
        stringsAsFactors = FALSE,
        comment.char = ""  # evita ler linhas vazias como comentários
      )
      
      # Remove colunas completamente vazias (caso existam no ficheiro)
      df <- df[, colSums(df != "") > 0, drop = FALSE]
      
      # Remove espaços ou caracteres extras no fim/início de cada célula
      df[] <- lapply(df, function(x) gsub(";+$", "", trimws(x)))
      
      # Confirma que sample_id é único
      df$sample_id <- make.unique(df$sample_id)
      
      # Debug: imprime primeiros valores e níveis únicos de grupo_combinado
      print(head(df))
      print(unique(df$grupo_combinado))
      
      df
    })

    counts_pca <- reactive({
      req(input$counts_pca)
      df <- read.table(
        input$counts_pca$datapath,
        header=TRUE, sep="\t", check.names=FALSE, stringsAsFactors=FALSE
      )
      
      rownames(df) <- make.unique(df$Cluster)
      df <- df[, !(colnames(df) %in% c("Cluster","Protein")), drop=FALSE]
      
      print(head(df))  # <-- para veres no console do R como ficou
      
      df
    })
    
    
    pca_result <- eventReactive(input$run_pca, {
      meta <- metadata_pca()
      counts <- counts_pca()
      
      counts <- counts[, meta$sample_id, drop=FALSE]
      keep <- rowSums(counts) >= 10
      counts <- counts[keep,]
      
      dds <- DESeqDataSetFromMatrix(countData = round(counts),
                                    colData = data.frame(row.names=meta$sample_id, grupo_combinado=meta$grupo_combinado),
                                    design = ~ grupo_combinado)
      vst_data <- vst(dds, blind=TRUE)
      
      pca_data <- plotPCA(vst_data, intgroup="grupo_combinado", returnData=TRUE)
      percentVar <- round(100 * attr(pca_data, "percentVar"))
      
      # Adiciona sample_id para usar como label
      pca_data$name <- rownames(pca_data)
      
      
      list(pca_data=pca_data, percentVar=percentVar)
    })
    
    
    #output$pca_plot <- renderPlot({
    pca_plot_gg <- reactive({
      req(pca_result())
      pca_data <- pca_result()$pca_data
      percentVar <- pca_result()$percentVar
      
      ggplot(pca_data, aes(PC1, PC2, color=grupo_combinado, label=name)) +
        geom_point(size=4) +
        geom_text_repel(size=3, max.overlaps=30) +
        xlab(paste0("PC1: ", percentVar[1], "% variance")) +
        ylab(paste0("PC2: ", percentVar[2], "% variance")) +
        labs(title = "Principal Component Analysis (PCA)") +
        theme_minimal()
    })
    
    # --- render the plot in the UI ---
    output$pca_plot <- renderPlot({
      print(pca_plot_gg())
    })
    
    
    # Download do plot PCA
    output$download_pca_plot <- downloadHandler(
      filename = function() { paste0("PCA_plot_", Sys.Date(), ".png") },
      content = function(file) {
        req(pca_plot_gg())
        ggsave(file, plot = pca_plot_gg(), width = 8, height = 6, dpi = 300)
      }
    )
    
    
    # --- SHORT INTERPRETATION BELOW THE PLOT ---
    output$pca_interpretation <- renderText({
      req(pca_result())
      pca_data <- pca_result()$pca_data
      percentVar <- pca_result()$percentVar
      
      groups <- unique(pca_data$group)
      n_samples <- nrow(pca_data)
      n_groups <- length(groups)
      
      # Mensagem sobre clustering
      clustering_msg <- if (n_groups > 1) {
        group_centers <- aggregate(cbind(PC1, PC2) ~ group, data=pca_data, FUN=mean)
        separation <- max(dist(group_centers[, c("PC1", "PC2")]))
        
        if (separation > 5) {
          "Samples from different groups form distinct clusters, suggesting clear differences in global expression patterns."
        } else {
          "Some overlap between groups is observed, indicating partial similarity in expression profiles across treatments."
        }
      } else {
        "All samples belong to a single group, so no clustering by treatment is expected."
      }
      
      # Outliers
      pc_dist <- sqrt(pca_data$PC1^2 + pca_data$PC2^2)
      outliers <- sum(pc_dist > mean(pc_dist) + 2*sd(pc_dist))
      outlier_msg <- if(outliers > 0) {
        paste0(" Additionally, ", outliers, " sample(s) appear to deviate from the main cluster and could be considered outliers.")
      } else {
        ""
      }
      
      paste0(
        "Principal Component Analysis (PCA) was performed on ", n_samples, 
        " samples", if(n_groups > 1) paste0(" divided into ", n_groups, " groups (", paste(groups, collapse=", "), ")"), ". ",
        "The first principal component (PC1) and the second principal component (PC2) are axes that summarize the overall differences in expression patterns across samples. ",
        "PC1 captures the largest source of variation between samples, showing which samples are most different from each other overall, while PC2 captures the second largest source of variation that is independent of PC1, highlighting subtler differences. ",
        "PC1 explains ", percentVar[1], "% of the total variance and PC2 explains ", percentVar[2], "%, providing a two-dimensional overview of sample relationships. ",
        clustering_msg, outlier_msg, " ",
        "The PCA plot visualizes how similar or different the samples are based on overall expression profiles. Each point represents a sample, and points close together indicate similar expression patterns."
      )
    })
    
    
    
    # --- DOWNLOADABLE FULL REPORT ---
    output$download_pca_explanation <- downloadHandler(
      filename = function() {
        paste0("PCA_explanation_", Sys.Date(), ".txt")
      },
      content = function(file) {
        req(pca_result())
        pca_data <- pca_result()$pca_data
        percentVar <- pca_result()$percentVar
        
        # Calculate centroids per group
        cluster_summary <- pca_data |>
          dplyr::group_by(group) |>
          dplyr::summarise(
            PC1_mean = round(mean(PC1), 2),
            PC2_mean = round(mean(PC2), 2),
            .groups = "drop"
          )
        
        explanation <- paste0(
          "Principal Component Analysis (PCA) - Detailed Interpretation\n",
          "-------------------------------------------------\n",
          "PC1 explained ", percentVar[1], "% of the total variance.\n",
          "PC2 explained ", percentVar[2], "% of the total variance.\n\n",
          "Group centroids:\n",
          paste0(
            apply(cluster_summary, 1, function(row) {
              paste0("- Group ", row["group"], 
                     ": PC1 = ", row["PC1_mean"], 
                     ", PC2 = ", row["PC2_mean"])
            }),
            collapse = "\n"
          ),
          "\n\nGeneral interpretation:\n",
          "Groups that are farther apart along PC1 represent more distinct global expression profiles. ",
          "If there is clear separation between groups, this suggests a strong effect of the experimental condition on the transcriptome. ",
          "Variation along PC2 may reflect additional factors, such as generation effects or biological variability.\n"
        )
        
        writeLines(explanation, file)
      }
    )
    
    output$pca_info <- renderPrint({
      req(pca_result())
      summary(pca_result()$pca_data)
    })
    
    
    # ============================================================ Differential Analysis ==============================================================
    metadata_diff <- reactive({
      req(input$metadata_diff)
      read.csv(input$metadata_diff$datapath)
    })
    
    counts_diff <- reactive({
      req(input$counts_diff)
      df <- read.table(input$counts_diff$datapath, header=TRUE, sep="\t", check.names=FALSE, stringsAsFactors=FALSE)
      
      rownames(df) <- make.unique(df$Cluster)
      protein_map <- df$Protein
      names(protein_map) <- rownames(df)
      
      list(
        counts = df[, !(colnames(df) %in% c("Cluster","Protein"))],
        proteins = protein_map
      )
    })
    
    
    output$choose_generation <- renderUI({
      req(metadata_diff())
      selectInput("generation_sel", "Selecionar geração",
                  choices = unique(metadata_diff()$generation),
                  selected = unique(metadata_diff()$generation)[1])
    })
    
    output$choose_treatment_levels <- renderUI({
      req(metadata_diff(), input$generation_sel)
      meta_gen <- metadata_diff()[metadata_diff()$generation == input$generation_sel, ]
      tratamentos <- unique(meta_gen$group)
      selectInput("treatment_levels", "Selecionar tratamentos para comparar",
                  choices = tratamentos,
                  selected = tratamentos[1:2],
                  multiple = TRUE)
    })
    
    diff_results <- eventReactive(input$run_diff, {
      meta <- metadata_diff()
      counts_obj <- counts_diff()
      counts <- counts_obj$counts
      proteins <- counts_obj$proteins
      
      meta <- meta[meta$generation == input$generation_sel, ]
      counts_sub <- counts[, meta$sample_id, drop=FALSE]
      
      keep_samples <- meta$group %in% input$treatment_levels
      meta <- meta[keep_samples, ]
      counts_sub <- counts_sub[, meta$sample_id, drop=FALSE]
      
      meta$group <- factor(meta$group, levels = input$treatment_levels)
      
      keep_genes <- rowSums(counts_sub) >= 10
      counts_sub <- counts_sub[keep_genes, ]
      
      dds <- DESeqDataSetFromMatrix(
        countData = round(counts_sub),
        colData = data.frame(row.names = meta$sample_id, group = meta$group),
        design = ~ group
      )
      
      dds <- DESeq(dds)
      res <- results(dds)
      
      res_df <- as.data.frame(res)
      res_df$gene <- rownames(res_df)
      res_df$Protein <- proteins[res_df$gene]
      
      res_df
    })
    
    volcano_plot_gg <- reactive({
      res <- diff_results()
      req(res)
      
      res_df <- res[!is.na(res$pvalue) & !is.na(res$padj), ]
      res_df$significativo <- ifelse(
        res_df$padj < input$pval_threshold & abs(res_df$log2FoldChange) >= input$lfc_threshold,
        "Sim", "Não"
      )
      
      ggplot(res_df, aes(x = log2FoldChange, y = -log10(pvalue), color = significativo)) +
        geom_point(alpha = 0.6) +
        scale_color_manual(values = c("Sim" = "red", "Não" = "gray")) +
        theme_minimal() +
        labs(
          title = paste0(
            "Volcano Plot – ", input$generation_sel, 
            " (", paste(input$treatment_levels, collapse = " vs "), ")"
          ),
          x = "log2 Fold Change", 
          y = "-log10(p-valor)", 
          color = "Significativo"
        )
    })
    
    
    output$volcano_plot <- renderPlot({
      print(volcano_plot_gg())
    })
    
    output$download_volcano <- downloadHandler(
      filename = function() { paste0("VolcanoPlot_", input$generation_sel, ".png") },
      content = function(file) {
        ggsave(file, plot = volcano_plot_gg(), width = 8, height = 6, dpi = 300)
      }
    )
    
    
    output$diff_interpretation <- renderText({
      req(diff_results())
      res <- diff_results()
      
      # Filtra apenas os genes significativos com base nos thresholds escolhidos
      sig_res <- res[!is.na(res$padj) &
                       res$padj < input$pval_threshold &
                       abs(res$log2FoldChange) >= input$lfc_threshold, ]
      
      n_total <- nrow(res)             
      n_sig   <- nrow(sig_res)         
      perc_sig <- round(100 * n_sig / n_total, 2)  
      
      n_up  <- sum(sig_res$log2FoldChange > 0, na.rm = TRUE)
      n_down <- sum(sig_res$log2FoldChange < 0, na.rm = TRUE)
      
      perc_up <- round(100 * n_up / n_sig, 2)      
      perc_down <- round(100 * n_down / n_sig, 2)  
      
      n_strong_up <- sum(sig_res$log2FoldChange > 2, na.rm = TRUE)
      n_strong_down <- sum(sig_res$log2FoldChange < -2, na.rm = TRUE)
      
      # Texto principal
      txt <- paste0(
        "Differential expression analysis for generation ", input$generation_sel, 
        " comparing ", paste(input$treatment_levels, collapse = " vs "), ":\n\n",
        "A total of ", n_total, " genes were tested, of which ", n_sig, " (", perc_sig, 
        "%) showed significant changes in expression (padj < ", input$pval_threshold, 
        " and |log2FC| > ", input$lfc_threshold, ").\n\n",
        "Among the significant genes, ", n_up, " (", perc_up, "%) were upregulated, meaning their expression was higher in ", input$treatment_levels[2], 
        ", while ", n_down, " (", perc_down, "%) were downregulated, meaning their expression was higher in ", input$treatment_levels[1], ".\n"
      )
      
      
      # Conclui o texto
      txt <- paste0(
        txt,
        "This summary helps to understand how the treatments influence gene expression and provides a foundation for further functional analysis."
      )
      
      txt
    })
    
    
    output$diff_table_title <- renderUI({
      req(diff_results())
      h4(
        paste0("Differentially Expressed Genes – ",
               input$generation_sel, " (",
               paste(input$treatment_levels, collapse = " vs "), ")")
      )
    })
    
    
    output$diff_table <- renderDT({
      res <- diff_results()
      req(res)
      
      # Filtrar por p-value e log2FC conforme thresholds
      res_df <- res[!is.na(res$pvalue) & !is.na(res$padj), ]
      res_df <- res_df[res_df$padj < input$pval_threshold &
                         abs(res_df$log2FoldChange) >= input$lfc_threshold, ]
      
      # Formatar colunas numéricas usando a função format_num
      num_cols <- c("log2FoldChange", "pvalue", "padj")
      res_df[num_cols] <- lapply(res_df[num_cols], format_num)
      

      datatable(
        res_df[, c("gene", "Protein", "log2FoldChange", "pvalue", "padj")],
        options = list(pageLength = 10),
        rownames = FALSE
      )
    })
    
    
    # Download da tabela de DEGs (diff analysis)
    output$download_diff_table <- downloadHandler(
      filename = function() { paste0("DEG_table_", input$generation_sel, ".csv") },
      content = function(file) {
        req(diff_results())
        res <- diff_results()
        res_filtered <- res[!is.na(res$padj) & 
                              abs(res$log2FoldChange) >= input$lfc_threshold & 
                              res$padj < input$pval_threshold, ]
        write.csv(res_filtered, file, row.names = FALSE)
      }
    )
    
    
    # ====================================================================== Heatmap ==========================================
    output$choose_generations_heatmap <- renderUI({
      req(metadata_diff())
      selectInput("generations_hm", "Selecionar duas gerações",
                  choices = unique(metadata_diff()$generation),
                  selected = unique(metadata_diff()$generation)[1:2],
                  multiple = TRUE)
    })
    
    output$choose_treatments_heatmap <- renderUI({
      req(metadata_diff())
      selectInput("treatments_hm", "Selecionar dois tratamentos",
                  choices = unique(metadata_diff()$group),
                  selected = unique(metadata_diff()$group)[1:2],
                  multiple = TRUE)
    })
    
    
    output$heatmap_plot <- renderPlot({
      req(input$run_heatmap, metadata_diff(), counts_diff(),
          length(input$generations_hm) == 2, length(input$treatments_hm) == 2)
      
      meta <- metadata_diff()
      counts_obj <- counts_diff()
      counts <- counts_obj$counts
      proteins <- counts_obj$proteins
      
      # Subconjunto das amostras selecionadas
      meta <- meta[meta$generation %in% input$generations_hm &
                     meta$group %in% input$treatments_hm, ]
      counts_sub <- counts[, meta$sample_id, drop=FALSE]
      
      # 🔑 Filtragem igual à differential analysis
      keep_genes <- rowSums(counts_sub) >= 10
      counts_sub <- counts_sub[keep_genes, ]
      
      dds <- DESeqDataSetFromMatrix(
        countData = round(counts_sub),
        colData = data.frame(row.names = meta$sample_id,
                             generation = meta$generation,
                             group = meta$group),
        design = ~ generation + group
      )
      
      # Transformação para visualização
      vst_data <- assay(vst(dds, blind=TRUE))
      
      # Rodar DESeq
      dds <- DESeq(dds)
      res <- results(dds)
      res_df <- as.data.frame(res)
      res_df$gene <- rownames(res_df)
      res_df$Protein <- proteins[res_df$gene]
      
      # Filtrar genes significativos com proteína anotada
      sig_genes <- res_df[!is.na(res_df$padj) &
                            res_df$padj < input$pval_threshold_hm &
                            abs(res_df$log2FoldChange) >= input$lfc_threshold_hm &
                            !is.na(res_df$Protein), "gene"]
      
      if (length(sig_genes) < 2) {
        plot.new()
        text(0.5, 0.5, "Poucos genes significativos com anotação para mostrar")
      } else {
        mat <- vst_data[sig_genes, ]
        
        annotation_col <- meta[, c("generation","group")]
        rownames(annotation_col) <- meta$sample_id
        annotation_col <- annotation_col[colnames(mat), , drop=FALSE]
        
        # Desenhar heatmap
        pheatmap(mat,
                 scale = "row",
                 show_rownames = FALSE,
                 annotation_col = annotation_col)
      }
    })
    
    # Interpretação do heatmap
    output$heatmap_interpretation <- renderText({
      req(input$run_heatmap, metadata_diff(), counts_diff(),
          length(input$generations_hm) == 2, length(input$treatments_hm) == 2)
      
      meta <- metadata_diff()
      counts_obj <- counts_diff()
      counts <- counts_obj$counts
      proteins <- counts_obj$proteins
      
      meta <- meta[meta$generation %in% input$generations_hm &
                     meta$group %in% input$treatments_hm, ]
      counts_sub <- counts[, meta$sample_id, drop=FALSE]
      
      # 🔑 Filtragem consistente
      keep_genes <- rowSums(counts_sub) >= 10
      counts_sub <- counts_sub[keep_genes, ]
      total_genes <- nrow(counts_sub)  # Total de genes testados
      
      dds <- DESeqDataSetFromMatrix(
        countData = round(counts_sub),
        colData = data.frame(row.names = meta$sample_id,
                             generation = meta$generation,
                             group = meta$group),
        design = ~ generation + group
      )
      
      dds <- DESeq(dds)
      res <- results(dds)
      res_df <- as.data.frame(res)
      res_df$gene <- rownames(res_df)
      res_df$Protein <- proteins[res_df$gene]
      
      # Filtrar genes significativos para heatmap
      sig_res <- res_df[!is.na(res_df$padj) &
                          res_df$padj < input$pval_threshold_hm &
                          abs(res_df$log2FoldChange) >= input$lfc_threshold_hm &
                          !is.na(res_df$Protein), ]
      
      n_sig <- nrow(sig_res)
      perc_sig <- round(100 * n_sig / total_genes, 2)
      
      paste0(
        "Heatmap generated for generations ", paste(input$generations_hm, collapse = " & "),
        " comparing treatments ", paste(input$treatments_hm, collapse = " vs "), ". ",
        "From a total of ", total_genes, " genes tested, ", n_sig, " (", perc_sig, 
        "%) were found to be significantly differentially expressed based on the chosen thresholds ",
        "(padj < ", input$pval_threshold_hm, ", |log2FC| > ", input$lfc_threshold_hm, "). ",
        "The heatmap shows the differentially expressed genes across all selected samples, with rows representing genes and columns representing samples. ",
        "Colors indicate relative expression levels (after variance stabilizing transformation, which normalizes expression across genes), allowing visualization of gene expression patterns and clustering of samples by treatment or generation. ",
        "This visualization helps to identify groups of genes with similar expression patterns and to assess how samples cluster according to the experimental conditions."
      )
      
    })
    
    # Download do Heatmap
    output$download_heatmap <- downloadHandler(
      filename = function() { paste0("Heatmap_", paste(input$generations_hm, collapse = "_"), ".png") },
      content = function(file) {
        req(input$run_heatmap)
        
        # Recria o heatmap para salvar
        meta <- metadata_diff()
        counts_obj <- counts_diff()
        counts <- counts_obj$counts
        proteins <- counts_obj$proteins
        
        meta <- meta[meta$generation %in% input$generations_hm & meta$group %in% input$treatments_hm, ]
        counts_sub <- counts[, meta$sample_id, drop=FALSE]
        keep_genes <- rowSums(counts_sub) >= 10
        counts_sub <- counts_sub[keep_genes, ]
        
        dds <- DESeqDataSetFromMatrix(
          countData = round(counts_sub),
          colData = data.frame(row.names = meta$sample_id, generation = meta$generation, group = meta$group),
          design = ~ generation + group
        )
        
        vst_data <- assay(vst(dds, blind=TRUE))
        
        res <- results(DESeq(dds))
        res_df <- as.data.frame(res)
        res_df$gene <- rownames(res_df)
        res_df$Protein <- proteins[res_df$gene]
        
        sig_genes <- res_df[!is.na(res_df$padj) & res_df$padj < input$pval_threshold_hm &
                              abs(res_df$log2FoldChange) >= input$lfc_threshold_hm & !is.na(res_df$Protein), "gene"]
        
        if(length(sig_genes) >= 2){
          mat <- vst_data[sig_genes, ]
          annotation_col <- meta[, c("generation","group")]
          rownames(annotation_col) <- meta$sample_id
          annotation_col <- annotation_col[colnames(mat), , drop=FALSE]
          
          png(file, width = 1200, height = 800)
          pheatmap(mat, scale = "row", show_rownames = FALSE, annotation_col = annotation_col)
          dev.off()
        }
      }
    )
    
    
    
    # ======================================================== Transgenerational Comparison ====================
    venn_results <- eventReactive(input$run_venn, {
      meta <- metadata_diff()
      counts_obj <- counts_diff()
      counts <- counts_obj$counts
      proteins <- counts_obj$proteins
      
      run_diff_by_generation <- function(gen) {
        meta_gen <- meta[meta$generation == gen, ]
        counts_sub <- counts[, meta_gen$sample_id, drop=FALSE]
        keep_genes <- rowSums(counts_sub) >= 10
        counts_sub <- counts_sub[keep_genes, ]
        
        dds <- DESeqDataSetFromMatrix(
          countData = round(counts_sub),
          colData = data.frame(row.names = meta_gen$sample_id,
                               group = meta_gen$group),
          design = ~ group
        )
        dds <- DESeq(dds)
        res <- results(dds)
        res_df <- as.data.frame(res)
        res_df$gene <- rownames(res_df)
        res_df$Protein <- proteins[res_df$gene]
        
        sig <- res_df[!is.na(res_df$padj) &
                        res_df$padj < input$pval_threshold_tc &
                        abs(res_df$log2FoldChange) >= input$lfc_threshold_tc, ]
        sig
      }
      
      sig_F0 <- run_diff_by_generation("F0")
      sig_F3 <- run_diff_by_generation("F3")
      
      intersect_genes <- merge(sig_F0, sig_F3, by = "gene", suffixes = c("_F0", "_F3"))
      
      list(
        F0 = sig_F0,
        F3 = sig_F3,
        intersect = intersect_genes
      )
    })
    
  
    venn_plot_obj <- eventReactive(input$run_venn, {
      res <- venn_results()
      grid.newpage()
      draw.pairwise.venn(
        area1 = nrow(res$F0),
        area2 = nrow(res$F3),
        cross.area = nrow(res$intersect),
        category = c("F0", "F3"),
        fill = c("skyblue", "salmon"),
        alpha = 0.5
      )
    })
    
    output$venn_plot <- renderPlot({ venn_plot_obj() })
    
    output$venn_interpretation <- renderText({
      req(venn_results())
      res <- venn_results()
      
      # Número de genes em cada geração
      n_F0 <- nrow(res$F0)
      n_F3 <- nrow(res$F3)
      n_intersect <- nrow(res$intersect)
      
      # Percentagens de interseção
      perc_intersect_F0 <- ifelse(n_F0 > 0, round(100 * n_intersect / n_F0, 2), 0)
      perc_intersect_F3 <- ifelse(n_F3 > 0, round(100 * n_intersect / n_F3, 2), 0)
      
      paste0(
        "In this transgenerational comparison between generations F0 and F3, we identified ", 
        n_F0, " differentially expressed genes in F0 and ", n_F3, " in F3 based on the thresholds log2FC > ",
        input$lfc_threshold_tc, " and padj < ", input$pval_threshold_tc, 
        ". Among these, ", n_intersect, " genes were shared between the two generations, representing ", 
        perc_intersect_F0, "% of F0 and ", perc_intersect_F3, "% of F3, indicating that these genes maintain altered expression across generations. ",
        "The Venn diagram visually illustrates the unique and shared genes, highlighting both generation-specific changes and transgenerationally conserved patterns. ",
        "For the selected set ('", input$venn_choice, "'), the accompanying table provides detailed information including log2FoldChange, p-value, and adjusted p-value, giving insight into the magnitude and statistical significance of the observed expression changes."
      )
    })
    
    # Download do Venn Diagram
    output$download_venn <- downloadHandler(
      filename = function() { paste0("Venn_", input$venn_choice, ".png") },
      content = function(file) {
        req(venn_results())
        res <- venn_results()
        
        area1 <- nrow(res$F0)
        area2 <- nrow(res$F3)
        cross_area <- nrow(res$intersect)
        
        png(file, width = 800, height = 600)
        grid.newpage()
        draw.pairwise.venn(
          area1 = area1,
          area2 = area2,
          cross.area = cross_area,
          category = c("F0", "F3"),
          fill = c("skyblue", "salmon"),
          alpha = 0.5
        )
        dev.off()
      }
    )
    
    
    
    output$venn_table <- renderDT({
      req(venn_results())
      res <- venn_results()
      selected <- switch(input$venn_choice,
                         "F0" = res$F0,
                         "F3" = res$F3,
                         "Intersection" = res$intersect)
      
      if (input$venn_choice == "Intersection") {
        colnames(selected) <- gsub("\\.x$", "_F0", colnames(selected))
        colnames(selected) <- gsub("\\.y$", "_F3", colnames(selected))
        if ("Protein_F0" %in% colnames(selected)) {
          selected$Protein <- selected$Protein_F0
          selected$Protein_F0 <- NULL
          selected$Protein_F3 <- NULL
        }
      }
      
      possible_cols <- c("gene", "Protein", 
                         "log2FoldChange", "log2FoldChange_F0", "log2FoldChange_F3",
                         "pvalue", "pvalue_F0", "pvalue_F3",
                         "padj", "padj_F0", "padj_F3")
      cols_to_show <- intersect(possible_cols, colnames(selected))
      
      # Formatar colunas numéricas
      selected_fmt <- selected[, cols_to_show, drop = FALSE]
      num_cols <- sapply(selected_fmt, is.numeric)
      selected_fmt[num_cols] <- lapply(selected_fmt[num_cols], format_num)
      
      datatable(selected_fmt, options = list(pageLength = 10), rownames=FALSE)
    })
      
    
    output$download_venn_table <- downloadHandler(
      filename = function() {
        paste0("transgenerational_", input$venn_choice, "_table.csv")
      },
      content = function(file) {
        req(venn_results())
        res <- venn_results()
        selected <- switch(input$venn_choice,
                           "F0" = res$F0,
                           "F3" = res$F3,
                           "Intersection" = res$intersect)
        
        if (input$venn_choice == "Intersection") {
          colnames(selected) <- gsub("\\.x$", "_F0", colnames(selected))
          colnames(selected) <- gsub("\\.y$", "_F3", colnames(selected))
          if ("Protein_F0" %in% colnames(selected)) {
            selected$Protein <- selected$Protein_F0
            selected$Protein_F0 <- NULL
            selected$Protein_F3 <- NULL
          }
        }
        
        possible_cols <- c("gene", "Protein", 
                           "log2FoldChange", "log2FoldChange_F0", "log2FoldChange_F3",
                           "pvalue", "pvalue_F0", "pvalue_F3",
                           "padj", "padj_F0", "padj_F3")
        cols_to_show <- intersect(possible_cols, colnames(selected))
        
        write.csv(selected[, cols_to_show, drop = FALSE], file, row.names = FALSE)
      }
    )
    
    
    
    
    
    # ============================================================= Functional Enrichment ====================
    
    # Reactive que só roda quando o botão é clicado
    enrichment_results <- eventReactive(input$run_fe, {
      req(input$functional_file)
      req(venn_results())
      req(input$generation_fe)
      
      ann <- read_excel(input$functional_file$datapath)
      venn <- venn_results()
      gen <- input$generation_fe
      
      # Seleção e filtragem de genes significativos
      if (gen %in% c("F0", "F3")) {
        sig_genes <- venn[[gen]]
        
        validate(need("padj" %in% colnames(sig_genes), 
                      paste("Coluna 'padj' não encontrada no data frame de", gen)))
        
        sig_genes <- sig_genes %>%
          dplyr::filter(!is.na(padj) & padj < input$pval_threshold_fe &
                          !is.na(log2FoldChange) & abs(log2FoldChange) >= input$lfc_threshold_fe)
        
        log2fc_col <- "log2FoldChange"
        
      } else if (gen == "Intersection") {
        sig_genes <- venn[["intersect"]]
        
        validate(need(all(c("padj_F0", "padj_F3") %in% colnames(sig_genes)),
                      "As colunas padj_F0 ou padj_F3 não existem no data frame 'intersect'"))
        
        sig_genes <- sig_genes %>%
          dplyr::filter(!is.na(padj_F0) & padj_F0 < input$pval_threshold_fe &
                          !is.na(padj_F3) & padj_F3 < input$pval_threshold_fe &
                          !is.na(log2FoldChange_F0) & abs(log2FoldChange_F0) >= input$lfc_threshold_fe &
                          !is.na(log2FoldChange_F3) & abs(log2FoldChange_F3) >= input$lfc_threshold_fe)
        
        log2fc_col_F0 <- "log2FoldChange_F0"
        log2fc_col_F3 <- "log2FoldChange_F3"
      }
      
      # Merge com anotações
      sig_genes_annot <- merge(sig_genes, ann, by = "gene", all.x = TRUE)
      
      # Limpar KEGG
      if ("KEGG_pathway" %in% colnames(sig_genes_annot)) {
        sig_genes_annot$KEGG_pathway <- trimws(sig_genes_annot$KEGG_pathway)
        sig_genes_annot$KEGG_pathway[sig_genes_annot$KEGG_pathway == "-(-)"] <- NA
      }
      
      # Função para contar termos e calcular log2FC médio
      process_terms <- function(col) {
        if (!col %in% colnames(sig_genes_annot)) 
          return(data.frame(Termo = character(), Count = integer(), Mean_log2FC = numeric()))
        
        col_values <- sig_genes_annot[[col]]
        col_values <- trimws(col_values)
        col_values <- col_values[!is.na(col_values) & col_values != ""]
        if (col == "KEGG_pathway") col_values <- col_values[col_values != "-(-)"]
        
        terms_list <- unlist(strsplit(paste(col_values, collapse = ";"), ";"))
        terms_list <- trimws(terms_list)
        terms_list <- terms_list[terms_list != "" & !is.na(terms_list)]
        
        if (length(terms_list) == 0)
          return(data.frame(Termo = character(), Count = integer(), Mean_log2FC = numeric()))
        
        terms_table <- as.data.frame(table(terms_list), stringsAsFactors = FALSE)
        colnames(terms_table) <- c("Termo", "Count")
        
        # Calcular log2FC médio
        terms_table$Mean_log2FC <- sapply(terms_table$Termo, function(t) {
          if (gen %in% c("F0", "F3")) {
            mean(as.numeric(sig_genes_annot[[log2fc_col]][grepl(t, sig_genes_annot[[col]])]), na.rm = TRUE)
          } else {
            rows <- grepl(t, sig_genes_annot[[col]])
            mean(rowMeans(sig_genes_annot[rows, c(log2fc_col_F0, log2fc_col_F3)], na.rm = TRUE))
          }
        })
        
        terms_table
      }
      
      list(
        GO = process_terms("GO"),
        KEGG = process_terms("KEGG_pathway"),
        Table = sig_genes_annot
      )
    })
    
    # ---------- OUTPUTS ----------
    
    output$fe_interpretation <- renderText({
      req(enrichment_results())
      
      gen <- input$generation_fe
      sig_table <- enrichment_results()$Table
      n_sig <- nrow(sig_table)
      
      # Conta genes com anotações
      n_annot_GO <- sum(!is.na(sig_table$GO) & sig_table$GO != "")
      n_annot_KEGG <- sum(!is.na(sig_table$KEGG_pathway) & sig_table$KEGG_pathway != "")
      n_annot_EggNOG <- sum(!is.na(sig_table$EggNOG) & sig_table$EggNOG != "")
      
      perc_annot_GO <- ifelse(n_sig > 0, round(100 * n_annot_GO / n_sig, 2), 0)
      perc_annot_KEGG <- ifelse(n_sig > 0, round(100 * n_annot_KEGG / n_sig, 2), 0)
      perc_annot_EggNOG <- ifelse(n_sig > 0, round(100 * n_annot_EggNOG / n_sig, 2), 0)
      
      # Número de termos enriquecidos
      n_GO <- nrow(enrichment_results()$GO)
      n_KEGG <- nrow(enrichment_results()$KEGG)
      
      paste0(
        "Functional enrichment analysis for generation ", gen, ": ",
        n_sig, " genes passed the threshold (log2FC > ", input$lfc_threshold_fe, 
        " and padj < ", input$pval_threshold_fe, "). ",
        "Among these, ", n_annot_EggNOG, " (", perc_annot_EggNOG, "%) had EggNOG annotation, ",
        n_annot_GO, " (", perc_annot_GO, "%) had GO annotation, and ",
        n_annot_KEGG, " (", perc_annot_KEGG, "%) had KEGG annotation. ",
        "From the annotated genes, we identified ", n_GO, " enriched GO terms and ", 
        n_KEGG, " enriched KEGG pathways."
      )
    })
    
    
    # --- Barplot ---
    
    fe_barplot <- reactive({
      req(enrichment_results())
      
      top_n <- input$top_n_terms
      
      terms_df <- rbind(
        data.frame(enrichment_results()$GO, Category = "GO"),
        data.frame(enrichment_results()$KEGG, Category = "KEGG")
      )
      
      terms_df <- terms_df[!is.na(terms_df$Termo) & terms_df$Termo != "", ]
      
      validate(
        need(nrow(terms_df) > 0, "⚠️ Nenhum termo enriquecido encontrado para os filtros atuais.")
      )
      
      terms_top <- do.call(rbind, lapply(split(terms_df, terms_df$Category), function(x) {
        if (nrow(x) == 0) return(NULL)
        head(x[order(-x$Count), ], top_n)
      }))
      
      if (is.null(terms_top) || nrow(terms_top) == 0) return(NULL)
      
      ggplot(terms_top, aes(x = reorder(Termo, Count), y = Count)) +
        geom_col(fill = "steelblue", width = 0.7) +
        coord_flip() +
        facet_wrap(~Category, scales = "free") +
        labs(x = "", y = "Number of genes") +
        theme_minimal(base_size = 8) +  # 🔥 base de texto menor ainda
        theme(
          axis.text.y = element_text(size = 8),      # 🔥 labels muito pequenas
          axis.text.x = element_text(size = 8),
          strip.text = element_text(size = 12, face = "bold"),
          plot.margin = margin(5, 5, 5, 5)
        )
    })
    
    # --- Renderiza o gráfico no UI ---
    output$fe_barplot <- renderPlot({
      fe_barplot()
    })
    
    # --- Download usa o mesmo objeto ---
    output$download_fe_barplot <- downloadHandler(
      filename = function() {
        paste0("Top_Enriched_Barplot_", input$generation_fe, ".png")
      },
      content = function(file) {
        req(fe_barplot())
        
        # Ajusta altura proporcional ao número de termos
        terms_df <- rbind(
          data.frame(enrichment_results()$GO, Category = "GO"),
          data.frame(enrichment_results()$KEGG, Category = "KEGG")
        )
        terms_df <- terms_df[!is.na(terms_df$Termo) & terms_df$Termo != "", ]
        top_n <- input$top_n_terms
        
        terms_top <- do.call(rbind, lapply(split(terms_df, terms_df$Category), function(x) {
          if (nrow(x) == 0) return(NULL)
          head(x[order(-x$Count), ], top_n)
        }))
        
        n_terms <- nrow(terms_top)
        plot_height <- max(5, n_terms * 0.35)  # 🔥 mais compacto por termo
        plot_width <- 17  # 🔹 largura maior
        
        ggsave(
          file,
          plot = fe_barplot(),
          width = 8,
          height = plot_height,
          dpi = 300
        )
      }
    )
    
    
    
    output$fe_barplot_interpretation <- renderText({
      req(enrichment_results())
      
      gen <- input$generation_fe
      top_n <- input$top_n_terms
      sig_table <- enrichment_results()$Table
      n_sig <- nrow(sig_table)
      
      # Coluna correta para protein
      protein_col <- if(gen == "Intersection") "Protein_F0" else "Protein"
      
      # Percentagens de anotação
      perc_protein <- round(100 * sum(!is.na(sig_table[[protein_col]]) & sig_table[[protein_col]] != "") / n_sig, 2)
      perc_eggnog  <- round(100 * sum(!is.na(sig_table$EggNOG) & sig_table$EggNOG != "") / n_sig, 2)
      perc_go      <- round(100 * sum(!is.na(sig_table$GO) & sig_table$GO != "") / n_sig, 2)
      perc_kegg    <- round(100 * sum(!is.na(sig_table$KEGG_pathway) & sig_table$KEGG_pathway != "") / n_sig, 2)
      
      paste0(
        "The barplot shows the top ", top_n, " enriched functional terms for generation ", gen, 
        ". Bars represent the number of genes associated with each term. ",
        "Of the ", n_sig, " differentially expressed genes , ", perc_protein, "% were annotated to NCBI NR (Protein), ",
        perc_eggnog, "% had EggNOG annotations, ", perc_go, "% were assigned GO terms, and ", perc_kegg, 
        "% were linked to KEGG pathways. ",
        "This visualization highlights the most prominent biological processes (GO) and pathways (KEGG) affected in this generation."
      )
    })
    
    output$download_fe_barplot <- downloadHandler(
      filename = function() {
        paste0("Top_Enriched_Barplot_", input$generation_fe, ".png")
      },
      content = function(file) {
        req(fe_barplot())
        
        # Conta quantos termos serão plotados
        terms_df <- rbind(
          data.frame(enrichment_results()$GO, Category = "GO"),
          data.frame(enrichment_results()$KEGG, Category = "KEGG")
        )
        terms_df <- terms_df[!is.na(terms_df$Termo) & terms_df$Termo != "", ]
        top_n <- input$top_n_terms
        
        terms_top <- do.call(rbind, lapply(split(terms_df, terms_df$Category), function(x) {
          if (nrow(x) == 0) return(NULL)
          head(x[order(-x$Count), ], top_n)
        }))
        
        n_terms <- nrow(terms_top)
        
        # Ajusta altura dinamicamente (mínimo de 6, aumenta se houver muitos termos)
        plot_height <- max(6, n_terms * 0.4)
        
        ggsave(file, plot = fe_barplot(), width = 8, height = plot_height, dpi = 300)
      }
    )
    
    
    # --- Table ---
    
    output$fe_table <- renderDT({
      req(enrichment_results())
      df <- enrichment_results()$Table
      
      cols_to_remove <- c(
        "baseMean", "lfcSE", "stat", "pvalue",
        "baseMean_F0", "lfcSE_F0", "stat_F0", "pvalue_F0",
        "baseMean_F3", "lfcSE_F3", "stat_F3", "pvalue_F3",
        "Protein_F3", "padj", "padj_F0", "padj_F3"
      )
      df <- df[, !(names(df) %in% cols_to_remove), drop = FALSE]
      
      # Formatar colunas numéricas
      num_cols <- sapply(df, is.numeric)
      df[num_cols] <- lapply(df[num_cols], format_num)
      

      # 🔥 Reordenar colunas (se existirem)
      col_order <- c(
        "gene", 
        "log2FoldChange", "log2FoldChange_F0", "log2FoldChange_F3",
        "Protein", "Protein_F0", "Protein_F3", "EggNOG", "Categoria", "GO", "KEGG_pathway", "EC_number"
      )
      col_order <- intersect(col_order, colnames(df))  # só mantém colunas que existem
      other_cols <- setdiff(colnames(df), col_order)   # resto das colunas (mantém no fim)
      df <- df[, c(col_order, other_cols), drop = FALSE]
      
      datatable(df, filter = "top", options = list(pageLength = 10), rownames = FALSE)
    })
    
    output$fe_table_interpretation <- renderText({
      req(enrichment_results())
      
      gen <- input$generation_fe
      sig_table <- enrichment_results()$Table
      n_sig <- nrow(sig_table)
      
      # Coluna correta para protein
      protein_col <- if(gen == "Intersection") "Protein_F0" else "Protein"
      
      # Contagem de genes anotados em cada database
      n_protein <- sum(!is.na(sig_table[[protein_col]]) & sig_table[[protein_col]] != "")
      perc_protein <- round(100 * n_protein / n_sig, 2)
      
      n_eggnog <- sum(!is.na(sig_table$EggNOG) & sig_table$EggNOG != "")
      perc_eggnog <- round(100 * n_eggnog / n_sig, 2)
      
      n_go <- sum(!is.na(sig_table$GO) & sig_table$GO != "")
      perc_go <- round(100 * n_go / n_sig, 2)
      
      n_kegg <- sum(!is.na(sig_table$KEGG_pathway) & sig_table$KEGG_pathway != "")
      perc_kegg <- round(100 * n_kegg / n_sig, 2)
      
      paste0(
        "The interactive table lists all ", n_sig, " differentially expressed genes for generation ", gen,
        " that passed the thresholds (log2FC > ", input$lfc_threshold_fe, 
        " and padj < ", input$pval_threshold_fe, "). ",
        "Among these, ", n_protein, " (", perc_protein, "%) were annotated to NCBI NR (Protein), ",
        n_eggnog, " (", perc_eggnog, "%) had EggNOG annotations, ",
        n_go, " (", perc_go, "%) were assigned GO terms, and ",
        n_kegg, " (", perc_kegg, "%) were linked to KEGG pathways. ",
        "This table provides a comprehensive overview of functional information and allows filtering and searching for specific genes or functional categories, facilitating a detailed exploration of the DEGs."
      )
    })
    
    
    
    output$download_fe_table <- downloadHandler(
      filename = function() {
        paste0("enrichment_", input$generation_fe, ".csv")
      },
      content = function(file) {
        req(enrichment_results())
        write.csv(enrichment_results()$Table, file, row.names = FALSE)
      }
    )
    
    
  }
  
  shinyApp(ui, server)
  
  

  
