library(fs)
library(purrr)
library(rmarkdown)
library(dplyr)
library(stringr)

repo_folder <- "dsb_repo"
repo <- "https://github.com/rstudio-education/datascience-box"
if(!dir_exists(repo_folder)) git2r::clone(repo, repo_folder)

slides_folder <- "slides"
if(!dir_exists(slides_folder)) dir_create(slides_folder)

source_slides <- path(repo_folder, "course-materials", "_slides")

c("setup.Rmd", "slides.css", "xaringan-themer.css", "xaringan-themer.R", "dsbox-hex.png") %>% 
  map(~{
    try(
      file_copy(path(source_slides, .x), path(slides_folder))  
    )
  })

c("u1-d01-welcome", "u2-d02-ggplot2", "u2-d06-grammar-wrangle", "u2-d12-data-import",
  "u2-d13-data-recode", "u2-d14-effective-dataviz", "u2-d18-web-scrape", "u2-d21-functions",
  "u2-d22-iteration", "u5-d03-interactive-web-app") %>% 
  map(~{
    try(
      dir_copy(path(source_slides, .x), path(slides_folder))
    )
    files_folder <- path(slides_folder, .x, paste0(.x, "_files"))
    if(dir_exists(files_folder)) dir_delete(files_folder)
    html_file <- path(slides_folder, .x, .x, ext = "html")
    if(file_exists(html_file)) file_delete(html_file)
  })

file_copy("slides.Rmd", slides_folder, overwrite = TRUE)

dir_info(slides_folder, recurse = 3, glob = "*.Rmd") %>%  
  filter(!str_detect(path, "setup")) %>%
  #head(1) %>% 
  pull(path) %>% 
  walk(~{
    temp_file <- path(tempfile(), ext = "R")
    writeLines(
      paste0("rmarkdown::render('", path_abs(.x),"', output_file = 'index.html')"), 
      con = temp_file
        )
    rstudioapi::jobRunScript(temp_file, name = .x)
  })

docs_slides <- path("docs/slides")


if(dir_exists(docs_slides)) dir_delete(docs_slides)
dir_copy(slides_folder, docs_slides)



